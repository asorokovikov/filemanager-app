import UIKit

typealias TableAction = (TableRow) -> Void

struct TableSection {
    let headerText: String?
    let rows: [TableRow]
    let footerText: String?

    init(headerText: String? = nil, rows: [TableRow], footerText: String? = nil) {
        self.headerText = headerText
        self.rows = rows
        self.footerText = footerText
    }
}

protocol TableRow {
    var action: TableAction? { get }
    func configureCell(_ cell: UITableViewCell) -> UITableViewCell

    static var cell: TableCell { get }
    static var customHeight: Float? { get }
}

// MARK: - TableViewModel

struct TableViewModel {
    let sections: [TableSection]

    init(sections: [TableSection]) {
        self.sections = sections
    }

    func rowAtIndexPath(_ indexPath: IndexPath) -> TableRow {
        return sections[indexPath.section].rows[indexPath.row]
    }

    static func registerRows(_ rows: [TableRow.Type], tableView: UITableView) {
        rows.forEach { tableView.register($0.cell.type, forCellReuseIdentifier: $0.cell.reusableIdentifier) }
    }
}

extension TableViewModel {

    static var Empty: TableViewModel {
        return TableViewModel(sections: [])
    }
}

extension TableRow {
    public var reusableIdentifier: String {
        return type(of: self).cell.reusableIdentifier
    }

    public var cellClass: UITableViewCell.Type {
        return type(of: self).cell.cellClass
    }

    public static var customHeight: Float? {
        return nil
    }
}

// MARK: - TableCell

struct TableCell {
    let type: UITableViewCell.Type

    public var reusableIdentifier: String {
        return String(describing: cellClass)
    }

    public var cellClass: UITableViewCell.Type {
        return type
    }
}

// MARK: - TableViewHandler

final class TableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    unowned let target: UITableViewController
    var automaticallyDeselectCells = false

    var model = TableViewModel.Empty {
        didSet {
            if target.isViewLoaded {
                target.tableView.reloadData()
            }
        }
    }

    init(target: UITableViewController) {
        self.target = target
        super.init()

        target.tableView.dataSource = self
        target.tableView.delegate = self
    }

    // MARK: DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return model.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = model.rowAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reusableIdentifier, for: indexPath)
        return row.configureCell(cell)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.sections[section].headerText
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return model.sections[section].footerText
    }

    // MARK: Delegate

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if target.responds(to: #selector(UITableViewDelegate.tableView(_:willSelectRowAt:))) {
            return target.tableView(tableView, willSelectRowAt: indexPath)
        } else {
            return indexPath
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if target.responds(to: #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))) {
            target.tableView(tableView, didSelectRowAt: indexPath)
        } else {
            let row = model.rowAtIndexPath(indexPath)
            row.action?(row)
        }
        if automaticallyDeselectCells {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = model.rowAtIndexPath(indexPath)
        if let customHeight = type(of: row).customHeight {
            return CGFloat(customHeight)
        }
        return tableView.rowHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if target.responds(to: #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:))) {
            return target.tableView(tableView, heightForFooterInSection: section)
        }

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if target.responds(to: #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:))) {
            return target.tableView(tableView, heightForHeaderInSection: section)
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if target.responds(to: #selector(UITableViewDelegate.tableView(_:viewForFooterInSection:))) {
            return target.tableView(tableView, viewForFooterInSection: section)
        }

        return nil
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if target.responds(to: #selector(UITableViewDelegate.tableView(_:viewForHeaderInSection:))) {
            return target.tableView(tableView, viewForHeaderInSection: section)
        }

        return nil
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if target.responds(to: #selector(UITableViewDataSource.tableView(_:canEditRowAt:))) {
            return target.tableView(tableView, canEditRowAt: indexPath)
        }
        return false
    }
}
