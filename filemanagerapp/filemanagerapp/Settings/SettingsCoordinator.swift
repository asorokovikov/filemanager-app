import UIKit

final class SettingsCoordinator: Coordinator {
    private let factory: SettingsModuleFactory

    var onComplete: ((Coordinator) -> Void)?
    let navigationController: UINavigationController

    init(navigationController: UINavigationController, factory: SettingsModuleFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func start() {
        showSettingsModule()
    }

    func showSettingsModule() {
        let vc = factory.makeSettingsModule()
        navigationController.pushViewController(vc, animated: true)
    }
}

final class SettingsModuleFactory {
    func makeSettingsModule() -> UIViewController {
        return SettingsViewController()
    }
}
