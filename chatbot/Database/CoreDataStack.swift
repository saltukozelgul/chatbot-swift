import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "chatbot")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failed to save Core Data context: \(error)")
            }
        }
    }
    
    func fetchChats() -> [Chat] {
        let request: NSFetchRequest<Chat> = Chat.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastEdited", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    func deleteChat(_ chat: Chat) {
        context.delete(chat)
        // Deleting chat messages as well we can do this by sql query as well
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        fetchRequest.predicate = NSPredicate(format: "chat == %@", chat)
        do {
            let messages = try context.fetch(fetchRequest)
            for message in messages {
                context.delete(message)
            }
        } catch {
            print("Error fetching messages for chat deletion: \(error)")
        }
        CoreDataStack.shared.saveContext()
    }
    
    func createChat(_ name: String) {
        let chat = Chat(context: CoreDataStack.shared.context)
        chat.title = name
        chat.lastEdited = Date()
        
        // Save the new chat object
        CoreDataStack.shared.saveContext()
    }
    
    func getMessages(_ chat: Chat) -> [Message] {
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "chat == %@", chat)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    
    func addLoadingMessage() -> Message {
        let loadingMessage = Message(context: CoreDataStack.shared.context)
        loadingMessage.text = "Chatbot is typing..."
        loadingMessage.sender = "bot"
        return loadingMessage
    }
}
