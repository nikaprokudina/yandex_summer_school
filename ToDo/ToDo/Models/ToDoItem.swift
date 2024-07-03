import Foundation

enum Importance: String, Hashable {
    case low = "unimportant"
    case medium = "regular"
    case high = "important"
}

public struct ToDoItem: Hashable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let changeDate: Date?

    init(id: String = UUID().uuidString, text: String, importance: Importance, deadline: Date?, isDone: Bool, creationDate: Date, modificationDate: Date?) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.changeDate = modificationDate
    }
}

