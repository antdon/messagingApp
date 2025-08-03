//
//  Constants.swift
//  mvc
//
//  Created by Anton on 3/8/2025.
//

import Foundation

import Foundation

protocol APIConstants {
    static var baseURL: String { get }
}

extension APIConstants {
    static var baseURL: String {
        #if DEBUG
        fatalError("APIConstantsPrivate.baseURL has not been defined in a concrete class. You should define an extension to the concrete class with your url and port")
        #else
        return URL(string: "http://api.production.com")!
        #endif
    }
}

enum APIConstantsPrivate {}
