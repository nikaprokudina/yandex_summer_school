import UIKit
import SwiftUI

class CalendarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarVC = CalendarToDoViewController()
        addChild(calendarVC)
        view.addSubview(calendarVC.view)
        calendarVC.view.frame = view.bounds
        calendarVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        calendarVC.didMove(toParent: self)
    }
}



struct CalendarHostingView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CalendarViewController {
        return CalendarViewController()
    }

    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
        // Обновление состояния контроллера (если необходимо)
    }
}
