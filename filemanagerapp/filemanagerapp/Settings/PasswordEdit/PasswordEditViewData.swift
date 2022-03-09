import Foundation

struct PasswordEditViewData {
    let password: TextViewData
    let confirm: TextViewData
    let canSavePassword: (PasswordEditViewData) -> Bool

    static let initial = PasswordEditViewData(
        password: .initial,
        confirm: .initial,
        canSavePassword: { _ in return false }
    )
}

extension PasswordEditViewData {
    func replacePassword(_ value: String) -> PasswordEditViewData {
        return PasswordEditViewData(
            password: password.replaceText(value),
            confirm: confirm,
            canSavePassword: canSavePassword
        )
    }

    func replaceConfirmPassword(_ value: String) -> PasswordEditViewData {
        return PasswordEditViewData(
            password: password,
            confirm: confirm.replaceText(value),
            canSavePassword: canSavePassword
        )
    }

    func resetToInitialState() -> PasswordEditViewData {
        return PasswordEditViewData(
            password: password.replaceText(.empty),
            confirm: confirm.replaceText(.empty),
            canSavePassword: canSavePassword
        )
    }
}
