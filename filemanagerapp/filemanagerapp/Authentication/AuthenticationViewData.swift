import Foundation

struct TextViewData {
    let text: String
    let onChange: (String) -> Void

    static let initial = TextViewData(text: .empty, onChange: { _ in () })
}

struct ButtonViewData {
    let text: String
    let enabled: Bool

    static let initial = ButtonViewData(text: .empty, enabled: false)
}

enum AuthenticationData {
    case creatingPassword
    case confirmationPassword
    case checkingPassword
}

struct AuthenticationViewData {
    let password: TextViewData
    let button: ButtonViewData
    let error: String?

    static let initial = AuthenticationViewData(password: .initial, button: .initial, error: nil)
}

extension AuthenticationViewData {
    func replaceError(_ errorText: String?) -> AuthenticationViewData {
        return AuthenticationViewData(
            password: password,
            button: button,
            error: errorText)
    }

    func replacePassword(_ value: String) -> AuthenticationViewData {
        return AuthenticationViewData(
            password: TextViewData(text: value, onChange: password.onChange),
            button: ButtonViewData(text: button.text, enabled: PasswordManager.IsValidPassword(value)),
            error: error)
    }

    func resetPassword() -> AuthenticationViewData {
        return replacePassword(.empty)
    }
}
