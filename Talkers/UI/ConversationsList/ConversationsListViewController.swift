//
//  ConversationsListViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)
    
    @IBOutlet weak var conversationsListTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // needed to clear the text in the back navigation
        self.navigationItem.title = " "
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Tinkoff Chat"
    }
    
    // MARK: - IBAction
    
    @IBAction func profileIconTapped(_ sender: Any) {
        if let profileViewController = ProfileViewController.storyboardInstance() {
            present(profileViewController, animated: true)
        }
    }
    
    @IBAction func settingsIconTapped(_ sender: Any) {
        if let themesViewController = ThemesViewController.storyboardInstance() {
            navigationController?.pushViewController(themesViewController, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DummyConversationListDataSource.getSectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DummyConversationListDataSource.getConversationsCount(for: section)
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
        let message = DummyConversationListDataSource.getConversation(by: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellIdentifier,
                for: indexPath) as? ConversationsListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: message)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let conversationViewController = ConversationViewController.storyboardInstance() {
            conversationViewController.messageModel = DummyConversationListDataSource.getConversation(by: indexPath)
            
            navigationController?.pushViewController(conversationViewController, animated: true)
        }
    }
}

// MARK: - Instantiation from storybord

extension ConversationsListViewController {
    static func storyboardInstance() -> ConversationsListViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ConversationsListViewController
    }
}

// MARK: - Private

extension ConversationsListViewController {
    private func configureTableView() {
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
