import UIKit

final class SettingsCoordinator: Coordinator {
    private let factory: SettingsModuleFactory

    var onComplete: ((Coordinator) -> Void)?
    let navigationController: UINavigationController

    init(navigationController: UINavigationController, factory: SettingsModuleFactory) {
        self.navigationController = navigationController
        self.factory = factory
        factory.coordinator = self
    }

    func start() {
        showSettingsModule()
    }

    func showSettingsModule() {
        let module = factory.makeSettingsModule()
        navigationController.pushViewController(module, animated: true)
    }

    func showPasswordEditModule() {
        let module = factory.makePasswordEditModule()
        let navController = UINavigationController(rootViewController: module)
        navController.isModalInPresentation = true
        navController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: true, completion: nil)
    }
}

final class SettingsModuleFactory {
    weak var coordinator: SettingsCoordinator?

    func makeSettingsModule() -> UIViewController {
        let module = SettingsViewController()
        module.coordinator = coordinator
        return module
    }

    func makePasswordEditModule() -> UIViewController {
        let presenter = PasswordEditPresenter()
        let module = PasswordEditViewController(output: presenter)
        presenter.coordinator = coordinator
        presenter.viewInput = module
        presenter.render()
        return module

    }
}
