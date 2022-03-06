import UIKit

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

extension EntryViewData {
    var name: String { return url.lastPathComponent }
}

extension FolderViewData {
    static let `default` = FolderViewData(url: URL(fileURLWithPath: .empty), entries: [])

    var name: String { url.lastPathComponent }

    func replaceEntries(_ entries: [EntryViewData]) -> FolderViewData {
        return FolderViewData(url: self.url, entries: entries)
    }
}
