//
//  MessageList.swift
//  mvc
//
//  Created by Anton on 22/6/2025.
//

import UIKit
import SnapKit

class MessageList : UITableView, UITableViewDataSource, UITableViewDelegate {
    private var displayedMessages : [Message]
    private let userName: String

    init(displayedMessages: [Message], userName:String) {
        self.displayedMessages = displayedMessages.reversed()
        self.userName = userName
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        dataSource = self
        delegate = self
        separatorStyle = .none
        backgroundColor = .white
        rowHeight = UITableView.automaticDimension
        register(TheirMessageCell.self, forCellReuseIdentifier: "theirMessageCell")
        register(MyMessageCell.self, forCellReuseIdentifier: "myMessageCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(messages:[Message]) {
        displayedMessages = messages.reversed()
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(displayedMessages.count)
        return displayedMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = displayedMessages[indexPath.row]
        var cell: MessageCell?
        if message.sender == userName {
            cell = tableView.dequeueReusableCell(withIdentifier: "myMessageCell", for: indexPath) as? MessageCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "theirMessageCell", for: indexPath) as? MessageCell
        }
        if var cell {
            cell.message = displayedMessages[indexPath.row]
            return cell
        }
        fatalError()
    }
}

class TheirMessageCell : UITableViewCell, MessageCell {
    var message : Message? {
        didSet {
            label.text = message?.message
        }
    }
    let label = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.transform = CGAffineTransform(rotationAngle: .pi)
        self.selectionStyle = .none
        contentView.addSubview(label)
        layoutLabel(messageType: .theirMessage, label: label)
        let messageView = UIView()
        messageView.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 238/255, alpha: 1)
        messageView.layer.cornerRadius = 15
        contentView.addSubview(messageView)
        layoutMessageView(messageType: .theirMessage, messageView)
        contentView.bringSubviewToFront(label)
        backgroundColor = .white
    }
    
    private func layoutMessageView(messageType:MessageType, _ messageView:UIView) {
        messageView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(safeAreaLayoutGuide.snp.width).dividedBy(2)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.width.greaterThanOrEqualTo(label).offset(20)
            make.height.greaterThanOrEqualTo(label).offset(15)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyMessageCell : UITableViewCell, MessageCell {

    var message : Message? {
        didSet {
            label.text = message?.message
        }
    }
    let label = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.transform = CGAffineTransform(rotationAngle: .pi)
        self.selectionStyle = .none
        contentView.addSubview(label)
        layoutLabel(messageType: .myMessage, label: label)
        let messageView = UIView()
        messageView.backgroundColor = UIColor(red: 27/255, green: 144/255, blue: 1, alpha: 1)
        messageView.layer.cornerRadius = 15
        contentView.addSubview(messageView)
        layoutMessageView(messageType: .myMessage, messageView)
        contentView.bringSubviewToFront(label)
        backgroundColor = .white
    }
    
    private func layoutMessageView(messageType:MessageType, _ messageView:UIView) {
        messageView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(safeAreaLayoutGuide.snp.width).dividedBy(2)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.width.greaterThanOrEqualTo(label).offset(20)
            make.height.greaterThanOrEqualTo(label).offset(15)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@MainActor
private func layoutLabel(messageType:MessageType, label:UILabel) {
    label.snp.makeConstraints { make in
        make.centerY.equalToSuperview()
        switch messageType {
        case .theirMessage: make.left.equalToSuperview().inset(23)
        case .myMessage: make.right.equalToSuperview().inset(23)
        }
    }
}

@MainActor
private func styleMessage(_ messageView:UIView) {
}

enum MessageType {
    case myMessage
    case theirMessage
}

@MainActor
protocol MessageCell: UITableViewCell {
    var message:Message? { get set }
}


