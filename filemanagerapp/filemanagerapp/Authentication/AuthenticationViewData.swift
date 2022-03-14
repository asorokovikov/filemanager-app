import Foundation

struct TextViewData {
    let text: String
    let error: String
    let onChange: (String) -> Void

    static let initial = TextViewData(text: .empty, error: .empty, onChange: { _ in () })
}

extension TextViewData {
    func replaceText(_ value: String) -> TextViewData {
        return TextViewData(text: value, error: error, onChange: onChange)
    }

    func replaceError(_ error: String) -> TextViewData {
        return TextViewData(text: text, error: error, onChange: onChange)
    }

    func reset() -> TextViewData {
        return TextViewData(text: .empty, error: .empty, onChange: onChange)
    }

    static func make(_ onChange: @escaping (_ value: String) -> Void) -> TextViewData {
        return TextViewData(text: .empty, error: .empty, onChange: onChange)
    }
}

enum AuthenticationViewData {
    case newPassword(
        password: TextViewData,
        confirmPassword: TextViewData,
        isConfirmationPhase: Bool,
        canSavePassword: (String) -> Bool
    )
    case authentication(
        password: TextViewData,
        canSavePassword: (String) -> Bool
    )

    static let initial = AuthenticationViewData.authentication(password: .initial, canSavePassword: { _ in return false })
}

extension AuthenticationViewData {
    func replacePassword(_ value: String) -> AuthenticationViewData {
        switch self {
        case .newPassword(let password, let confirmPassword, let isConfirmationPhase, let canSavePassword):
            if isConfirmationPhase {
                return .newPassword(
                    password: password,
                    confirmPassword: confirmPassword.replaceText(value),
                    isConfirmationPhase: isConfirmationPhase,
                    canSavePassword: canSavePassword)
            }
            return .newPassword(
                password: password.replaceText(value),
                confirmPassword: confirmPassword,
                isConfirmationPhase: isConfirmationPhase,
                canSavePassword: canSavePassword)
        case .authentication(let password, let canSavePassword):
            return .authentication(
                password: password.replaceText(value),
                canSavePassword: canSavePassword
            )
        }
    }

    func replaceError(_ error: String) -> AuthenticationViewData {
        switch self {
        case .newPassword(let password, let confirmPassword, let isConfirmationPhase, let canSavePassword):
            if isConfirmationPhase {
                return .newPassword(
                    password: password,
                    confirmPassword: confirmPassword.replaceError(error),
                    isConfirmationPhase: isConfirmationPhase,
                    canSavePassword: canSavePassword)
            }
            return .newPassword(
                password: password.replaceError(error),
                confirmPassword: confirmPassword,
                isConfirmationPhase: isConfirmationPhase,
                canSavePassword: canSavePassword)
        case .authentication(let password, let canSavePassword):
            return .authentication(
                password: password.replaceError(error),
                canSavePassword: canSavePassword
            )
        }
    }

    func replaceConfirmationPhase(_ value: Bool) -> AuthenticationViewData {
        if case .newPassword(let password, let confirmPassword, _, let canSavePassword) = self {
            return .newPassword(password: password, confirmPassword: confirmPassword, isConfirmationPhase: value, canSavePassword: canSavePassword)
        }
        return self
    }

    func resetToInitialState() -> AuthenticationViewData {
        switch self {
        case .newPassword(let password, let confirmPassword, _, let canSavePassword):
            return .newPassword(
                password: password.reset(),
                confirmPassword: confirmPassword.reset(),
                isConfirmationPhase: false,
                canSavePassword: canSavePassword
            )
        case .authentication(let password, let canSavePassword):
            return .authentication(
                password: password.reset(),
                canSavePassword: canSavePassword
            )
        }
    }
}
