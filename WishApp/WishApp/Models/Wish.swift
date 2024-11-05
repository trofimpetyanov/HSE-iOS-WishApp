import Foundation

struct Wish {
    let title: String
}

extension Wish: Hashable { }

extension Wish: Storagable {
    static var storageName: String {
        "wishes"
    }
}
