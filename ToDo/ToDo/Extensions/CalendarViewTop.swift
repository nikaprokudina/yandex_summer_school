import UIKit


extension CalendarToDoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        if indexPath.item == dataSource.count {
            cell.configure(with: "Другое")
        } else {
            let date = dataSource[indexPath.item].key
            cell.configure(with: date)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == dataSource.count {
            selectedDate = nil
        } else {
            selectedDate = dataSource[indexPath.item].key
        }
        tableView.reloadData()
        scrollToSelectedDate()
    }
    
    func scrollToSelectedDate() {
        if let selectedDate = selectedDate, let section = dataSource.firstIndex(where: { $0.key == selectedDate }) {
            let indexPath = IndexPath(row: 0, section: section)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        } else {
            if !otherItems.isEmpty {
                let indexPath = IndexPath(row: 0, section: dataSource.count)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
}
