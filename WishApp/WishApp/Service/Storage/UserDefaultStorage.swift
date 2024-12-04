import Foundation

class UserDefaultStorage<Item: Storagable>: Storage {
    typealias Item = Item
    
    private let defaults = UserDefaults.standard
    
    func fetch() async -> [Item] {
        guard
            let string = defaults.string(forKey: Item.storageName),
            let data = string.data(using: .utf8),
            let array = try? JSONDecoder().decode([Item].self, from: data)
        else { return [] }
        
        return array
    }
    
    @discardableResult
    func save(_ items: [Item]) async -> Bool {
        guard 
            let data = try? JSONEncoder().encode(items),
            let string = String(data: data, encoding: .utf8)
        else { return false }
        
        defaults.setValue(string, forKey: Item.storageName)
        
        return true
    }
}
