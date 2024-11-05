import UIKit

final class WishStoringTableViewController: UITableViewController {
    
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
            static let alertCancelButton = "OK"
            
            static let deleteAction = "Delete"
        }
    }
    
    private var dataSource: DataSource!
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupDataSource()
        setupTableView()
        
        updateSnapshot()
    }

    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.newWish, .wishes])
        snapshot.appendItems([.newWish], toSection: .newWish)
        snapshot.appendItems([.wish(Wish(title: "Be an astronaut"))], toSection: .wishes)
        dataSource.apply(snapshot)
    }
    
    private func updateSnapshot(removing wishes: [Wish]) {
        let rows = wishes.map { Row.wish($0) }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(rows)
        dataSource.apply(snapshot)
    }
    
    private func setupNavigationBar() {
        title = Constants.Strings.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let closeAction = UIAction { [weak self] _ in self?.dismiss(animated: true) }
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: closeAction)
    }
    
    private func setupTableView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        tableView.allowsSelection = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Identifiers.newWish)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Identifiers.wish)
    }

    private func setupDataSource() {
        dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, row in
            self?.handleCellConfiguration(for: indexPath, row: row)
        }
    }
    
    private func showAlert(_ title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constants.Strings.alertCancelButton, style: .cancel)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc
    private func hideKeyboard() {
        tableView.endEditing(true)
    }
}

// MARK: – Configurations
private extension WishStoringTableViewController {
    func handleCellConfiguration(for indexPath: IndexPath, row: Row) -> UITableViewCell {
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
    
    func handleAddWishConfiguration(cell: UITableViewCell?, indexPath: IndexPath, row: Row) {
        guard let cell, case .newWish = row else { return }

        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.placeholder = Constants.Strings.textFieldPlaceholder
        contentConfiguration.onSubmit = { _ in
            // TODO: Add to the Store.
        }
        
        cell.contentConfiguration = contentConfiguration
    }
    
    func handleWishConfiguration(cell: UITableViewCell?, indexPath: IndexPath, row: Row) {
        guard let cell, case .wish(let wish) = row else { return }

        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = wish.title
        cell.contentConfiguration = contentConfiguration
    }
}
