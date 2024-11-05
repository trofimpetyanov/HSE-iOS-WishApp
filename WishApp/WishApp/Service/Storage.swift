import Foundation

protocol Storage<Item> {
    associatedtype Item
    
    func fetch() async -> [Item]
    
    @discardableResult
    func save(_ items: [Item]) async -> Bool
}
