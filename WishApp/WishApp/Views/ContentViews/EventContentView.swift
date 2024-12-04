import UIKit

class EventContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var title: String = ""
        var description: String? = nil
        var startDate: Date = Date()
        var endDate: Date = Date()
        var color: UIColor = .systemBlue
        
        func makeContentView() -> UIView & UIContentView {
            return EventContentView(self)
        }
    }
    
    // MARK: - Constants
    private enum Constants {
        enum Layout {
            static let zero: CGFloat = 0
            static let spacing: CGFloat = 8
            static let padding: CGFloat = 16
            
            static let cornerRadius: CGFloat = 16
            static let borderWidth: CGFloat = 2
        }
        
        enum Settings {
            static let shadowOpacity: Float = 0.2
            static let shadowRadius: CGFloat = 8
            static let shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    // MARK: - UI
    
    // MARK: Labels
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let dateRangeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: Views
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.Layout.spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(dateRangeLabel)
        return stack
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(stackView)
        return view
    }()
    
    // MARK: Properties
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        setupContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupContainerView() {
        addSubview(containerView)
        containerView.pinEdges(
            UIView.Edge.allCases,
            to: self,
            constant: Constants.Layout.zero
        )
        
        // Corner Radius
        containerView.backgroundColor = .secondarySystemGroupedBackground
        containerView.layer.cornerRadius = Constants.Layout.cornerRadius
        containerView.layer.borderWidth = Constants.Layout.borderWidth
        containerView.clipsToBounds = true
        
        // Shadow
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = Constants.Settings.shadowOpacity
        containerView.layer.shadowRadius = Constants.Settings.shadowRadius
        containerView.layer.shadowOffset = Constants.Settings.shadowOffset
        containerView.layer.masksToBounds = false
        
        // Stack View
        stackView.pinEdges(
            UIView.Edge.allCases,
            to: containerView,
            constant: Constants.Layout.padding
        )
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        
        titleLabel.text = configuration.title
        descriptionLabel.text = configuration.description
        descriptionLabel.isHidden = configuration.description?.isEmpty ?? true
        
        let startDateString = configuration.startDate.formatted(date: .abbreviated, time: .omitted)
        let endDateString = configuration.endDate.formatted(date: .abbreviated, time: .omitted)
        dateRangeLabel.text = "\(startDateString) - \(endDateString)"
        
        containerView.layer.borderColor = configuration.color.cgColor
        containerView.layer.shadowColor = configuration.color.cgColor
    }
}

extension UICollectionViewCell {
    func eventConfiguration() -> EventContentView.Configuration {
        EventContentView.Configuration()
    }
}

