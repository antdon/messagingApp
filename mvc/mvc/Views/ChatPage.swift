//
//  ChatPage.swift
//  mvc
//
//  Created by Antdon on 21/6/2025.
//

import UIKit

class ChatPage : UIViewController {
    
    private lazy var messageBox = {
        let messageBox = MessageBox(sendMethod: self.delegate!.send(text:))
        messageBox.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        messageBox.layer.borderWidth = 2
        messageBox.layer.cornerRadius = 22
        messageBox.clipsToBounds = true
        return messageBox
    }()
    
    private let messageList : MessageList
    
    private weak var delegate: ChatPageDelegate?
    
    init(delegate: ChatPageDelegate, displayedMessages:[Message], userName:String) {
        self.delegate = delegate
        self.messageList = MessageList(displayedMessages: displayedMessages, userName: userName)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        layoutMessageBox()
        layoutMessageList()
    }
    
    func update(messages:[Message]) {
        messageList.update(messages: messages)
    }
    
    
    private func layoutMessageBox() {
        view.addSubview(messageBox)
        messageBox.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-15)
        }
    }
    
    private func layoutMessageList() {
        view.addSubview(messageList)
        messageList.transform = CGAffineTransform(rotationAngle: .pi)
        messageList.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(messageBox.snp.top)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}


protocol ChatPageDelegate: AnyObject {
    @MainActor
    func send(text:String) async
}


