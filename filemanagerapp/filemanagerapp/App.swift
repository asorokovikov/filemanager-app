import UIKit

final class App {
    enum Color {
        static let text = UIColor.label
        static let secondaryText = UIColor.secondaryLabel
        static let background = UIColor.systemBackground
        static let secondaryBackground = UIColor.secondarySystemBackground
        static let success = UIColor.systemGreen
        static let failure = UIColor.systemRed
//        static let primary = UIColor(rgba: "00ABFF")
        static let primary = UIColor.systemBlue
        static let inactive = UIColor.secondarySystemBackground
        static let inactiveText = UIColor.placeholderText
    }

    enum Images {
        static let heart = UIImage(systemName: "heart")
        static let heartFill = UIImage(systemName: "heart.fill")
        static let bookmark = UIImage(systemName: "bookmark")
        static let bookmarkFill = UIImage(systemName: "bookmark.fill")
        static let house = UIImage(systemName: "house")
        static let houseFill = UIImage(systemName: "house.fill")
        static let gearshape = UIImage(systemName: "gearshape")
        static let gearshapeFill = UIImage(systemName: "gearshape.fill")
        static let person = UIImage(systemName: "person.circle")
        static let personFill = UIImage(systemName: "person.circle.fill")
        static let key = UIImage(systemName: "key")
        static let newFolder = UIImage(systemName: "folder.badge.plus")
        static let photo = UIImage(systemName: "photo")
        static let folder = UIImage(systemName: "folder.fill")
        static let lockFill = UIImage(systemName: "lock.fill")
        static let xmark = UIImage(systemName: "xmark")
        static let danger = UIImage(systemName: "exclamationmark.circle")!
        static let checkmarkCircle = UIImage(systemName: "checkmark.circle")!
    }
}

struct AppStyleGuide {

    @discardableResult
    static func configureTableViewDestructiveCell(_ cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = App.Color.failure
        return cell
    }

    @discardableResult
    static func configureTableViewButtonCell(_ cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.textColor = App.Color.primary
        cell.textLabel?.textAlignment = .center
        return cell
    }

    @discardableResult
    static func configureTableViewCell(_ cell: UITableViewCell) -> UITableViewCell {
        return cell
    }
}
