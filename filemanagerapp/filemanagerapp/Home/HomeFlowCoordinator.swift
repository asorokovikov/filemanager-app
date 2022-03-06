import UIKit

final class HomeFlowCoordinator: Coordinator {
    private let factory: HomeModuleFactory

    var onComplete: ((Coordinator) -> Void)?
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.factory = HomeModuleFactory()
        factory.coordinator = self
    }

    func start() {
        let presenter = AuthenticationPresenter()
        let controller = AuthenticationViewController(output: presenter)
        presenter.viewInput = controller
        presenter.coordinator = self
        presenter.render()

        controller.isModalInPresentation = true
        controller.modalPresentationStyle = .fullScreen
        navigationController.present(controller, animated: false, completion: nil)

        showFolder(with: FileManager.Documents, animated: false)
    }

    func showFolder(with url: URL, animated: Bool = true) {
        let module = factory.makeFolderModule(url)
        navigationController.pushViewController(module, animated: animated)
    }

    func showImage(_ imageUrl: URL) {
        let module = factory.makeImageModule(imageUrl)
        navigationController.present(module, animated: true, completion: nil)
    }
}
