import Foundation

final class AuthenticationPresenter {
    weak var coordinator: FolderFlowCoordinator?
    weak var viewInput: AuthenticationViewInput?

    private var model: AuthenticationViewData = .initial {
        didSet { viewInput?.model = model }
    }

    func render() {
        let manager = PasswordManager.shared
        model = AuthenticationViewData(
            password: TextViewData(text: .empty, onChange: { [weak self] value in
                self?.onTextChanged(value)
            }),
            button: ButtonViewData(
                text: manager.isPasswordCreated ?  "Введите пароль" : "Создать пароль",
                enabled: false),
            error: nil
        )
    }

    private func
    onTextChanged(_ newValue: String) {
        model = model.replacePassword(newValue)
    }

    private func
    dismiss() {
        coordinator?.navigationController.dismiss(animated: true, completion: nil)
    }

}

extension AuthenticationPresenter: AuthenticationViewOutput {
    func login() {
        assert(PasswordManager.IsValidPassword(model.password.text), "Password must be 4 or more characters")

        let manager = PasswordManager.shared
        if manager.password == nil {
            manager.password = model.password.text
            dismiss()
            return
        }
        if manager.password == model.password.text {
            dismiss()
            return
        }
        model = model.resetPassword().replaceError("Неправильный пароль")
    }

    func resetError() {
        model = model.replaceError(nil)
    }
}
