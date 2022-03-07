import Foundation
import KeychainAccess

final class AuthenticationService {
    private let keychain = Keychain(service: "com.asorokovikov.filemanagerapp")

    static let shared = AuthenticationService()

    var password: String? {
        get { keychain["user"] }
    }

    var isPasswordCreated: Bool {
        return password != nil
    }

    func setPassword(_ value: String?) {
        keychain["user"] = value
    }

    static func
    IsValidPassword(_ password: String) -> Bool {
        return password.count >= 4
    }
}
