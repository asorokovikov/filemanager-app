import UIKit

final class HomeModuleFactory {
    weak var coordinator: HomeFlowCoordinator?

    func makeFolderModule(_ url: URL) -> FolderViewController {
        let presenter = HomeModulePresenter(url: url)
        let vc = FolderViewController(output: presenter)
        presenter.viewInput = vc
        presenter.coordinator = coordinator
        presenter.refresh()
        return vc
    }

    func makeImageModule(_ url: URL) -> UIViewController {
        let image = url.getFileImage() ?? UIImage()
        let vc = ImagePopupController(image: image)
        return vc
    }
}
