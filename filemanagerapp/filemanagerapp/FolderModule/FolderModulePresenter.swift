import Foundation
import UIKit

// MARK: - ViewModel

struct EntryViewData {
    let url: URL
    let image: UIImage?
    let isDirectory: Bool
    let onSelect: Action
}

struct FolderViewData {
    let url: URL
    let entries: [EntryViewData]
}

extension FolderViewData {
    static let `default` = FolderViewData(url: URL(fileURLWithPath: .empty), entries: [])

    var name: String { url.lastPathComponent }

    func replaceEntries(_ entries: [EntryViewData]) -> FolderViewData {
        return FolderViewData(url: self.url, entries: entries)
    }
}

// MARK: - Presenter

final class FolderModulePresenter {
    weak var viewInput: FolderViewInput?
    weak var coordinator: FolderFlowCoordinator?

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

extension FolderModulePresenter: FolderViewOutput {

    func updateModel() {
        let entries = Directory.GetFiles(model.url)
        let directories = entries
            .filter{ $0.isDirectory }
            .map { directoryUrl in EntryViewData(url: directoryUrl, image: App.Images.folder, isDirectory: true) { [weak self] in
                self?.coordinator?.showFolder(with: directoryUrl)
            } }
        let files = entries
            .filter{ !$0.isDirectory }
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
            self.updateModel()
        }))
        coordinator?.navigationController.present(controller, animated: true, completion: nil)
    }

    func delete(url: URL) {
        Directory.Delete(url)
        self.updateModel()
    }

    func addPhoto(_ filename: String, _ image: UIImage) {
        let fileUrl = model.url.appendingPathComponent(filename)
        let data = image.jpegData(compressionQuality: 1)
        guard let data = data else { return }
        Directory.CreateFile(fileUrl, with: data)
        updateModel()
    }
}
