import Vapor

actor UserSessionManager {
    private var users = [String:WebSocket]()
    let encoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    func addUser(id: String, ws: WebSocket) {
        users[id] = ws
    }
    
    func removeUser(id:String) {
        users.removeValue(forKey: id)
    }
    
    
    func sendToUsers(messages:[Message]) {
        print("sending to users", users)
        print("current messages", messages)
        var disconnectUsers = [String]()
        for (user,ws) in users {
            if ws.isClosed {
                disconnectUsers.append(user)
                continue
            }
            for message in messages {
                guard let messageData = try? encoder.encode(message) else { print("failed to encode message", message); continue }
                ws.send(messageData)
                print("sent", message)
            }
        }
        disconnectUsers.forEach { user in users.removeValue(forKey: user) }
    }
    
    func update(user:String, messages:[Message]) {
        guard let ws = users[user] else { print("couldnt find user"); return }
        if ws.isClosed {
            users.removeValue(forKey: user)
        }
        for message in messages {
            guard let messageData = try? encoder.encode(message) else { print("failed to encode message", message); continue }
            ws.send(messageData)
            print("sent", message)
        }
        
    }
}

actor Messages {
    private var messages = [Message]()
    private let userSessionManager: UserSessionManager
    
    init(messages: [Message] = [Message](), userSessionManager: UserSessionManager) {
        self.messages = messages
        self.userSessionManager = userSessionManager
    }
    
    func add(message:Message) async {
        messages.append(message)
        await userSessionManager.sendToUsers(messages: messages)
    }
    
    func updateMessageList(user:String) async {
        await userSessionManager.update(user: user, messages: messages)
    }
    
}

func routes(_ app: Application) throws {
    let userSessionManager = UserSessionManager()
    let messages = Messages(userSessionManager: userSessionManager)
    
    app.routes.caseInsensitive = true
    
    app.post("send") { req in
        do {
            let message = try req.content.decode(Message.self)
            print("message recieved ", message)
            await messages.add(message: message)
        } catch {
            print("something went wrong in the message decoding")
            return HTTPStatus.badRequest
        }

        return HTTPStatus.accepted
    }
    
    app.webSocket("connect") { [] req, ws in
        print("connected to websocket")
        print(ws)
        ws.onText { context, userName in
            await userSessionManager.addUser(id: userName, ws: ws)
            print("added user ", userName, " to session")
            await messages.updateMessageList(user: userName)
            print("called updateMessageList on connection")
        }
    }
    
    app.webSocket("echo") { [] req, ws in
        print("connected to websocket")
        print(ws)
        await userSessionManager.addUser(id: "anton", ws: ws)
        
        ws.onClose.whenComplete { _ in
            Task {
                await userSessionManager.removeUser(id: "anton")
            }
        }
    }
}

struct Greeting: Content {
    var hello: String
}
