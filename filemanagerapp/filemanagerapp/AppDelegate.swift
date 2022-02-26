import UIKit

final class App {
    enum Color {
        static let background = UIColor.systemBackground
        static let secondaryBackground = UIColor.secondarySystemBackground
        static let success = UIColor.systemGreen
        static let failure = UIColor.systemRed
        static let primary = UIColor.systemBlue
    }

    enum Images {
        static let heart = UIImage(systemName: "heart")
        static let heartFill = UIImage(systemName: "heart.fill")
        static let bookmark = UIImage(systemName: "bookmark")
        static let bookmarkFill = UIImage(systemName: "bookmark.fill")
        static let house = UIImage(systemName: "house")
        static let houseFill = UIImage(systemName: "house.fill")
        static let gearshape = UIImage(systemName: "gearshape")
        static let gearshapeFill = UIImage(systemName: "gearshape.fill")
        static let person = UIImage(systemName: "person.circle")
        static let personFill = UIImage(systemName: "person.circle.fill")
        static let newFolder = UIImage(systemName: "folder.badge.plus")
        static let photo = UIImage(systemName: "photo")
        static let folder = UIImage(systemName: "folder.fill")
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

