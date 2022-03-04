import Foundation
import KeychainAccess

final class PasswordManager {
    private let keychain = Keychain(service: "com.asorokovikov.filemanagerapp")

    static let shared = PasswordManager()

    var password: String? {
        get { keychain["user"] }
        set { keychain["user"] = newValue }
    }

    var isPasswordCreated: Bool {
        return password != nil
    }

    static func
    IsValidPassword(_ password: String) -> Bool {
        return password.count >= 4
    }
}

extension FileManager {
    static var Documents: URL {
        let manager = FileManager.default
        let url = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        guard let url = url else {
            fatalError("Failed to retrieve document directory")
        }
        return url
    }
}
