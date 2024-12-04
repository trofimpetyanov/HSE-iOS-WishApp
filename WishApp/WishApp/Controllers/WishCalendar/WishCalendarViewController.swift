import UIKit

class WishCalendarViewController: UICollectionViewController {
    
    // MARK: - Constants
    private enum Constants {
        enum Layout {
            static let zero: CGFloat = 0
            static let padding: CGFloat = 16
            static let imagePointSize: CGFloat = 22
        }
        
        enum Strings {
            static let title = "Calendar"
        }
    }
    
    // MARK: - Properties
    private let dependenciesContainer: DependenciesContainer
    private let wishEventsStore: WishEventsStore
    
    private let wishColor: WishColor
    private var dataSource: DataSource!
    
    init(
        dependenciesContainer: DependenciesContainer,
        wishColor: WishColor
    ) {
        self.dependenciesContainer = dependenciesContainer
        self.wishEventsStore = dependenciesContainer.wishEventsStore
        self.wishColor = wishColor
        
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        updateSnapshot()
    }
    
    // MARK: - Methods
    
    // MARK: Setup
    private func setup() {
        setupNavigationBar()
        setupCollectionView()
        setupLayout()
        setupDataSource()
    }
    
    private func setupNavigationBar() {
        title = Constants.Strings.title
        navigationController?.navigationBar.tintColor = wishColor.color
        
        let closeAction = UIAction { [weak self] _ in self?.dismiss(animated: true) }
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: closeAction)
        
        setupAddButton()
        
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.setupAddButton()
        }
    }
    
    private func setupAddButton() {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: Constants.Layout.imagePointSize)
            .applying(
                UIImage.SymbolConfiguration(
                    hierarchicalColor: wishColor.color.adjustedForContrast(with: .systemGroupedBackground)
                )
            )
        
        let image = UIImage.add.withConfiguration(imageConfiguration)
        let addAction = UIAction { [weak self] _ in self?.showAddEvent() }
        let buttonItem = UIBarButtonItem(primaryAction: addAction)
        buttonItem.setSymbolImage(image, contentTransition: .automatic)
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.contentInset = UIEdgeInsets(
            top: Constants.Layout.padding,
            left: Constants.Layout.zero,
            bottom: Constants.Layout.padding,
            right: Constants.Layout.zero
        )
    }
    
    private func setupLayout() {
        let layout = UICollectionViewCompositionalLayout {
            section,
            environment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(64))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(64))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = Constants.Layout.padding
            section.contentInsets = NSDirectionalEdgeInsets(
                top: Constants.Layout.zero,
                leading: Constants.Layout.padding,
                bottom: Constants.Layout.zero,
                trailing: Constants.Layout.padding
            )
            
            return section
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        collectionView.dataSource = dataSource
    }
    
    // MARK: Update
    private func updateSnapshot(reloading items: [WishEvent] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(wishEventsStore.wishEvents.map { Item.event($0) })
        
        if !items.isEmpty {
            snapshot.reloadItems(items.map { Item.event($0) })
        }
        
        dataSource.apply(snapshot)
    }
    
    // MARK: - Navigation
    private func showAddEvent() {
        let addWishEventViewController = NewWishEventViewController(
            dependenciesContainer: dependenciesContainer,
            wishColor: wishColor
        )
        
        let navigationController = UINavigationController(rootViewController: addWishEventViewController)
        addWishEventViewController.delegate = self
        present(navigationController, animated: true)
    }
}

// MARK: - Configurations
private extension WishCalendarViewController {
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, item: Item) {
        guard case .event(let event) = item else { return }
        
        var contentConfiguration = cell.eventConfiguration()
        contentConfiguration.title = event.title
        contentConfiguration.description = event.description
        contentConfiguration.startDate = event.startDate
        contentConfiguration.endDate = event.endDate
        contentConfiguration.color = event.color
        cell.contentConfiguration = contentConfiguration
        
        cell.backgroundConfiguration = .clear()
    }
}

// MARK: - NewWishEventViewControllerDelegate
extension WishCalendarViewController: NewWishEventViewControllerDelegate {
    func newWishEventViewController(
        _ viewController: NewWishEventViewController,
        didCreate wishEvent: WishEvent
    ) {
        wishEventsStore.add(wishEvent)
        updateSnapshot()
    }
}
