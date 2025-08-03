//
//  MessagesModel.swift
//  mvc
//
//  Created by Anton on 22/6/2025.
//

import Foundation
import Combine

class MessagesModel: ObservableObject {
    @Published var messages =  !AppControler.isDebug() ? [String:[Message]]() : mockMessages()
    
    
    let messagesPublisher = PassthroughSubject<[String:[Message]], Never>()
    let summarizer: SummaryService
    init(summarizer:SummaryService) {
        self.summarizer = summarizer
    }

    func addMessageTo(channel:String, message:Message) {
        messages[channel, default: []].append(message)
//        messagesPublisher.send(messages)
    }
    
    func updateMessageList(newMessages:[Message]) {
        print("updating the message model with", newMessages)
        for message in newMessages {
            var channelList = messages[message.channel, default: []]
            if channelList.contains(message) {
                continue
            }
            // TODO: this should be sorted by date or something
            channelList.append(message)
            messages[message.channel] = channelList
        }
    }
    
    func channels() -> [Channel] {
        print(messages)
        return messages.keys.map { channel in
            Channel(channelName: channel, summary: summarizer.summarize(messages: messages[channel, default: []])) }
    }
    
    static private func mockMessages() -> [String:[Message]] {
        return ["Antons Channel" : [Message(sender: "Anton", message: "This is a test", channel: "Antons Channel"),
                             Message(sender: "Haeli", message: "Oh is it?", channel: "Antons Channel"),
                             Message(sender: "Anton", message: "Yeah dude it's literally mock data", channel: "Antons Channel")],
        "Haeli's Channel" : [Message(sender: "Anton", message: "This is a test", channel: "Haeli's Channel"),
                             Message(sender: "Haeli", message: "Oh is it?", channel: "Haeli's Channel"),
                             Message(sender: "Anton", message: "Yeah dude it's literally mock data", channel: "Haeli's Channel")]]
    }
    
}
