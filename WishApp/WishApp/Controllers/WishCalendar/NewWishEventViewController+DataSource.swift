import UIKit

extension NewWishEventViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    enum Section: Hashable {
        case main
    }
    
    enum Row: Hashable {
        case title
        case description
        case startDate
        case endDate
    }
}
