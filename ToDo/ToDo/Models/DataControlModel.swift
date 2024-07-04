import Foundation

var isShow = true
var showModal = false
var show = "Показать"
let hide = "Скрыть"


final class DataControlModel: ObservableObject {
    
    @Published var data: [ToDoItem] = [
        ToDoItem(text: "Купить хлеб", importance: .high, deadline: createDate(day: 25, month: 5, year: 2024), isDone: true, creationDate: Date(), modificationDate: nil),
        ToDoItem(text: "Купить сыр", importance: .medium, deadline: createDate(day: 26, month: 5, year: 2024), isDone: false, creationDate: Date(), modificationDate: nil),
        ToDoItem(text: "Купить чебурек", importance: .high, deadline: createDate(day: 27, month: 5, year: 2024), isDone: false, creationDate: Date(), modificationDate: nil),
        ToDoItem(text: "Заправить машину", importance: .low, deadline: createDate(day: 28, month: 5, year: 2024), isDone: false, creationDate: Date(), modificationDate: nil),
        ToDoItem(text: "Позвонить врачу", importance: .medium, deadline: createDate(day: 29, month: 5, year: 2024), isDone: false, creationDate: Date(), modificationDate: nil),
        ToDoItem(text: "Сделать домашнее задание", importance: .high, deadline: createDate(day: 30, month: 5, year: 2024), isDone: false, creationDate: Date(), modificationDate: nil),
        ToDoItem(text: "Сделать звонок", importance: .high, deadline: nil, isDone: false, creationDate: Date(), modificationDate: nil)
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
    
    private static func createDate(day: Int, month: Int, year: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}
