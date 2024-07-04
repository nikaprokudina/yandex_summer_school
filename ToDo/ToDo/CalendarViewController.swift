import UIKit
import SwiftUI

class CalendarToDoViewController: UIViewController {

    var viewModel = DataControlModel()
    var tableView: UITableView!
    var collectionView: UICollectionView!
    var selectedDate: Date?
    var dataSource: [Date: [ToDoItem]] = [:]
    var otherItems: [ToDoItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Календарь"
        view.backgroundColor = .white
        
        setupCollectionView()
        setupTableView()
        setupFloatingButton()
        organizeData()
    }
    
    func organizeData() {
        dataSource = Dictionary(grouping: viewModel.data.filter { $0.deadline != nil }, by: { $0.deadline! })
        otherItems = viewModel.data.filter { $0.deadline == nil }
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupFloatingButton() {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 25
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func addNewItem() {
        let swiftUIView = MainView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        present(hostingController, animated: true, completion: nil)
    }
}

extension CalendarToDoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.keys.count + 1 // +1 for "Other"
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        if indexPath.item == dataSource.keys.count {
            cell.configure(with: "Другое")
        } else {
            let date = Array(dataSource.keys)[indexPath.item]
            cell.configure(with: date)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == dataSource.keys.count {
            selectedDate = nil
        } else {
            selectedDate = Array(dataSource.keys)[indexPath.item]
        }
        tableView.reloadData()
        // Scroll tableView to selected date section if needed
    }
}

extension CalendarToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.keys.count + (otherItems.isEmpty ? 0 : 1) // +1 for "Other" section if not empty
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == dataSource.keys.count {
            return otherItems.count
        } else {
            let date = Array(dataSource.keys)[section]
            return dataSource[date]?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == dataSource.keys.count {
            return "Другое"
        } else {
            let date = Array(dataSource.keys)[section]
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item: ToDoItem
        if indexPath.section == dataSource.keys.count {
            item = otherItems[indexPath.row]
        } else {
            let date = Array(dataSource.keys)[indexPath.section]
            item = dataSource[date]![indexPath.row]
        }
        cell.textLabel?.text = item.text
        cell.textLabel?.textColor = item.isDone ? .gray : .black
        if item.isDone {
            cell.textLabel?.attributedText = NSAttributedString(string: item.text, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        } else {
            cell.textLabel?.attributedText = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: ToDoItem
        if indexPath.section == dataSource.keys.count {
            item = otherItems[indexPath.row]
        } else {
            let date = Array(dataSource.keys)[indexPath.section]
            item = dataSource[date]![indexPath.row]
        }
        // Present detail screen for selected item
    }

    // Implement swipe actions for marking as done/not done
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item: ToDoItem
        if indexPath.section == dataSource.keys.count {
            item = otherItems[indexPath.row]
        } else {
            let date = Array(dataSource.keys)[indexPath.section]
            item = dataSource[date]![indexPath.row]
        }

        let actionTitle = item.isDone ? "Undone" : "Done"
        let action = UIContextualAction(style: .normal, title: actionTitle) { (action, view, completionHandler) in
            if let index = self.viewModel.data.firstIndex(where: { $0.id == item.id }) {
                var updatedItem = self.viewModel.data[index]
                updatedItem.isDone.toggle()
                self.viewModel.data[index] = updatedItem
                self.organizeData()
                self.tableView.reloadData()
                completionHandler(true)
            }
        }
        action.backgroundColor = item.isDone ? .blue : .green
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}
