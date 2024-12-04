import UIKit

final class TitledSlider: UIView {
    
    //MARK: Constants
    enum Constants {
        enum Layout {
            static let spacing: CGFloat = 4
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIFont.labelFontSize, weight: .semibold)
        return label
    }()
    
    lazy var slider = UISlider()
    
    var valueChanged: ((Double) -> Void)?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.spacing
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(slider)
        return stackView
    }()
    
    init(
        _ title: String,
        minimumValue: Double = 0,
        maximumValue: Double = 1,
        valueChanged: ((Double) -> Void) = { _ in }
    ) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        
        slider.minimumValue = Float(minimumValue)
        slider.maximumValue = Float(maximumValue)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(stackView)
        stackView.pinEdges(
            UIView.Edge.allCases,
            to: self,
            constant: Constants.Layout.spacing
        )
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    @objc
    private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}
