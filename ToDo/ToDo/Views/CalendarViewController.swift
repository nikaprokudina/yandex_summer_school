import UIKit
import SwiftUI

class CalendarToDoViewController: UIViewController {
    
    @ObservedObject var viewModel = DataControlModel()
    var tableView: UITableView!
    var collectionView: UICollectionView!
    var selectedDate: Date?
    var dataSource: [(key: Date, value: [ToDoItem])] = []
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
        let groupedData = Dictionary(grouping: viewModel.data.filter { $0.deadline != nil }, by: { $0.deadline! })
        dataSource = groupedData.map { key, value in (key, value) }
            .sorted { $0.key < $1.key }
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
