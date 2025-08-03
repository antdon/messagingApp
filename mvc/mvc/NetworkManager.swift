//
//  NetworkManager.swift
//  mvc
//
//  Created by Anton on 22/6/2025.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case encodingError(Error)
    case decodingError(Error)
    case unknownError(Error)
}

class NetworkManager {
    var websocketManager: WebSocketManager?
    let updateMessages: ([Message]) -> Void
    
    init(websocketManager: WebSocketManager? = nil, updateMessages: @escaping ([Message]) -> Void) {
        self.websocketManager = websocketManager
        self.updateMessages = updateMessages
    }

    func connectToWebSocket(forUser userName:String) {
        websocketManager = websocketManager ?? WebSocketManager(userName: userName, updateMessages: updateMessages)
        websocketManager?.connect()
    }
    
    func sendToServer(message:Message) -> AnyPublisher<Void, NetworkError> {
        guard let url = URL(string: APIConstantsPrivate.baseURL + "/send") else {
            return Fail(error:NetworkError.networkError(NSError(domain:"Network Error", code:URLError.badURL.rawValue))).eraseToAnyPublisher()
        }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let messageData = try? encoder.encode(message) else {
            return Fail(error: NetworkError.encodingError(NSError(domain: "EncodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode post data."]))).eraseToAnyPublisher()
        }
        print("sending", message)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = messageData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.invalidResponse
                }
            }
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.unknownError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
}
