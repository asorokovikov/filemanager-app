import UIKit

typealias Action = () -> Void

public extension String {
    static let empty = String()
}

public extension UICollectionViewCell {
    class var baseReuseIdentifier: String {
        return String(describing: self)
    }

    class func registerClass(in collectionView: UICollectionView) {
        collectionView.register(self, forCellWithReuseIdentifier: self.baseReuseIdentifier)
    }

    class func dequeueReusableCell<T>(in collectionView: UICollectionView, indexPath: IndexPath) -> T {
        return collectionView.dequeueReusableCell(withReuseIdentifier: self.baseReuseIdentifier, for: indexPath) as! T
    }
}

public extension UITableViewCell {
    class var baseReuseIdentifier: String {
        return String(describing: self)
    }

    class func registerClass(in tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: self.baseReuseIdentifier)
    }

    class func dequeueReusableCell<T: UITableViewCell>(in tableView: UITableView, indexPath: IndexPath) -> T {
        return tableView.dequeueReusableCell(withIdentifier: self.baseReuseIdentifier, for: indexPath) as! T
    }

    internal class var nib: UINib {
        return UINib(nibName: "\(self)", bundle: Bundle.main)
    }

    class func registerNib(in tableView: UITableView) {
        tableView.register(self.nib, forCellReuseIdentifier: self.baseReuseIdentifier)
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}

extension URL {
    var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }

    func loadImage() -> UIImage? {
        let data = try? Data(contentsOf: self)
        if let data = data {
            return UIImage(data: data)
        }
        return nil
    }

    func getFileImage() -> UIImage? {
        return ImageCache.GetImage(self)

    }
}

extension Dictionary {
    func containsKey(_ key: Key) -> Bool {
        return self.keys.contains(key)
    }

    func tryGetValue(_ key: Key) -> Value? {
        if let index = index(forKey: key) {
            return self.values[index]
        }
        return nil
    }
}

final class ImageCache {
    static private var images: [URL: UIImage?] = [:]

    static func GetImage(_ url: URL) -> UIImage? {
        if let index = images.index(forKey: url) {
            return images.values[index]
        }
        let image = url.loadImage()
        images[url] = image
        return image
    }
}
