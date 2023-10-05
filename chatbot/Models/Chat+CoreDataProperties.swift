//
//  Chat+CoreDataProperties.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 6.10.2023.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }
    

    @NSManaged public var chatID: UUID?
    @NSManaged public var title: String?
    @NSManaged public var lastEdited: Date?
    @NSManaged public var messages: Message?
}

extension Chat : Identifiable {

}
