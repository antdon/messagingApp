//
//  Models.swift
//  mvc
//
//  Created by Anton on 22/6/2025.
//

import Foundation

struct Message: Codable, Equatable {
    let sender:String
    let message:String
    let channel:String
}

struct Channel {
    let channelName: String
    let summary: String
}
