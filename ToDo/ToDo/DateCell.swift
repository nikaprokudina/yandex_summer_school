import UIKit

class DateCell: UICollectionViewCell {
    private let dayLabel = UILabel()
    private let monthLabel = UILabel()
    private let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false

        dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false

        monthLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        monthLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(dayLabel)
        containerView.addSubview(monthLabel)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            dayLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            dayLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            monthLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4),
            monthLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }

    func configure(with date: Date) {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        dayLabel.text = dayFormatter.string(from: date)
        
        let monthFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "ru_RU")
        monthFormatter.dateFormat = "MMM"
        monthLabel.text = monthFormatter.string(from: date).lowercased()
    }

    func configure(with text: String) {
        dayLabel.text = text
        monthLabel.text = ""
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                containerView.layer.borderWidth = 1.5
                containerView.layer.borderColor = UIColor.lightGray.cgColor
                containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            } else {
                containerView.layer.borderWidth = 0
                containerView.layer.borderColor = UIColor.clear.cgColor
                containerView.backgroundColor = UIColor.clear
            }
        }
    }
}
