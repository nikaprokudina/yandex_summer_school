import Foundation


enum CacheError: Error{
    case duplicateItem
    case itemNotFound
    case saveError
    case loadError
}

public final class FileCache{
    private(set) var items = [String: ToDoItem]()
    private var fileManager = FileManager.default
    
    // добавить
    func add(item: ToDoItem) throws{
        if items[item.id] == nil{
            items[item.id] = item
        }
        else{
            throw CacheError.duplicateItem
        }
    }
    
    // удалить
    func delete(id:String) throws{
        if items[id] != nil{
            items.removeValue(forKey: id)
        }
        else{
            throw CacheError.itemNotFound
        }
    }
    
    // загрузить все дела в файл
    func uploadToFile(at path: String) throws {
            let jsonArray = items.values.map { $0.json }
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                try data.write(to: URL(fileURLWithPath: path))
            } catch {
                throw CacheError.saveError
            }
        }
    
    // сохранить все дела из файла
    func loadFromFile(at path: String) throws {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    throw CacheError.loadError
                }
                for jsonObject in jsonArray {
                    if let item = ToDoItem.parse(json: jsonObject) {
                        try add(item: item)
                    }
                }
            } catch {
                throw CacheError.loadError
            }
        }
    
    
    
}
