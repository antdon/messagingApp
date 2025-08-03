//
//  MessageBox.swift
//  mvc
//
//  Created by Anton on 22/6/2025.
//
import UIKit
import SnapKit

class MessageBox : UIView, UITextFieldDelegate {
    
    let sendButton = {
        let sendButton = UIButton()
        let planeIcon = UIImage(systemName: "paperplane")
        sendButton.setImage(planeIcon, for: .normal)
        return sendButton
    }()
    
    let textInput = {
        let textInput = UITextField()
        textInput.backgroundColor = .white
        textInput.textColor = .black
        return textInput
    }()
    
    
    init(sendMethod:@escaping(String) async -> Void) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textInput.delegate = self
        layoutSendButton()
        layoutTextInput()
        sendButton.addAction(UIAction { [weak self] action in
            Task {
                print(self?.textInput.text)
                if let messageContent = self?.textInput.text, messageContent != "" {
                    await sendMethod(messageContent)
                }
                self?.clearText()
            }
        }, for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTo(view:UIView) {
    }
    
    func clearText() {
        self.textInput.text = ""
    }
    
    private func layoutSendButton() {
        self.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        }
    }
    
    private func layoutTextInput() {
        self.addSubview(textInput)
        textInput.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview().priority(.low)
            make.left.equalToSuperview().inset(15)
            make.right.equalTo(sendButton.snp.left).offset(-15)
        }
    }
    
    // UITextFieldDelegate
    
    
    
    
}

