import Foundation


extension ToDoItem {
    static func parse(json: Any) -> ToDoItem? {     //json into ToDoItem
        guard let jsonDict = json as? [String: Any],
              
              let id = jsonDict["id"] as? String,
              let text = jsonDict["text"] as? String,
              let isDone = jsonDict["isDone"] as? Bool,
            
              let StringCreationDate = jsonDict["creationDate"] as? String,
              let creationDate = ISO8601DateFormatter().date(from: StringCreationDate) else {
            return nil
        }
        
        let importance = (jsonDict["importance"] as? String).flatMap { Importance(rawValue: $0) } ?? .medium
        let deadlineString = jsonDict["deadline"] as? String
        let deadline = deadlineString.flatMap { ISO8601DateFormatter().date(from: $0) }
        let changeDateString = jsonDict["changeDate"] as? String
        let changeDate = changeDateString.flatMap { ISO8601DateFormatter().date(from: $0) }

        return ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isDone: isDone, creationDate: creationDate, modificationDate: changeDate)
    }

    
    
    var json: Any{      // формирование json
        var jsonDict: [String: Any] = [
            "id": id,
            "text": text,
            "isDone": isDone,
            "creationDate": ISO8601DateFormatter().string(from: creationDate)
        ]
        
        if importance != .medium{
            jsonDict["importance"] = importance.rawValue
        }
        
        if let deadline = deadline{
            jsonDict["deadline"] = ISO8601DateFormatter().string(from: deadline)
        }
        
        if let changeDate = changeDate{
            jsonDict["changeDate"] = ISO8601DateFormatter().string(from: changeDate)
        }
        
        return jsonDict
    }
}
