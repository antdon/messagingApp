//
//  WebScoketManager.swift
//  mvc
//
//  Created by Anton on 21/6/2025.
//
import Starscream
import Foundation

class WebSocketManager: WebSocketDelegate {
    var socket: WebSocket!
    var isConnected = false
    let userName: String
    var recievedMessages = [Message]()
    let updateMessages: ([Message]) -> Void

    init(userName:String, updateMessages:@escaping ([Message]) -> Void) {
        self.userName = userName
        self.updateMessages = updateMessages
        var request = URLRequest(url: URL(string: APIConstantsPrivate.baseURL + "/connect")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }

    func connect() {
        print("Attempting to connect with Starscream...")
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func send(message: String) {
        if isConnected {
            socket.write(string: message)
        } else {
            print("Not connected. Cannot send message.")
        }
    }

    // MARK: - WebSocketDelegate
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("Starscream websocket is connected: \(headers)")
            send(message: userName)
        case .disconnected(let reason, let code):
            isConnected = false
            print("Starscream websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Starscream received text: \(string)")
        case .binary(let data):
            print("Starscream received data: \(data.count)")
            handleNewMessage(data: data)
            updateMessageModel(messages: recievedMessages)
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
            print("Starscream websocket cancelled")
        case .error(let error):
            isConnected = false
            handleError(error)
        case _:
            print(event)
            print("recieved some other websocket event")
        }
    }

    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("Starscream websocket encountered an WSerror: \(e.message)")
        } else if let e = error {
            print("Starscream websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("Starscream websocket encountered an unknown error")
        }
    }
    
    func handleNewMessage(data: Data) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let message = try? decoder.decode(Message.self, from: data) else {
            print("was unable to decode message")
            return
        }
        print("successfully decoded", message)
        recievedMessages.append(message)
    }
    
    func updateMessageModel(messages:[Message]) {
        print("updating message model with messages", messages)
        print("also we have a non nil update method", updateMessages)
        updateMessages(messages)
        recievedMessages = []
    }
}

