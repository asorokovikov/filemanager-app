import UIKit

final class FolderFlowCoordinator {
    let navigationController: UINavigationController

    private let factory: FolderModuleFactory

    init(navigationController: UINavigationController, factory: FolderModuleFactory) {
        self.navigationController = navigationController
        self.factory = factory
        factory.coordinator = self
    }

    func start() {
        let root = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        guard let root = root else {
            print("Error")
            return
        }
        showFolder(with: root)
    }

    func showFolder(with url: URL) {
        let module = factory.makeFolderModule(url)
        navigationController.pushViewController(module, animated: true)
    }

    func showImage(_ imageUrl: URL) {
        let module = factory.makeImageModule(imageUrl)
        navigationController.present(module, animated: true, completion: nil)
    }
}
