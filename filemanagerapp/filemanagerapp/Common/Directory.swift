import Foundation

final class Directory {
    static func GetFiles(_ url: URL) -> [URL] {
        return (try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])) ?? []
    }

    static func CreateDirectory(_ url: URL) {
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }

    static func Delete(_ url: URL) {
        try? FileManager.default.removeItem(at: url)
    }

    static func CreateFile(_ url: URL, with data: Data) {
        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }
}
