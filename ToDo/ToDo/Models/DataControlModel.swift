import Foundation

var isShow = true
var showModal = false
var show = "Показать"
let hide = "Скрыть"


final class DataControlModel: ObservableObject {
    
    @Published var data: [ToDoItem] = [
            ToDoItem(text: "Купить хлеб", importance: .high, deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date()), isDone: true, creationDate: Date(), modificationDate: nil),
            ToDoItem(text: "Купить сыр", importance: .medium, deadline: Calendar.current.date(byAdding: .day, value: 2, to: Date()), isDone: false, creationDate: Date(), modificationDate: nil),
            ToDoItem(text: "Купить чебурек", importance: .high, deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date()), isDone: false, creationDate: Date(), modificationDate: nil),
            ToDoItem(text: "Заправить машину", importance: .low, deadline: Calendar.current.date(byAdding: .day, value: 4, to: Date()), isDone: false, creationDate: Date(), modificationDate: nil),
            ToDoItem(text: "Позвонить врачу", importance: .medium, deadline: Calendar.current.date(byAdding: .day, value: 5, to: Date()), isDone: false, creationDate: Date(), modificationDate: nil),
            ToDoItem(text: "Сделать домашнее задание", importance: .high, deadline: Calendar.current.date(byAdding: .day, value: 6, to: Date()), isDone: false, creationDate: Date(), modificationDate: nil)
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
        item.isDone.toggle() 
        item = ToDoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, isDone: item.isDone, creationDate: item.creationDate, modificationDate: Date())
        data[index] = item
        return data
    }
}
