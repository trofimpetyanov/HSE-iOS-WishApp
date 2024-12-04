import UIKit

// MARK: - NewWishEventViewControllerDelegate
protocol NewWishEventViewControllerDelegate: AnyObject {
    func newWishEventViewController(
        _ viewController: NewWishEventViewController,
        didCreate wishEvent: WishEvent
    )
}

final class NewWishEventViewController: UICollectionViewController {
    
    // MARK: - Constants
    private enum Constants {
        enum Strings {
            static let title = "New Event"
            static let cancel = "Cancel"
            static let save = "Save"
            
            static let titlePlaceholder = "Select a wish"
            static let descriptionPlaceholder = "Description"
            
            static let startDate = "Start Date"
            static let endDate = "End Date"
            
            static let alertTitle = "Error"
            static let alertDescription = "Choose a wish"
            static let alertAction = "OK"
        }
    }
    
    // MARK: - Properties
    weak var delegate: NewWishEventViewControllerDelegate?
    
    private let dependenciesContainer: DependenciesContainer
    private let calendarManager: CalendarManager
    
    private var wishColor: WishColor
    private var dataSource: DataSource!
    
    private var eventTitle: String = ""
    private var eventDescription: String = ""
    private var startDate = Calendar.current.startOfDay(for: Date())
    private var endDate = Date()
    
    init(
        dependenciesContainer: DependenciesContainer,
        wishColor: WishColor
    ) {
        self.dependenciesContainer = dependenciesContainer
        self.calendarManager = dependenciesContainer.calendarManager
        self.wishColor = wishColor
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupDataSource()
        updateSnapshot()
        updateDates()
    }
    
    // MARK: - Methods
    
    // MARK: Setup
    private func setupNavigationBar() {
        title = Constants.Strings.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cancelButton = UIBarButtonItem(
            title: Constants.Strings.cancel,
            primaryAction: UIAction { [weak self] _ in self?.cancelTapped() }
        )
        
        let saveButton = UIBarButtonItem(
            title: Constants.Strings.save,
            primaryAction: UIAction { [weak self] _ in self?.saveTapped() }
        )
        saveButton.style = .done
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Row> { [weak self] cell, indexPath, row in
            self?.handleCellConfiguration(cell, for: indexPath, row: row)
        }
        
        dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, row in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: row
            )
        }
    }
    
    // MARK: Update
    private func updateSnapshot(reloading items: [Row] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.title, .description, .startDate, .endDate], toSection: .main)
        
        if !items.isEmpty {
            snapshot.reloadItems(items)
        }
        
        dataSource.apply(snapshot)
    }
    
    private func updateDates() {
        let newEndDate = Calendar.current.startOfDay(
            for: Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? .now
        )
        
        endDate = max(newEndDate, endDate)
    }
    
    // MARK: Actions
    private func cancelTapped() {
        dismiss(animated: true)
    }
    
    private func saveTapped() {
        guard !eventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            let alert = UIAlertController(
                title: Constants.Strings.alertTitle,
                message: Constants.Strings.alertDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: Constants.Strings.alertAction, style: .default))
            present(alert, animated: true)
            return
        }
        
        let wishEvent = WishEvent(
            title: eventTitle,
            description: eventDescription,
            startDate: startDate,
            endDate: endDate,
            color: wishColor.color
        )
        
        createCalendarEvent(for: wishEvent)
        
        delegate?.newWishEventViewController(self, didCreate: wishEvent)
        dismiss(animated: true)
    }
    
    // MARK: Helpers
    private func createCalendarEvent(for wishEvent: WishEvent) {
        let calendarEvent = CalendarEvent(
            title: wishEvent.title,
            note: wishEvent.description,
            startDate: wishEvent.startDate,
            endDate: wishEvent.endDate
        )
        
        calendarManager.create(eventModel: calendarEvent)
    }
}

// MARK: - Configurations
private extension NewWishEventViewController {
    private func handleCellConfiguration(
        _ cell: UICollectionViewListCell,
        for indexPath: IndexPath,
        row: Row
    ) {
        switch row {
        case .title:
            self.handleTitleConfiguration(cell: cell)
        case .description:
            self.handleDescriptionConfiguration(cell: cell)
        case .startDate:
            self.handleStartDateConfiguration(cell: cell)
        case .endDate:
            self.handleEndDateConfiguration(cell: cell)
        }
    }
    
    func handleTitleConfiguration(cell: UICollectionViewListCell) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = eventTitle.isEmpty ? Constants.Strings.titlePlaceholder : eventTitle
        configuration.textProperties.color = eventTitle.isEmpty ? .secondaryLabel : .label
        cell.contentConfiguration = configuration
        cell.accessories = [.disclosureIndicator()]
    }
    
    func handleDescriptionConfiguration(cell: UICollectionViewListCell) {
        var configuration = cell.textFieldConfiguration()
        configuration.text = eventDescription
        configuration.placeholder = Constants.Strings.descriptionPlaceholder
        configuration.onChange = { [weak self] text in
            self?.eventDescription = text
        }
        cell.contentConfiguration = configuration
    }
    
    func handleStartDateConfiguration(cell: UICollectionViewListCell) {
        var configuration = cell.datePickerConfiguration()
        configuration.title = Constants.Strings.startDate
        configuration.date = startDate
        configuration.minimumDate = Calendar.current.startOfDay(for: Date())
        configuration.onChange = { [weak self] date in
            self?.startDate = Calendar.current.startOfDay(for: date)
            self?.updateDates()
            self?.updateSnapshot(reloading: [.startDate, .endDate])
        }
        cell.contentConfiguration = configuration
    }
    
    func handleEndDateConfiguration(cell: UICollectionViewListCell) {
        var configuration = cell.datePickerConfiguration()
        configuration.title = Constants.Strings.endDate
        configuration.date = endDate
        configuration.minimumDate = Calendar.current.startOfDay(for:
            Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        )
        configuration.onChange = { [weak self] date in
            self?.endDate = Calendar.current.startOfDay(for: date)
        }
        cell.contentConfiguration = configuration
    }
}

// MARK: - UICollectionViewDelegate
extension NewWishEventViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let row = dataSource.itemIdentifier(for: indexPath), case .title = row else { return }
        
        let wishStoringViewController = WishStoringTableViewController(dependenciesContainer: self.dependenciesContainer)
        wishStoringViewController.delegate = self
        wishStoringViewController.navigationItem.leftBarButtonItem = nil
        navigationController?.pushViewController(wishStoringViewController, animated: true)
    }
}

// MARK: - WishStoringTableViewControllerDelegate
extension NewWishEventViewController: WishStoringTableViewControllerDelegate {
    func wishStoringTableViewController(_ controller: WishStoringTableViewController, didSelectWish wish: Wish) {
        eventTitle = wish.title
        updateSnapshot(reloading: [.title])
        
        navigationController?.popViewController(animated: true)
    }
}
