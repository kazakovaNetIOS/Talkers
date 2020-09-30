//
//  ConversationsListTableViewCell.swift
//  Talkers
//
//  Created by Natalia Kazakova on 30.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}

class ConversationsListTableViewCell: UITableViewCell {
    
    struct ConversationCellModel {
        let name: String
        let message: String
        let date: Date
        let isOnline: Bool
        let hasUnreadMessage: Bool
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}

// MARK: - ConfigurableView

extension ConversationsListTableViewCell: ConfigurableView {
    typealias ConfigurationModel = ConversationCellModel
    
    func configure(with model: ConversationCellModel) {
        setName(with: model.name)
        setMessage(with: model.message, model.hasUnreadMessage)
        setDate(with: model.date)
        setIsOnline(with: model.isOnline)
    }
    
    private func setName(with name: String) {
        nameLabel?.text = name
    }
    
    private func setMessage(with message: String, _ hasUnreadMessage: Bool) {
        lastMessageLabel?.text = message == "" ? "No message yet" : message
        // TODO изменить шрифт если нет сообщения
        lastMessageLabel?.font = hasUnreadMessage ?
            UIFont(name: "SF Pro Text Semibold", size: 13.0) :
            UIFont(name: "SF Pro Text Regular", size: 13.0)
    }
    
    private func setDate(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        // TODO сравнение дат по дням
        let dateTemplate = date < Date() ? "dd MMM" : "HH:mm"
        dateFormatter.setLocalizedDateFormatFromTemplate(dateTemplate)
        dateLabel?.text = dateFormatter.string(from: date)
    }
    
    private func setIsOnline(with isOnline: Bool) {
        contentView.backgroundColor = isOnline ? #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0.1) : #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }
}
