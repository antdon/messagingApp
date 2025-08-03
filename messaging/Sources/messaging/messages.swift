//
//  messages.swift
//  messaging
//
//  Created by Anton on 18/6/2025.
//
import Vapor

struct Message: Content {
    var sender: String
    var message: String
    var channel: String
}
