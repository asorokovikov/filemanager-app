import UIKit

struct BadgeTableRow: TableRow {
    let title: String
    let icon: UIImage?
    let action: TableAction?
    let badgeCount: Int
    let accessoryType: UITableViewCell.AccessoryType

    init(title: String, icon: UIImage? = nil, badgeCount: Int = 0, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator, action: @escaping TableAction) {
        self.title = title
        self.icon = icon
        self.badgeCount = badgeCount
        self.accessoryType = accessoryType
        self.action = action
    }

    func configureCell(_ cell: UITableViewCell) -> UITableViewCell {
        guard let cell = cell as? BadgeTableViewCell else {
            assertionFailure("Failed to cast \(cell.self) to TableViewCellBadge")
            return cell
        }
        cell.textLabel?.text = title
        cell.accessoryType = accessoryType
        cell.imageView?.image = icon
        cell.badgeCount = badgeCount

        return AppStyleGuide.configureTableViewCell(cell)
    }

    static let cell = TableCell(type: BadgeTableViewCell.self)

}

final class BadgeTableViewCell: TableViewCellDefault {

    var badgeCount: Int = 140 {
        didSet {
            if badgeCount > 0 {
                badgeLabel.text = String(badgeCount)
                accessoryView = badgeLabel
                accessoryType = .none
            } else {
                accessoryView = nil
            }
        }
    }

    private lazy var badgeLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: BadgeTableViewCell.badgeSize))
        label.layer.masksToBounds = true
        label.layer.cornerRadius = BadgeTableViewCell.badgeCornerRadius
        label.textAlignment = .center
        label.backgroundColor = App.Color.primary
        label.textColor = UIColor.white
        return label
    }()

    private static let badgeSize = CGSize(width: 44, height: 22)
    private static var badgeCornerRadius: CGFloat { badgeSize.height / 2}
}
