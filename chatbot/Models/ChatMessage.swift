//
//  ChatMessage.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 5.10.2023.
//

import Foundation

struct ChatMessage {
    let chatID: String // The ID of the chat that this message belongs to
    let sender: String // The sender's name or identifier
    let message: String // The content of the message
    let timestamp: Date // The timestamp of the message
    let senderType: SenderType
    // We can also include other properties like message type (text, image, etc.) or other metadata as needed.
    
    // Initializer for convenience
    init(sender: String, message: String, timestamp: Date, chatID: String) {
        self.sender = sender
        self.message = message
        self.timestamp = timestamp
        self.chatID = chatID
        self.senderType = sender == "bot" ? .bot : .user
    }
}
