import Foundation

class WishEventsStore {
    
    var onUpdate: (() -> Void)?
    
    private var storage: any Storage<WishEvent>
    private(set) var wishEvents: [WishEvent] = []
    
    init(
        wishEvents: [WishEvent] = [],
        storage: any Storage<WishEvent>,
        onUpdate: (() -> Void)? = nil
    ) {
        self.wishEvents = wishEvents
        self.storage = storage
        self.onUpdate = onUpdate
        
        load()
    }
    
    @discardableResult
    func add(_ wishEvent: WishEvent) -> Bool {
        guard !wishEvents.contains(wishEvent) else { return false }
        
        wishEvents.insert(wishEvent, at: 0)
        
        save()
        onUpdate?()
        
        return true
    }
    
    private func load() {
        Task {
            wishEvents = await storage.fetch()
            onUpdate?()
        }
    }
    
    private func save() {
        Task {
            await storage.save(wishEvents)
        }
    }
    
}
