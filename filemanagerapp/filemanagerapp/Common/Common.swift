import UIKit
import SnapKit

typealias Action = () -> Void

public extension String {
    static let empty = String()

    var isNotEmpty: Bool {
        return !isEmpty
    }
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

public extension UITextField {
    func setImage(_ image: UIImage?) {
        guard let image = image else { return }
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit

        let containerView = UIView()
        containerView.frame = CGRect(x: 20, y: 0, width: 40, height: 40)
        containerView.addSubview(imageView)
        leftView = containerView
        leftViewMode = .always
    }

    func setLeftPadding(_ points: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: points, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPadding(_ points: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: points, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

public extension UIButton {
    var isDisabled: Bool { !isEnabled }

    var title: String? {
        get { return title(for: .normal) }
        set { setTitle(newValue, for: .normal)}
    }

    convenience init(title: String, titleColor: UIColor) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
    }

}

extension UIColor {
    var highlighted: UIColor { withAlphaComponent(0.3) }
    
    var image: UIImage {
        let pixel = CGSize(width: 1, height: 1)
        return UIGraphicsImageRenderer(size: pixel).image { context in
            self.setFill()
            context.fill(CGRect(origin: .zero, size: pixel))
        }
    }

    convenience init?(rgba: String?) {
        guard let rgba = rgba else { return nil }
        self.init(rgba: rgba)
    }

    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0

        let hexValue: UInt64 = strtoull(rgba.cString(using: .utf8), nil, 16)

        switch (rgba.count) {
        case 3:
            red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
            green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
            blue  = CGFloat(hexValue & 0x00F)              / 15.0
        case 4:
            red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
            green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
            blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
            alpha = CGFloat(hexValue & 0x000F)             / 15.0
        case 6:
            red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
            blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
        case 8:
            red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
            alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
        default:
            print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
        }

        self.init(red:red, green:green, blue:blue, alpha:alpha)
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

public extension UITableView {
    func deselectRowIfSelected(animated: Bool = true) {
        if let selectedRowIndexPath = indexPathForSelectedRow {
            deselectRow(at: selectedRowIndexPath, animated: animated)
        }
    }
}

public extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) { views.forEach(addArrangedSubview) }
}

public extension UIViewController {

    func showMessage(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

public extension UIBarButtonItem {
    func with(tintColor: UIColor, isEnabled: Bool = true) -> Self {
        self.tintColor = tintColor
        self.isEnabled = isEnabled
        return self
    }
}

extension URL: Comparable {
    public static func < (lhs: URL, rhs: URL) -> Bool {
        lhs.lastPathComponent < rhs.lastPathComponent
    }
}

extension FileManager {
    static var Documents: URL {
        let manager = FileManager.default
        let url = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        guard let url = url else {
            fatalError("Failed to retrieve document directory")
        }
        return url
    }
}
