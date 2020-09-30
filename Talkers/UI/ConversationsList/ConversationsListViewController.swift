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
        return DummyDataSource.chat.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return DummyDataSource.chat[section].filter { !$0.isEmptyMessage }.count
        }
        return DummyDataSource.chat[section].count
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
        let message: MessageModel
        
        if indexPath.section == 1 {
            message = DummyDataSource.chat[indexPath.section].filter { !$0.isEmptyMessage }[indexPath.row]
        } else {
            message = DummyDataSource.chat[indexPath.section][indexPath.row]
        }
        
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
