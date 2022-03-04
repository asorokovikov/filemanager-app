import UIKit

protocol SettingsTableViewAdapterOutput {
}

final class SettingsTableViewCell: UITableViewCell {

}

final class SettingsTableViewAdapter: NSObject {

    enum Sections: Int {
        case common
        case other
    }

    // MARK: - Properties

    private let output: SettingsTableViewAdapterOutput
    private let tableView: UITableView
    private var items: [String]

    // MARK: - Initialization and deinitialization

    init(tableView: UITableView, output: SettingsTableViewAdapterOutput) {
        self.output = output
        self.tableView = tableView
        self.items = []
        super.init()
        setupTable()
    }

    // MARK: - Internal methods

    func configure(with items: [String]) {
        self.items = items
        tableView.reloadData()
    }

    // MARK: - Private methods

    private func setupTable() {
        tableView.backgroundColor = App.Color.secondaryBackground

        tableView.delegate = self
        tableView.dataSource = self
        SettingsTableViewCell.registerClass(in: tableView)
    }
}

// MARK: - UITableViewDataSource

extension SettingsTableViewAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsTableViewCell = .dequeueReusableCell(in: tableView, indexPath: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsTableViewAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
