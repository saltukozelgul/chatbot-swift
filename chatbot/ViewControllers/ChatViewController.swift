//
//  ViewController.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 5.10.2023.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    var chat : Chat? {
        didSet {
            chatManager = ChatManager(chat: chat!)
        }
    }
    private var chatManager : ChatManager?
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
            tableView.keyboardDismissMode = .onDrag
            
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
        if let chat {
            messages = CoreDataStack.shared.getMessages(chat)
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
        if messages.isEmpty {
            tableView.setEmptyView(title: Strings.noMessagesTitle, message: Strings.noMessagesDetail)
        } else {
            tableView.restoreBackground()
        }
        return messages.count
    }
}

// MARK - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatMessageCell.self), for: indexPath) as? ChatMessageCell {
            cell.configure(with : messages[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

// MARK - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            if let chatManager {
                chatManager.addMessage(text: text, url: "", sender: "user") { result in
                    switch result {
                        case .success(let message):
                            print(message)
                            self.messages.append(message)
                            // If text has any imageGenerationCommands in it
                            self.messages.append(chatManager.addLoadingMessage())
                            let commands = APIClient.shared.imageGenerateCommands
                            if commands.contains(where: { text.contains($0) }) {
                                self.handleImageGenerationCommand(text)
                            } else {
                                self.handleResponseGeneration(text)
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

// MARK: - Handle Functions
extension ChatViewController {
    // Function to handle user's message with image generation commands
    func handleImageGenerationCommand(_ message: String) {
        APIClient.shared.generateImage(prompt: message, imageCount: 1, size: "512x512") { result in
            switch result {
                case .success(let response):
                    self.chatManager?.addImageResponse(url: response.data?.first?.url ?? "", completion: { result in
                        switch result {
                            case .success(let botResponse):
                                self.messages.removeLast()
                                self.messages.append(botResponse)
                            case .failure(let error):
                                print("Error adding bot response: \(error)")
                        }
                    })
                case .failure(let error):
                    self.messages.removeLast()
                    print("API Error: \(error)")
            }
        }
    }
    
    
    // Function to handle user's message without image generation commands
    func handleResponseGeneration(_ message: String) {
        APIClient.shared.generateResponse(prompt: message, maxTokens: 1024, temperature: 0.5) { result in
            switch result {
                case .success(let response):
                    // Add the bot's response
                    self.chatManager?.addBotResponse(text: response.choices?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") { result in
                        switch result {
                            case .success(let botResponse):
                                self.messages.removeLast()
                                self.messages.append(botResponse)
                                // Update UI or perform additional actions as needed
                            case .failure(let error):
                                print("Error adding bot response: \(error)")
                        }
                    }
                case .failure(let error):
                    self.messages.removeLast()
                    print("API Error: \(error)")
            }
        }
    }

}
