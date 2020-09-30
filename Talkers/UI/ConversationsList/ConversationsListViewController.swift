//
//  ConversationsListViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

typealias MessageModel = ConversationsListTableViewCell.ConversationCellModel

class ConversationsListViewController: UIViewController {
    
    let chat = [[MessageModel(
                    name: "Лев Толстой",
                    message: "Последнее время мне стало жить тяжело. Я вижу, я стал понимать слишком много.",
                    date: Date(),
                    isOnline: true,
                    hasUnreadMessage: true),
                 MessageModel(
                    name: "Сергей Довлатов",
                    message: "",
                    date: Date(),
                    isOnline: true,
                    hasUnreadMessage: false)],
                [MessageModel(
                    name: "Иван Тургенев",
                    message: "Как все русские дворяне, он в молодости учился музыке и, как почти все русские дворяне, играл очень плохо; но он страстно любил музыку.",
                    date: Date(),
                    isOnline: false,
                    hasUnreadMessage: false)]]
    
    private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)
    
    @IBOutlet weak var conversationsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Tinkoff Chat"
        
        conversationsListTableView.delegate = self
        conversationsListTableView.dataSource = self
        conversationsListTableView.tableFooterView =
            UIView(frame: CGRect(x: 0,
                                 y: 0,
                                 width: conversationsListTableView.frame.size.width,
                                 height: 1))
        conversationsListTableView.register(UINib(
                                                nibName: cellIdentifier,
                                                bundle: nil),
                                            forCellReuseIdentifier: cellIdentifier)
    }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return chat.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "Online"
            case 1:
                return "History"
            default:
                return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chat[indexPath.section][indexPath.row]
        // TODO не отображать пустые диалоги
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellIdentifier, for: indexPath)
                as? ConversationsListTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(with: message)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
}

// MARK: - Instantiation from storybord

extension ConversationsListViewController {
    static func storyboardInstance() -> ConversationsListViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ConversationsListViewController
    }
}
