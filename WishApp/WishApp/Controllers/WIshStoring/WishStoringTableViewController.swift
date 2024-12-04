import UIKit

// MARK: - WishStoringTableViewControllerDelegate
protocol WishStoringTableViewControllerDelegate: AnyObject {
    func wishStoringTableViewController(_ controller: WishStoringTableViewController, didSelectWish wish: Wish)
}

final class WishStoringTableViewController: UITableViewController {
    
    // MARK: - Constants
    private enum Constants {
        enum Identifiers {
            static let newWish = "newWishCell"
            static let wish = "wishCell"
        }
        
        enum Strings {
            static let title = "My Wishes"
            static let textFieldPlaceholder = "My new wish is..."
            
            static let wishAlreadyExistsAlertTitle = "Wish already exist!"
            static let wishAlreadyExistsAlertMessage = "Try to come up with a new wish or fulfill this one"
            static let editWishAlertTitle = "Edit the wish"
            
            static let alertSaveButton = "Save"
            static let alertCancelButton = "Cancel"
            
            static let editAction = "Edit"
            static let deleteAction = "Delete"
        }
    }
    
    // MARK: - Properties
    private let dependenciesContainer: DependenciesContainer
    private let wishesStore: WishesStore
    
    private var dataSource: DataSource!
    
    weak var delegate: WishStoringTableViewControllerDelegate?
    
    init(dependenciesContainer: DependenciesContainer) {
        self.dependenciesContainer = dependenciesContainer
        self.wishesStore = dependenciesContainer.wishesStore
        
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupDataSource()
        setupTableView()
        
        updateSnapshot()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let wish = dataSource.itemIdentifier(for: indexPath), case .wish(let wish) = wish
        else { return }
        
        delegate?.wishStoringTableViewController(self, didSelectWish: wish)
    }

    // MARK: - Methods
    
    // MARK: Setup
    private func setupNavigationBar() {
        title = Constants.Strings.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if delegate == nil {
            let closeAction = UIAction { [weak self] _ in self?.dismiss(animated: true) }
            navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: closeAction)
        }
    }
    
    private func setupTableView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Identifiers.newWish)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Identifiers.wish)
    }

    private func setupDataSource() {
        wishesStore.onUpdate = {
            DispatchQueue.main.async { [weak self] in
                self?.updateSnapshot()
            }
        }
        
        wishesStore.onRemove = { wish in
            DispatchQueue.main.async { [weak self] in
                self?.updateSnapshot(removing: [wish])
            }
        }
        
        dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, row in
            self?.handleCellConfiguration(for: indexPath, row: row)
        }
    }
    
    // MARK: Update
    func updateSnapshot() {
        let wishes = wishesStore.wishes.map { Row.wish($0) }
        
        var snapshot = Snapshot()
        snapshot.appendSections([.newWish, .wishes])
        snapshot.appendItems([.newWish], toSection: .newWish)
        snapshot.appendItems(wishes, toSection: .wishes)
        dataSource.apply(snapshot)
    }
    
    func updateSnapshot(removing wishes: [Wish]) {
        let rows = wishes.map { Row.wish($0) }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(rows)
        dataSource.apply(snapshot)
    }
    
    // MARK: Helpers
    private func deleteAction(forRowAt indexPath: IndexPath) -> UIContextualAction? {
        guard
            let item = dataSource.itemIdentifier(for: indexPath),
            case .wish(let wish) = item
        else { return nil }
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: Constants.Strings.deleteAction
        ) { [weak self] _, _, completion in
            self?.wishesStore.remove(wish)
            
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return deleteAction
    }
    
    private func editAction(forRowAt indexPath: IndexPath) -> UIContextualAction? {
        guard
            let item = dataSource.itemIdentifier(for: indexPath),
            case .wish(let wish) = item
        else { return nil }
        
        let editAction = UIContextualAction(
            style: .normal,
            title: Constants.Strings.editAction
        ) { [weak self] _, _, completion in
            self?.showEditAlert(for: wish)
            
            completion(true)
        }
        
        editAction.image = UIImage(systemName: "pencil")
        
        return editAction
    }
    
    // MARK: Alerts
    private func showAlert(_ title: String, message: String? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: Constants.Strings.alertCancelButton,
            style: .cancel
        )
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func showEditAlert(for wish: Wish) {
        let alertController = UIAlertController(
            title: Constants.Strings.editWishAlertTitle,
            message: nil,
            preferredStyle: .alert
        )
        
        let saveAction = UIAlertAction(
            title: Constants.Strings.alertSaveButton,
            style: .default,
            handler: { [weak self, weak alertController] _ in
                guard
                    let result = alertController?.textFields?[0].text,
                    !result.isEmpty
                else { return }
                
                let updatedWish = Wish(uuid: wish.uuid, title: result)
                self?.wishesStore.update(updatedWish)
            }
        )
        
        let cancelAction = UIAlertAction(
            title: Constants.Strings.alertCancelButton,
            style: .cancel
        )
        
        alertController.addTextField { textField in
            textField.text = wish.title
            textField.placeholder = Constants.Strings.textFieldPlaceholder
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc
    private func hideKeyboard() {
        tableView.endEditing(true)
    }
}

// MARK: - Table View Delegate
extension WishStoringTableViewController {
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        var actions: [UIContextualAction] = []
        
        if let deleteAction = deleteAction(forRowAt: indexPath) { actions.append(deleteAction) }
        if let editAction = editAction(forRowAt: indexPath) { actions.append(editAction) }
        
        return UISwipeActionsConfiguration(actions: actions)
    }
}

// MARK: - Configurations
private extension WishStoringTableViewController {
    func handleCellConfiguration(
        for indexPath: IndexPath,
        row: Row
    ) -> UITableViewCell {
        guard let section = dataSource.sectionIdentifier(for: indexPath.section)
        else { return UITableViewCell() }
        
        let cell: UITableViewCell?
        
        switch section {
        case .newWish:
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.newWish)
            handleAddWishConfiguration(cell: cell, indexPath: indexPath, row: row)
        case .wishes:
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.wish)
            handleWishConfiguration(cell: cell, indexPath: indexPath, row: row)
        }
        
        return cell ?? UITableViewCell()
    }
    
    func handleAddWishConfiguration(
        cell: UITableViewCell?,
        indexPath: IndexPath,
        row: Row
    ) {
        guard let cell, case .newWish = row else { return }

        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.placeholder = Constants.Strings.textFieldPlaceholder
        contentConfiguration.onReturn = { [weak self] title in
            guard let self else { return }
            let wish = Wish(title: title)
            
            if !self.wishesStore.add(wish) {
                self.showAlert(
                    Constants.Strings.wishAlreadyExistsAlertTitle,
                    message: Constants.Strings.wishAlreadyExistsAlertMessage
                )
            }
        }
        
        cell.contentConfiguration = contentConfiguration
    }
    
    func handleWishConfiguration(
        cell: UITableViewCell?,
        indexPath: IndexPath,
        row: Row
    ) {
        guard let cell, case .wish(let wish) = row else { return }

        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = wish.title
        cell.contentConfiguration = contentConfiguration
    }
}
