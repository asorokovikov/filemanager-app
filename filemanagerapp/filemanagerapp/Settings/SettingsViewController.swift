import UIKit

final class SettingsViewController: UITableViewController {
    weak var coordinator: SettingsCoordinator?

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
        coordinator?.showPasswordEditModule()

//        let controller = PasswordEditViewController()
//        controller.isModalInPresentation = true
//        controller.modalPresentationStyle = .fullScreen
//        present(controller, animated: true, completion: nil)
//        return
//        print(#function)
//        let alertController = UIAlertController(title: "Смена пароля", message: nil, preferredStyle: .alert)
//        alertController.addTextField { $0.placeholder = "Введите пароль" }
//        alertController.addTextField { $0.placeholder = "Повторите пароль" }
//        alertController.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { [weak self] _ in
//            let manager = PasswordManager.shared
//            let newPassword = alertController.textFields![0].text ?? .empty
//            let confirmPassword = alertController.textFields![1].text ?? .empty
//            if PasswordManager.IsValidPassword(newPassword) && newPassword == confirmPassword  {
//                manager.password = newPassword
//                print("Пароль изменен")
//                return
//            }
//            print("Пароль не был изменен")
//        }))
//        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
//        present(alertController, animated: true, completion: nil)
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

