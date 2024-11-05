import UIKit

class AddWishContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var placeholder: String? = ""
        var onSubmit: (String) -> Void = { _ in }

        func makeContentView() -> UIView & UIContentView {
            return AddWishContentView(self)
        }
    }
    
    private enum Constants {
        enum Layout {
            static let zero: CGFloat = .zero
            static let padding: CGFloat = 20
        }
    }
    
    let textField = UITextField()
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
        
        configureTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textField.text = configuration.text
        textField.placeholder = configuration.placeholder
    }
    
    private func configureTextField() {
        addSubview(textField)
        textField.pinVertical(to: self, Constants.Layout.zero)
        textField.pinHorizontal(to: self, Constants.Layout.padding)
        
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
    }
}

extension AddWishContentView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let configuration = configuration as? AddWishContentView.Configuration,
            let result = textField.text,
            !result.isEmpty
        else {
            textField.resignFirstResponder()
            return true
        }
        
        configuration.onSubmit(result)
        textField.text = nil
        
        return true
    }
}

extension UITableViewCell {
    func textFieldConfiguration() -> AddWishContentView.Configuration {
        AddWishContentView.Configuration()
    }
}
