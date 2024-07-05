import UIKit
import SwiftUI

class CalendarToDoViewController: UIViewController {
    
    @ObservedObject var viewModel = DataControlModel()
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
        
        let circleView = UIView()
        circleView.backgroundColor = UIColor(named: "Blue")
        circleView.layer.cornerRadius = 22
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.isUserInteractionEnabled = false
        
        let plusImageView = UIImageView(image: UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        plusImageView.contentMode = .scaleAspectFit
        plusImageView.isUserInteractionEnabled = false
        
        button.addSubview(circleView)
        button.addSubview(plusImageView)
        
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 4
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            circleView.widthAnchor.constraint(equalToConstant: 44),
            circleView.heightAnchor.constraint(equalToConstant: 44),
            circleView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            plusImageView.widthAnchor.constraint(equalToConstant: 22),
            plusImageView.heightAnchor.constraint(equalToConstant: 22),
            plusImageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
    
    @objc func addNewItem() {
        dismiss(animated: true, completion: nil)
    }
}


extension CalendarToDoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.keys.count + 1
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
        scrollToSelectedDate()
    }
    
    func scrollToSelectedDate() {
        if let selectedDate = selectedDate {
            if let section = Array(dataSource.keys).firstIndex(of: selectedDate) {
                let indexPath = IndexPath(row: 0, section: section)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        } else {
            if !otherItems.isEmpty {
                let indexPath = IndexPath(row: 0, section: dataSource.keys.count)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
}

extension CalendarToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.keys.count + (otherItems.isEmpty ? 0 : 1)
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
        cell.textLabel?.textColor = item.isDone ? UIColor(named: "Grey") : .label
        
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
    }

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
