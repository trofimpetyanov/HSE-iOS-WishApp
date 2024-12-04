import UIKit

class TextFieldContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var placeholder: String? = ""
        var onChange: (String) -> Void = { _ in }
        var onReturn: (String) -> Void = { _ in }

        func makeContentView() -> UIView & UIContentView {
            return TextFieldContentView(self)
        }
    }
    
    // MARK: - Constants
    private enum Constants {
        enum Layout {
            static let zero: CGFloat = .zero
            static let spacing: CGFloat = 8
            static let padding: CGFloat = 20
        }
    }
    
    // MARK: - UI
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        return textField
    }()
    
    // MARK: - Properties
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        setupTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textField.text = configuration.text
        textField.placeholder = configuration.placeholder
        
        let action = UIAction { [weak self] _ in
            guard let text = self?.textField.text
            else { return }
            
            configuration.onChange(text)
        }
        
        textField.addAction(action, for: .editingChanged)
    }
    
    private func setupTextField() {
        addSubview(textField)
        textField.pinVertical(to: self, Constants.Layout.spacing)
        textField.pinHorizontal(to: self, Constants.Layout.padding)
    }
}

// MARK: - UITextFieldDelegate
extension TextFieldContentView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let configuration = configuration as? TextFieldContentView.Configuration,
            let text = textField.text,
            !text.isEmpty
        else {
            textField.resignFirstResponder()
            return true
        }
        
        configuration.onReturn(text)
        textField.text = nil
        
        return true
    }
}

extension UITableViewCell {
    func textFieldConfiguration() -> TextFieldContentView.Configuration {
        TextFieldContentView.Configuration()
    }
}

extension UICollectionViewCell {
    func textFieldConfiguration() -> TextFieldContentView.Configuration {
        TextFieldContentView.Configuration()
    }
}
