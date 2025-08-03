//
//  SummaryService.swift
//  mvc
//
//  Created by Anton on 14/7/2025.
//

import Foundation

protocol SummaryService {
    func summarize(messages:[Message]) -> String
}

struct SummaryServiceImpl: SummaryService {
    func summarize(messages: [Message]) -> String {
        // TODO put real summary here
        return messages.first?.sender ?? "summary"
    }
}
