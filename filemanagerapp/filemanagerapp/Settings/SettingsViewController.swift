import UIKit

final class SettingsViewController: UITableViewController {
    weak var coordinator: SettingsCoordinator?

    private var handler: TableViewHandler!

    // MARK: - Lifecycle

    override init(style: UITableView.Style) {
        super.init(style: style)
    }

    convenience init() {
        self.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Настройки"
        view.backgroundColor = App.Color.secondaryBackground

        TableViewModel.registerRows([
            RedButtonTableRow.self,
            SwitchTableRow.self,
        ], tableView: self.tableView)

        handler = TableViewHandler(target: self)
        handler.model = makeViewModel()
    }

    // MARK: - Private

    private func
    makeViewModel() -> TableViewModel {
        let sortingAscendingFooter = "Если опция включена, то контент отображается в алфавитном порядке"

        let sortingAscendingRow = SwitchTableRow(
            title: "Сортировка по имени",
            value: Settings.shared.sortingAscending,
            onChange: sortingAscendingChanged()
        )

        let changePasswordRow = ButtonRow(
            title: "Изменить пароль",
            action: { [weak self] _ in self?.changePassword() })

        return TableViewModel(sections: [
            TableSection(headerText: "Общее", rows: [sortingAscendingRow], footerText: sortingAscendingFooter),
            TableSection(rows: [changePasswordRow]),
        ])
    }

    private func
    sortingAscendingChanged() -> (Bool) -> Void {
        return { value in
            Settings.shared.sortingAscending = value
        }
    }

    private func
    changePassword() {
        tableView.deselectRowIfSelected()
        coordinator?.showPasswordEditModule()
    }
}
