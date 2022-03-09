import UIKit

struct ButtonRow: TableRow {
    static let cell = TableCell(type: TableViewCellDefault.self)

    let title: String
    let action: TableAction?

    func configureCell(_ cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.text = title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return AppStyleGuide.configureTableViewButtonCell(cell)
    }
}

struct RedButtonTableRow: TableRow {
    let title: String
    let action: TableAction?

    func configureCell(_ cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.text = title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping

        return AppStyleGuide.configureTableViewDestructiveCell(cell)
    }

    static let cell = TableCell(type: TableViewCellDefault.self)
}

struct TextTableRow: TableRow {
    let title: String
    let value: String
    let action: TableAction? = nil

    func configureCell(_ cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = value
        cell.selectionStyle = .none
        return AppStyleGuide.configureTableViewCell(cell)
    }

    static let cell = TableCell(type: TableViewCellDefault.self)
}

struct CheckmarkTableRow: TableRow {
    let title: String
    let checked: Bool
    let action: TableAction?

    func configureCell(_ cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.text = title
        cell.selectionStyle = .none
        cell.accessoryType = (checked) ? .checkmark : .none

        return AppStyleGuide.configureTableViewCell(cell)
    }

    static let cell = TableCell(type: TableViewCellDefault.self)
}

struct NavigationItemTableRow: TableRow {
    let title: String
    let detail: String?
    let icon: UIImage?
    let accessoryType: UITableViewCell.AccessoryType
    let action: TableAction?

    init(title: String, detail: String? = nil, icon: UIImage? = nil, badgeCount: Int = 0, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator, action: @escaping TableAction) {
        self.title = title
        self.detail = detail
        self.icon = icon
        self.accessoryType = accessoryType
        self.action = action
    }

    func configureCell(_ cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail
        cell.accessoryType = accessoryType
        cell.imageView?.image = icon

        return AppStyleGuide.configureTableViewCell(cell)
    }

    static let cell = TableCell(type: TableViewCellValue1.self)
}

class ReusableTableViewCell: UITableViewCell {
}

class TableViewCellDefault: ReusableTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) { nil }
}

final class TableViewCellValue1: ReusableTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) { nil }
}

final class TableViewCellValue2: ReusableTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) { nil }
}
