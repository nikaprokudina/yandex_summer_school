import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = DataControlModel()
    @State private var show = "Показать"
    @State private var item: [ToDoItem] = []
    @State private var showModal = false
    @State private var selectedIndex: Int = 0
    @State private var selectedItem: ToDoItem?
    @State private var isShow = false
    @State private var showCalendar = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ListNeedToDo()
                Button {
                    let newItem = ToDoItem(text: "", importance: .medium, deadline: nil, isDone: false, creationDate: Date(), modificationDate: nil)
                    viewModel.addItem(item: newItem)
                    selectedItem = newItem
                    showModal = true
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.blue)
                            .frame(width: 44, height: 44)
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundStyle(Color.white)
                            .frame(width: 22, height: 22)
                            .bold()
                    }
                }
                .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 8)
            }
            .navigationTitle("Мои дела")
            .navigationBarItems(trailing: Button(action: {
                showCalendar = true
            }) {
                Image(systemName: "calendar")
                    .imageScale(.large)
            })
            .sheet(isPresented: $showModal) {
                ModalView(
                    toDo: selectedItem ?? ToDoItem(text: "", importance: .medium, deadline: nil, isDone: false, creationDate: Date(), modificationDate: nil),
                    selectItem: selectedItem ?? ToDoItem(text: "", importance: .medium, deadline: nil, isDone: false, creationDate: Date(), modificationDate: nil),
                    importance: selectedItem?.importance ?? .medium,
                    isDeadline: selectedItem?.deadline != nil ? true : false,
                    isShowDatePicker: false,
                    text: selectedItem?.text ?? ""
                )
            }
            .fullScreenCover(isPresented: $showCalendar) {
                CalendarHostingView()
            }
        }
        .onAppear {
            item = viewModel.filterDataNotDone()
        }
    }
    
    private func ListNeedToDo() -> some View {
        List {
            Section {
                ForEach(Array(item.enumerated()), id: \.offset) { index, element in
                    RowsView(item: element).tag(element)
                        .onTapGesture {
                            selectedItem = element
                            selectedIndex = index
                            showModal = true
                        }
                }
                .listRowBackground(Color(UIColor.systemGray6))
                .swipeActions(edge: .leading) {
                    Button {
                        _ = viewModel.changeData(index: selectedIndex)
                        item = viewModel.filterDataNotDone()
                    } label: {
                        Image(systemName: "checkmark.circle")
                    }
                    .tint(.green)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        viewModel.data.remove(at: selectedIndex)
                        item = viewModel.filterDataNotDone()
                    } label: {
                        Image(systemName: "trash")
                    }
                    Button {
                        showModal = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .tint(Color(UIColor.lightGray))
                }
            } header: {
                HStack {
                    Text("Выполнено - \(viewModel.filterDataIsDone().count)")
                        .foregroundStyle(Color(UIColor.tertiaryLabel))
                        .font(.system(size: 15))
                    Spacer()
                    Button(action: {
                        if isShow {
                            self.show = "Показать"
                            item = viewModel.filterDataNotDone()
                        } else {
                            self.show = "Скрыть"
                            item = viewModel.data
                        }
                        isShow.toggle()
                    }, label: {
                        Text(self.show)
                            .foregroundStyle(Color.blue)
                            .font(.system(size: 15))
                    })
                }
            }
        }
        .navigationTitle(
            Text("Мои дела")
                .foregroundStyle(Color(UIColor.label))
        )
        .font(.system(size: 38))
        .background(Color(UIColor.systemGray6))
    }
}

#Preview {
    MainView()
}

