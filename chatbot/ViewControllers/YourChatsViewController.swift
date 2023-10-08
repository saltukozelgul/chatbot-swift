//
//  YourChatsViewController.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 6.10.2023.
//

import UIKit
import CoreData


class YourChatsViewController: UIViewController, UITableViewDelegate {
    
    var chats: [Chat] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBAction func newChatButtonTapped(_ sender: Any) {
        // get a name from user with alert
        let alert = UIAlertController(title: Strings.newChat, message: Strings.enterName, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: Strings.okButton, style: .default, handler: { [weak alert] (_) in
            guard let name = alert?.textFields?[0].text else { return }
            CoreDataStack.shared.createChat(name)
            // Fetch the updated chat list
            self.chats = CoreDataStack.shared.fetchChats()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        chats = CoreDataStack.shared.fetchChats()
    }
}

extension YourChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chats.isEmpty {
            tableView.setEmptyView(title: Strings.noChat, message: Strings.addChat)
        } else {
            tableView.restoreBackground()
        }
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = chats[indexPath.row].title
        cell.imageView?.image = UIImage(systemName: "message.fill")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToChatDetail(chats[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let chat = chats[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: Strings.delete) { [weak self] (_, _, _) in
            CoreDataStack.shared.deleteChat(chat)
            self?.chats = CoreDataStack.shared.fetchChats()
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

