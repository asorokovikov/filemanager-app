import UIKit
import SnapKit

protocol FolderViewInput: AnyObject {
    var model: FolderViewData { get set }
}

protocol FolderViewOutput: AnyObject {
    func createFolder()
    func addPhoto(_ filename: String, _ image: UIImage)
    func delete(url: URL)
    func refresh()
}

// MARK: - FolderViewController

final class FolderViewController: UITableViewController, FolderViewInput {
    private let output: FolderViewOutput

    // MARK: - INPUT

    var model: FolderViewData = .default {
        didSet { updateView() }
    }

    // MARK: - Subviews

    private let newFolderButton: UIButton = {
        let button = UIButton()
        button.setImage(App.Images.newFolder, for: .normal)
        return button
    }()

    private let addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(App.Images.photo, for: .normal)
        return button
    }()

    // MARK: - Lifecycle

    init(output: FolderViewOutput) {
        self.output = output
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        FolderViewCell.registerClass(in: tableView)

        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.title = model.name
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: App.Images.photo, style: .plain, target: self, action: #selector(didTapAddPhoto)),
            UIBarButtonItem(image: App.Images.newFolder, style: .plain, target: self, action: #selector(didTapCreateFolder)),
        ]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.refresh()
    }

    // MARK: - Private methods

    private func
    updateView() {
        navigationItem.title = model.name
        tableView.reloadData()
    }

    @objc private func
    didTapCreateFolder() {
        output.createFolder()
    }

    @objc private func
    didTapAddPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension FolderViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        let imageUrl = info[.imageURL] as? URL
        let image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        if let image = image, let url = imageUrl {
            output.addPhoto(url.lastPathComponent, image)
        }
    }
}

extension FolderViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FolderViewCell = .dequeueReusableCell(in: tableView, indexPath: indexPath)
        let entry = model.entries[indexPath.row]
        cell.accessoryType = entry.isDirectory ? .disclosureIndicator : .none
        cell.title = entry.url.lastPathComponent
        cell.image = entry.image
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.entries[indexPath.row].onSelect()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = model.entries[indexPath.row]
            output.delete(url: entry.url)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
