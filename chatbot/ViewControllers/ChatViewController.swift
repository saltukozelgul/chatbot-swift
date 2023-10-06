//
//  ViewController.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 5.10.2023.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    var chat : Chat?
    
    private var messages: [Message] = [] {
        didSet {
            tableView.reloadData()
            tableView.scrollToBottom()
        }
        
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerCell(ChatMessageCell.self)
        }
    }
    
    @IBOutlet private weak var messageTextField: UITextField! {
        didSet {
            messageTextField.delegate = self
            messageTextField.returnKeyType = .send
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Notification setup for keyboard listen
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // For detect tap on outside of textfield
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
        fetchMessages()
    }
    
    func fetchMessages () {
        guard let chat = chat else { return }
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true) // Adjust sorting as needed
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "chat == %@", chat)
        do {
            let context = CoreDataStack.shared.context // Replace with your CoreData context
            let temp = try context.fetch(fetchRequest)
            messages = temp
        } catch {
            print(error)
        }
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Check if the tap occurred outside of the UITextField
        if !messageTextField.frame.contains(sender.location(in: view)) {
            // The tap occurred outside of the text field, so dismiss the keyboard or perform any other desired actions
            messageTextField.resignFirstResponder()
        }
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
            if let bottomConstraint = view.constraints.first(where: {$0.identifier == "keyboard"}) {
                bottomConstraint.constant = keyboardHeight
            }
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        if let bottomConstraint = view.constraints.first(where: {$0.identifier == "keyboard"}) {
            bottomConstraint.constant = 0
        }
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}

// MARK - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatMessageCell.self), for: indexPath) as? ChatMessageCell {
            cell.configure(with : messages[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

// MARK - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            if let chat {
                let chatManager = ChatManager(chat: chat)
                chatManager.addMessage(text: text, sender: "user") { result in
                    switch result {
                        case .success(let message):
                            print(message)
                            self.messages.append(message)
                            // Request a bot response
                            APIClient.shared.generateResponse(prompt: text, maxTokens: 100, temperature: 0.5) { result in
                                switch result {
                                    case .success(let response):
                                        print(response)
                                        // Add the bot's response
                                        chatManager.addBotResponse(text: response.choices?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") { result in
                                            switch result {
                                                case .success(let botResponse):
                                                    print(botResponse)
                                                    self.messages.append(botResponse)
                                                    // Update UI or perform additional actions as needed
                                                case .failure(let error):
                                                    print("Error adding bot response: \(error)")
                                            }
                                        }
                                    case .failure(let error):
                                        print("API Error: \(error)")
                                }
                            }
                        case .failure(let error):
                            print("Error adding user message: \(error)")
                    }
                }
            }
  
            textField.text = ""
        }
        return true
    }
}

