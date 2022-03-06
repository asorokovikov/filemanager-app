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
            password: TextViewData(text: value, onChange: password.onChange),
            confirm: confirm,
            canSavePassword: canSavePassword
        )
    }

    func replaceConfirmPassword(_ value: String) -> PasswordEditViewData {
        return PasswordEditViewData(
            password: password,
            confirm: TextViewData(text: value, onChange: confirm.onChange),
            canSavePassword: canSavePassword
        )
    }

    func resetText() -> PasswordEditViewData {
        return PasswordEditViewData(
            password: TextViewData(text: .empty, onChange: password.onChange),
            confirm: TextViewData(text: .empty, onChange: confirm.onChange),
            canSavePassword: canSavePassword
        )
    }
}
