import Foundation

class WishesStore {
    
    enum StorageType {
        case userDefaults
        case coreData
    }
    
    var onUpdate: (() -> Void)?
    var onRemove: ((Wish) -> Void)?
    
    private var storage: any Storage<Wish>
    private(set) var wishes: [Wish] = []
    
    init(
        wishes: [Wish] = [],
        storage: any Storage<Wish>,
        onUpdate: (() -> Void)? = nil,
        onRemove: ((Wish) -> Void)? = nil
    ) {
        self.wishes = wishes
        self.storage = storage
        self.onUpdate = onUpdate
        self.onRemove = onRemove
        
        load()
    }
    
    @discardableResult
    func add(_ wish: Wish) -> Bool {
        guard !wishes.contains(wish) else { return false }
        
        wishes.insert(wish, at: 0)
        
        save()
        onUpdate?()
        
        return true
    }
    
    @discardableResult
    func update(_ wish: Wish) -> Bool {
        guard let index = wishes.firstIndex(where: { $0.uuid == wish.uuid })
        else { return false }
        
        wishes[index] = wish
        
        save()
        onUpdate?()
        
        return true
    }
    
    @discardableResult
    func remove(_ wish: Wish) -> Wish? {
        guard let index = wishes.firstIndex(where: { $0 == wish })
        else { return nil }
        
        let removedWish = wishes.remove(at: index)
        
        save()
        onRemove?(removedWish)
        
        return removedWish
    }
    
    private func load() {
        Task {
            wishes = await storage.fetch()
            onUpdate?()
        }
    }
    
    private func save() {
        Task {
            await storage.save(wishes)
        }
    }
    
}
