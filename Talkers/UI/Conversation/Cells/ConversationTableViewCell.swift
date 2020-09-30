//
//  ConversationTableViewCell.swift
//  Talkers
//
//  Created by Natalia Kazakova on 30.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

typealias MessageModel = ConversationTableViewCell.MessageCellModel

class ConversationTableViewCell: UITableViewCell {
    
    enum MessageType {
        case incoming, outgoing
    }
    
    struct MessageCellModel {
        let text: String
        let type: MessageType
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
}

// MARK: - ConfigurableView

extension ConversationTableViewCell: ConfigurableView {
    typealias ConfigurationModel = MessageCellModel
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        
        containerView.layer.cornerRadius = 8.0
        containerView.clipsToBounds = true
    }
}
