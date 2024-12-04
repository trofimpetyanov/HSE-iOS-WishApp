import Foundation

struct Wish {
    let uuid: UUID
    var title: String
    
    init(uuid: UUID = UUID(), title: String) {
        self.uuid = uuid
        self.title = title
    }
}

extension Wish: Hashable { }

extension Wish: Storagable {
    static var storageName: String { "wishes" }
}
