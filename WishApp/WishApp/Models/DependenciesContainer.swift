import Foundation

struct DependenciesContainer {
    let wishesStore: WishesStore
    let wishEventsStore: WishEventsStore
    
    let calendarManager: CalendarManager
}

struct DependenciesContainerFactory {
    func make() -> DependenciesContainer {
        let wishesStore = WishesStore(storage: UserDefaultStorage<Wish>())
        let wishEventsStore = WishEventsStore(storage: UserDefaultStorage<WishEvent>())
        let calendarManager = CalendarManager()
        
        return DependenciesContainer(
            wishesStore: wishesStore,
            wishEventsStore: wishEventsStore,
            calendarManager: calendarManager
        )
    }
}
