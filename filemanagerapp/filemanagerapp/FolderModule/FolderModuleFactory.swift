import UIKit

final class FolderModuleFactory {
    weak var coordinator: FolderFlowCoordinator?

    func makeFolderModule(_ url: URL) -> FolderViewController {
        let presenter = FolderModulePresenter(url: url)
        let vc = FolderViewController(output: presenter)
        presenter.viewInput = vc
        presenter.coordinator = coordinator
        presenter.updateModel()
        return vc
    }

    func makeImageModule(_ url: URL) -> UIViewController {
        let image = url.getFileImage() ?? UIImage()
        let vc = ImagePopupController(image: image)
        return vc
    }
}
