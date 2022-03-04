import Foundation

protocol KeyValueDatabase {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
    func removeObject(forKey defaultName: String)
}

extension UserDefaults: KeyValueDatabase {}

final class Settings {

    private enum Default {
        static let sortingAscending = true
    }

    private enum Keys {
        static let sortingAscendingKey = "sortingAscendingSetting"
    }

    // MARK: - Interface

    static let shared = Settings()

    var sortingAscending: Bool {
        get { database.object(forKey: Keys.sortingAscendingKey) as? Bool ?? Settings.Default.sortingAscending }
        set { database.set(newValue, forKey: Keys.sortingAscendingKey)}
    }

    // MARK: - Private properties

    private let database: KeyValueDatabase

    // MARK: - Lifecycle

    private init(database: KeyValueDatabase) {
        self.database = database
    }

    private convenience init() {
        self.init(database: UserDefaults() as KeyValueDatabase)
    }
}
