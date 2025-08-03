//
//  EntrancePage.swift
//  mvc
//
//  Created by Anton on 21/6/2025.
//

import Foundation
import SwiftUI

struct EntrancePage: View {
    @State private var userName = ""
    @State private var showError = false
    let onButtonPressed: (String) -> Void
    
    init(userName: String = "", onButtonPressed:@escaping (String) -> Void) {
        self.userName = userName
        self.onButtonPressed = onButtonPressed
    }
    
    var body: some View {
        VStack {
            Spacer()
            if (showError) {
                Text("You Need to enter a userName").foregroundStyle(Color.red)
            }
            TextField("UserName", text: $userName)
                .padding()
                .textFieldStyle(.roundedBorder)
            Button("Start Chatting") {
                if userName.isEmpty {
                    if showError {
                        return
                    }
                    showError = true
                    return
                }
                self.onButtonPressed(userName)
            }
            Spacer()
        }.background(Color.white)
    }
}
