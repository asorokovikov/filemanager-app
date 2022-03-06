import Foundation

final class PasswordEditPresenter: PasswordEditViewOutput {
    weak var viewInput: PasswordEditViewInput?
    weak var coordinator: SettingsCoordinator?

    private var model: PasswordEditViewData = .initial {
        didSet { viewInput?.model = model }
    }

    func savePassword() {
        if model.password.text.count < 4 || model.confirm.text.count < 4 {
            Toast.error("Пароль должен быть больше 4 символов").show(haptic: .error)
            return
        }
        if model.password.text != model.confirm.text {
            Toast.error("Пароли не совпадают").show(haptic: .error)
            return
        }

        let manager = PasswordManager.shared
        manager.password = model.password.text

        let toast = Toast.success("Новый пароль сохранен", attachTo: coordinator?.navigationController.view)
        toast.show(haptic: .success, after: 0.5)

        cancel()
    }

    func cancel() {
        coordinator?.navigationController.dismiss(animated: true, completion: nil)
    }

    func render() {
        model = makeModel()
    }

    private func
    makeModel() -> PasswordEditViewData {
        return PasswordEditViewData(
            password: TextViewData(text: .empty, onChange: { [weak self] value in
                guard let self = self else { return }
                self.model = self.model.replacePassword(value)
            }),
            confirm: TextViewData(text: .empty, onChange: { [weak self] value in
                guard let self = self else { return }
                self.model = self.model.replaceConfirmPassword(value)
            }),
            canSavePassword: { model in
                return model.password.text.isNotEmpty && model.confirm.text.isNotEmpty
            })
    }
}
