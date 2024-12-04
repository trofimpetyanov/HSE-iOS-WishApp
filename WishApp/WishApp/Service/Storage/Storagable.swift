import Foundation

protocol Storagable: Codable {
    static var storageName: String { get }
}
