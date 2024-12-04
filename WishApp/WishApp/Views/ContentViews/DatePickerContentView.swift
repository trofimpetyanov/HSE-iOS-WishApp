import UIKit

class DatePickerContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var title: String?
        var date = Date.now
        var minimumDate: Date?
        var onChange: (Date) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return DatePickerContentView(self)
        }
    }
    
    private enum Constants {
        enum Layout {
            static let spacing: CGFloat = 8
            static let padding: CGFloat = 20
        }
    }
    
    private lazy var titleLabel = UILabel()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addAction(
            UIAction { [weak self] _ in self?.didPick(datePicker) },
            for: .valueChanged
        )
        return datePicker
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constants.Layout.spacing
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(datePicker)
        return stackView
    }()
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        titleLabel.text = configuration.title
        datePicker.date = configuration.date
        datePicker.minimumDate = configuration.minimumDate
    }
    
    private func setupView() {
        addSubview(stackView)
        stackView.pinVertical(to: self, Constants.Layout.spacing)
        stackView.pinHorizontal(to: self, Constants.Layout.padding)
    }
    
    @objc
    private func didPick(_ sender: UIDatePicker) {
        guard let configuration = configuration as? DatePickerContentView.Configuration else { return }
        
        configuration.onChange(sender.date)
    }
}

extension UICollectionViewListCell {
    func datePickerConfiguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}
