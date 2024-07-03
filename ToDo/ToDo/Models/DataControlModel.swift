import Foundation

var isShow = true
var showModal = false
var show = "Показать"
let hide = "Скрыть"


final class DataControlModel: ObservableObject {
    
    @Published var data: [ToDoItem] = [
        ToDoItem(text: "Купить хлеб", importance: .high, deadline: Date(), isDone: true, creationDate: Date(), modificationDate: nil),
        ToDoItem(text: "Купить сыр", importance: .medium, deadline: Date(), isDone: false, creationDate: Date(), modificationDate: nil),
        ToDoItem(text: "Купить чебурек", importance: .high, deadline: Date(), isDone: false, creationDate: Date(), modificationDate: nil)
    ]
    
    func addItem(item: ToDoItem) {
        data.append(item)
    }
    
    func filterDataNotDone() -> [ToDoItem] {
        return data.filter { !$0.isDone }
    }
    
    func filterDataIsDone() -> [ToDoItem] {
        return data.filter { $0.isDone }
    }
    
    func changeData(index: Int) -> [ToDoItem] {
        var item = data[index]
        item = ToDoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, isDone: !item.isDone, creationDate: item.creationDate, modificationDate: Date())
        data[index] = item
        return data
    }
}
