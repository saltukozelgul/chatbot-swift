//
//  Message+CoreDataProperties.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 6.10.2023.
//
//

import Foundation
import CoreData


extension Message {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }
    
    @NSManaged public var messageID: UUID?
    @NSManaged public var sender: String?
    @NSManaged public var text: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var chat: Chat?
    
}

extension Message : Identifiable {
    
}
