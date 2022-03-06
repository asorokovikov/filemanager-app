import UIKit

final class AppCoordinator {
    let tabController: UITabBarController

    private var coordinators: [Coordinator] = []

    init(_ window: UIWindow) {
        tabController = UITabBarController()
        tabController.tabBar.tintColor = App.Color.primary

        coordinators.append(CoordinatorFactory.makeHomeCoordinator())
        coordinators.append(CoordinatorFactory.makeSettingsCoordinator())

        tabController.viewControllers = coordinators.map { $0.navigationController }
        tabController.selectedIndex = 0
        window.rootViewController = tabController
        window.makeKeyAndVisible()
    }

    func start() {
        coordinators.forEach { $0.start() }
    }
}
