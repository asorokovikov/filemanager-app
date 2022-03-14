import Foundation

final class AuthenticationPresenter {
    weak var coordinator: HomeFlowCoordinator?
    weak var viewInput: AuthenticationViewInput?

    private var model: AuthenticationViewData = .initial {
        didSet { viewInput?.model = model }
    }

    func render() {
        if AuthenticationService.shared.isPasswordCreated {
            model = AuthenticationViewData.authentication(
                password: TextViewData.make(onTextChanged),
                canSavePassword: AuthenticationService.IsValidPassword
            )
        } else {
            model = AuthenticationViewData.newPassword(
                password: TextViewData.make(onTextChanged),
                confirmPassword: TextViewData.make(onTextChanged),
                isConfirmationPhase: false,
                canSavePassword: AuthenticationService.IsValidPassword
            )
        }
    }

    private func
    onTextChanged(_ newValue: String) {
        var newModel = model
        if newValue.isEmpty || newValue.count >= 4 {
            newModel = newModel.replaceError(.empty)
        } else {
            newModel = newModel.replaceError("Пароль должен быть не короче 4 символов")
        }
        model = newModel.replacePassword(newValue)
    }

    private func
    dismiss() {
        coordinator?.navigationController.dismiss(animated: true, completion: nil)
    }
}

extension AuthenticationPresenter: AuthenticationViewOutput {
    func login() {
        switch model {
        case .newPassword(let password, let confirmPassword, let isConfirmationPhase, _):
            processNewPassword(password.text, confirmPassword.text, isConfirmationPhase)
        case .authentication(let password, _):
            processAuthentication(password.text)
        }
    }

    private func
    processNewPassword(_ password: String, _ confirmPassword: String, _ isConfirmationPhase: Bool) {
        let manager = AuthenticationService.shared
        if !isConfirmationPhase {
            model = model.replaceConfirmationPhase(true)
            return
        }
        if password != confirmPassword {
            Toast.error("Пароли не совпадают").show(haptic: .error)
            model = model.resetToInitialState()
            return
        }
        manager.setPassword(password)
        Toast.haptic(type: .success)
        dismiss()
    }

    private func
    processAuthentication(_ password: String) {
        if AuthenticationService.shared.password == password {
            Toast.haptic(type: .success)
            dismiss()
            return
        }
        Toast.error("Неправильный пароль").show(haptic: .error)
        model = model.resetToInitialState()
    }
}
