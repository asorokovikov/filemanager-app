import Foundation

struct TextViewData {
    let text: String
    let onChange: (String) -> Void

    static let initial = TextViewData(text: .empty, onChange: { _ in () })
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

    static let initial = AuthenticationViewData.authentication(password: .initial, canSavePassword: {_ in return false})
}

extension AuthenticationViewData {
    func replacePassword(_ value: String) -> AuthenticationViewData {
        switch self {
        case .newPassword(let password, let confirmPassword, let isConfirmationPhase, let canSavePassword):
            if isConfirmationPhase {
                return .newPassword(
                    password: password,
                    confirmPassword: TextViewData(text: value, onChange: confirmPassword.onChange),
                    isConfirmationPhase: isConfirmationPhase,
                    canSavePassword: canSavePassword)
            }
            return .newPassword(
                password: TextViewData(text: value, onChange: password.onChange),
                confirmPassword: confirmPassword,
                isConfirmationPhase: isConfirmationPhase,
                canSavePassword: canSavePassword)
        case .authentication(let password, let canSavePassword):
            return .authentication(
                password: TextViewData(text: value, onChange: password.onChange),
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
                password: TextViewData(text: .empty, onChange: password.onChange),
                confirmPassword: TextViewData(text: .empty, onChange: confirmPassword.onChange),
                isConfirmationPhase: false,
                canSavePassword: canSavePassword
            )
        case .authentication(let password, let canSavePassword):
            return .authentication(
                password: TextViewData(text: .empty, onChange: password.onChange),
                canSavePassword: canSavePassword
            )
        }
    }
}
