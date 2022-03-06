import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var onComplete: ((Coordinator) -> Void)? { get set }
    func start()
}

final class CoordinatorFactory {

    static func
    makeHomeCoordinator() -> HomeFlowCoordinator {
        let controller = UINavigationController()
        controller.tabBarItem = UITabBarItem(title: "Домой", image: App.Images.house, selectedImage: App.Images.houseFill)

        return HomeFlowCoordinator(navigationController: controller)
    }

    static func
    makeSettingsCoordinator() -> SettingsCoordinator {
        let controller = UINavigationController()
        controller.tabBarItem = UITabBarItem(title: "Настройки", image: App.Images.gearshape, selectedImage: App.Images.gearshapeFill)
        return SettingsCoordinator(navigationController: controller, factory: SettingsModuleFactory())
    }

}
