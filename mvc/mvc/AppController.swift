//
//  ViewController.swift
//  mvc
//
//  Created by Anton on 16/6/2025.
//

import UIKit
import SnapKit
import SwiftUI
import Combine

@MainActor
class AppControler: ChatPageDelegate {
    private lazy var networkManger = NetworkManager(updateMessages: messageModel.updateMessageList(newMessages:))
    private var pages = [String:UIViewController]()
    private var messageModel = MessagesModel(
        summarizer: SummaryServiceImpl()
    )
    private let navigationController: UINavigationController
    private var userName:String?
    private var currentChannel:String?
    private var displayedMessages = [String:[Message]]()
    private var cancellables = Set<AnyCancellable>()
    
    
    init(navigationController:UINavigationController, pages: [String : UIViewController] = [String:UIViewController]()) {
        self.pages = pages
        self.navigationController = navigationController
//        self.messageModel.messagesPublisher
        self.messageModel.$messages
            .sink { updatedMessages in
                print("sink called")
                self.displayedMessages = updatedMessages
                guard let currentChannel = self.currentChannel else { print("trying to update display without channel"); return }
                if let chatPage = self.pages["chat"] as? ChatPage {
                    chatPage.update(messages: self.displayedMessages[currentChannel, default: []])
                }
            }
            .store(in: &cancellables)
        if let userName = self.userName {
            enterChannelPage()
        } else {
            let entrancePage = UIHostingController(rootView:EntrancePage(onButtonPressed: { userName in
                self.userName = userName
                self.enterChannelPage()
            }))
            self.pages["entrance"] = entrancePage
            self.navigationController.pushViewController(entrancePage, animated: false)
        }
    }
        
        

    
    private func startChatting() {
        guard let userName = self.userName else { return }
        guard let currentChannel else { return }
        
        // make sure you don't have a reference cycle here
        // TODO: we need to include the channel here
        let chatPage = ChatPage(delegate: self, displayedMessages: displayedMessages[currentChannel, default: []], userName: userName)
        pages["chat"] = chatPage
        navigationController.pushViewController(chatPage, animated: true)
    }
    
    private func enterChannelPage() {
        guard let userName = self.userName else { return }
        if userName.isEmpty {
            // probably do a toast or something
            return
        }
        networkManger.connectToWebSocket(forUser: userName)
        let channelsPage = UIHostingController(rootView: ChannelsPage(messagesModel: messageModel) { channel in
            self.currentChannel = channel
            self.startChatting()
        })
        pages["channel"] = channelsPage
        navigationController.pushViewController(channelsPage, animated: true)
    }
    
    // ChatPageDelegate
    func send(text: String) async {
        guard let currentChannel else { print("Trying to send message without channel"); return }
        let message = Message(sender: userName!, message: text, channel: currentChannel)
        print("added to the message model", message, "in channel", currentChannel)
        messageModel.addMessageTo(channel: currentChannel, message: message)
        let sendMessagePublisher = networkManger.sendToServer(message: message)
        sendMessagePublisher.sink { @Sendable completion in
            switch completion {
            case .finished:
                print("sent message to server successfully")
            case .failure(let error):
                print("there was some fucking error")
                print(error)
            }
        } receiveValue: {@Sendable _ in}
            .store(in: &cancellables)
    }
    
    
    nonisolated static func isDebug() -> Bool {
        return true
    }
}


