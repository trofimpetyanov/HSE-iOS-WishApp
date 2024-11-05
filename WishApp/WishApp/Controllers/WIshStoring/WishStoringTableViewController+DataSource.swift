import UIKit

extension WishStoringTableViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    enum Section: Hashable {
        case newWish, wishes
        
        var title: String? {
            switch self {
            case .newWish: nil
            case .wishes: "My wishes are..."
            }
        }
    }
    
    enum Row: Hashable {
        case newWish
        case wish(Wish)
        
        static func == (lhs: WishStoringTableViewController.Row, rhs: WishStoringTableViewController.Row) -> Bool {
            switch (lhs, rhs) {
            case (.wish(let lhsWish), .wish(let rhsWish)):
                return lhsWish == rhsWish
            case (.newWish, .newWish):
                return true
            default:
                return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .newWish:
                hasher.combine(0)
            case .wish(let wish):
                hasher.combine(wish)
            }
        }
    }
}
