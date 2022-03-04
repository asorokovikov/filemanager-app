import UIKit

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
