import Foundation
import UIKit

final class HomeModulePresenter {
    weak var viewInput: FolderViewInput?
    weak var coordinator: HomeFlowCoordinator?

    var model: FolderViewData = .default {
        didSet { viewInput?.model = model }
    }

    init(url: URL) {
        model = FolderViewData(url: url, entries: [])
    }

    private func
    showContent(of file: URL) {
        coordinator?.showImage(file)
    }
}

extension HomeModulePresenter: FolderViewOutput {

    func refresh() {
        let isAscending = Settings.shared.sortingAscending
        let entries = Directory.GetFiles(model.url)
        let directories = entries
            .filter{ $0.isDirectory }
            .sorted(by: { isAscending ? $0 < $1 : $0 > $1 })
            .map { directoryUrl in EntryViewData(url: directoryUrl, image: App.Images.folder, isDirectory: true) { [weak self] in
                self?.coordinator?.showFolder(with: directoryUrl)
            } }
        let files = entries
            .filter{ !$0.isDirectory }
            .sorted(by: { isAscending ? $0 < $1 : $0 > $1 })
            .map { fileUrl in EntryViewData(url: fileUrl, image: fileUrl.getFileImage(), isDirectory: false, onSelect: { [weak self] in
                self?.showContent(of: fileUrl)
            }) }
        model = model.replaceEntries(directories + files)
    }

    func createFolder() {
        let controller = UIAlertController(title: "Имя папки", message: nil, preferredStyle: .alert)
        controller.addTextField()
        controller.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "ОК", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let folderName = controller.textFields?[0].text ?? "Новая папка"
            let newFolder = self.model.url.appendingPathComponent(folderName)
            Directory.CreateDirectory(newFolder)
            self.refresh()
        }))
        coordinator?.navigationController.present(controller, animated: true, completion: nil)
    }

    func delete(url: URL) {
        Directory.Delete(url)
        self.refresh()
    }

    func addPhoto(_ filename: String, _ image: UIImage) {
        let fileUrl = model.url.appendingPathComponent(filename)
        let data = image.jpegData(compressionQuality: 1)
        guard let data = data else { return }
        Directory.CreateFile(fileUrl, with: data)
        refresh()
    }
}
