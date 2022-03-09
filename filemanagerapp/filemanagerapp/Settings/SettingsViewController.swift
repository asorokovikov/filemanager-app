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
            action: { [weak self] _ in self?.changePassword() }
        )

        let resetPasswordRow = RedButtonTableRow(
            title: "Сбросить пароль",
            action: { [weak self] _ in self?.resetPassword() }
        )
        let resetPasswordFooter = "Если сбросить пароль, то при следующем входе необходимо создать его заново"

        return TableViewModel(sections: [
            TableSection(headerText: "Общее", rows: [sortingAscendingRow], footerText: sortingAscendingFooter),
            TableSection(rows: [changePasswordRow]),
            TableSection(rows: [resetPasswordRow], footerText: resetPasswordFooter),
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

    private func
    resetPassword() {
        tableView.deselectRowIfSelected()
        AuthenticationService.shared.setPassword(nil)
        Toast.success("Пароль сброшен").show(haptic: .success)
    }
}
