//
//  ChatManager.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 6.10.2023.
//

import Foundation
import CoreData

class ChatManager {
    let chat: Chat
    
    init(chat: Chat) {
        self.chat = chat
    }
    
    func addMessage(text: String, sender: String, completion: @escaping (Result<Message, Error>) -> Void) {
        let context = CoreDataStack.shared.context
        let message = Message(context: context)
        message.text = text
        message.timestamp = Date()
        message.sender = sender
        message.chat = chat
        chat.lastEdited = Date()
        
        CoreDataStack.shared.saveContext()
        
        completion(.success(message))
    }
    
    func addBotResponse(text: String, completion: @escaping (Result<Message, Error>) -> Void) {
        addMessage(text: text, sender: "bot", completion: completion)
    }
}

