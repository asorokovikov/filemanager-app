import UIKit

final class SettingsViewController: UITableViewController {
    private var handler: TableViewHandler!

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

    func makeViewModel() -> TableViewModel {
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
        print(#function)
    }

//    private func
//    clearAllData() {
//        fatalError("Not implemented")
//        tableView.deselectRowIfSelected(animated: true)
//        let alert = UIAlertController(title: nil, message: "Вы точно хотите очистить кэш?", preferredStyle: .actionSheet)
//        let clearAction = UIAlertAction(title: "Очистить", style: .destructive, handler: { _ in
//            print("Clear cache")
//        })
//        alert.addAction(clearAction)
//        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
//        alert.preferredAction = clearAction
//        present(alert, animated: true, completion: nil)
//    }
}

