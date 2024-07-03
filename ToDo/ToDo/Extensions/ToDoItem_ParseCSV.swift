import Foundation


extension ToDoItem {
    static func parse(csv: String) -> ToDoItem? {
        let parsedCSV = csv.components(separatedBy: ",")
        guard parsedCSV.count >= 7,
              let isDone = Bool(parsedCSV[4]),
              let creationDate = ISO8601DateFormatter().date(from: parsedCSV[5]) else {
            return nil
        }

        let id = parsedCSV[0]
        let text = parsedCSV[1]
        let importance = Importance(rawValue: parsedCSV[2]) ?? .medium
        let deadline = ISO8601DateFormatter().date(from: parsedCSV[3])
        let changeDate = ISO8601DateFormatter().date(from: parsedCSV[6])

        return ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isDone: isDone, creationDate: creationDate, modificationDate: changeDate)
    }

    var csv: String {
        var csvString: [String?] = [
            id,
            text,
            importance.rawValue,
            deadline.map { ISO8601DateFormatter().string(from: $0) },
            String(isDone),
            ISO8601DateFormatter().string(from: creationDate),
            changeDate.map { ISO8601DateFormatter().string(from: $0) }
        ]
        return csvString.map { $0 ?? "" }.joined(separator: ",")
    }
}
