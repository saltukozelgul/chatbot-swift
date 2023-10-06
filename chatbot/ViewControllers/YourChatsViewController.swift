//
//  YourChatsViewController.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 6.10.2023.
//

import UIKit
import CoreData


class YourChatsViewController: UIViewController, UITableViewDelegate {
    
    var chats: [Chat] = []
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBAction func newChatButtonTapped(_ sender: Any) {
        // get a name from user with alert
        let alert = UIAlertController(title: "New Chat", message: "Enter a name for this chat", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let name = alert?.textFields?[0].text else { return }
            
            // Create a new chat object
            let chat = Chat(context: CoreDataStack.shared.context)
            chat.title = name
            chat.lastEdited = Date()
            
            // Save the new chat object
            CoreDataStack.shared.saveContext()
            
            // Fetch the updated chat list
            self.fetchUserChats()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchUserChats()
    }
    
    func fetchUserChats() {
        let fetchRequest = NSFetchRequest<Chat>(entityName: "Chat")
        let sortDescriptor = NSSortDescriptor(key: "lastEdited", ascending: false) // Adjust sorting as needed
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let context = CoreDataStack.shared.context // Replace with your CoreData context
            let temp = try context.fetch(fetchRequest)
            chats = temp
            tableView.reloadData()
        } catch {
            print("Error fetching chat data: \(error)")
        }
    }
    
}

extension YourChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = chats[indexPath.row].title
        cell.imageView?.image = UIImage(systemName: "message.fill")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToChatDetail(chats[indexPath.row])
    }
}

