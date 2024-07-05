
import UIKit


extension CalendarToDoViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count + (otherItems.isEmpty ? 0 : 1)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == dataSource.count {
            return otherItems.count
        } else {
            return dataSource[section].value.count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == dataSource.count {
            return "Другое"
        } else {
            let date = dataSource[section].key
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item: ToDoItem
        if indexPath.section == dataSource.count {
            item = otherItems[indexPath.row]
        } else {
            item = dataSource[indexPath.section].value[indexPath.row]
        }
        cell.textLabel?.text = item.text
        configureCell(cell, with: item)
        return cell
    }

    func configureCell(_ cell: UITableViewCell, with item: ToDoItem) {
        if item.isDone {
            cell.textLabel?.textColor = .gray
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: item.text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        } else {
            cell.textLabel?.textColor = .black
            cell.textLabel?.attributedText = nil
            cell.textLabel?.text = item.text
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") { [weak self] (action, view, completionHandler) in
            self?.toggleTaskCompletion(at: indexPath)
            completionHandler(true)
        }
        doneAction.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [doneAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let undoneAction = UIContextualAction(style: .normal, title: "Undone") { [weak self] (action, view, completionHandler) in
            self?.toggleTaskCompletion(at: indexPath)
            completionHandler(true)
        }
        undoneAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [undoneAction])
    }

    private func toggleTaskCompletion(at indexPath: IndexPath) {
        if indexPath.section < dataSource.count {
            var item = dataSource[indexPath.section].value[indexPath.row]
            viewModel.changeData(index: viewModel.data.firstIndex(of: item)!)
        } else {
            var item = otherItems[indexPath.row]
            viewModel.changeData(index: viewModel.data.firstIndex(of: item)!)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === tableView {
            if let visibleRows = tableView.indexPathsForVisibleRows, let topIndexPath = visibleRows.first {
                updateCollectionViewSelection(at: topIndexPath.section)
            }
        }
    }
    
    func updateCollectionViewSelection(at sectionIndex: Int) {
        if sectionIndex < dataSource.count {
            let indexPath = IndexPath(item: sectionIndex, section: 0)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        } else {
            let indexPath = IndexPath(item: dataSource.count, section: 0)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}
