import UIKit

final class WishMakerViewController: UIViewController {
    
    // MARK: Constants
    private enum Constants {
        enum Layout {
            static let zero: CGFloat = 0
            static let spacing: CGFloat = 8
            static let padding: CGFloat = 20
            
            static let primaryCornerRadius: CGFloat = 20
            static let secondaryCornerRadius: CGFloat = 16
            
            static let primaryButtonHeight: CGFloat = 52
            static let secondaryButtonHeight: CGFloat = 40
        }
        
        enum Settings {
            static let sliderMin: Double = 0
            static let sliderMax: Double = 1
            
            static let animationDuratione: TimeInterval = 0.2
        }
        
        enum Strings {
            static let title = "WishMaker"
            static let description = "This app will bring you joy and will fulfill three of your wishes!\n • The first wish is to change the background color"
            
            static let red = "Red"
            static let green = "Green"
            static let blue = "Blue"
            
            static let randomize = "Randomize"
            static let colorPicker = "Color Picker"
            
            static let myWishes = "My Wishes"
        }
    }
    
    // MARK: – UI
    
    // MARK: Labels
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Strings.description
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    // MARK: Slider View
    private lazy var redSlider: TitledSlider = {
        let titledSlider = TitledSlider(Constants.Strings.red)
        titledSlider.valueChanged = { [weak self] value in
            self?.wishColor.red = value
        }
        return titledSlider
    }()
    
    private lazy var greenSlider: TitledSlider = {
        let titledSlider = TitledSlider(Constants.Strings.green)
        titledSlider.valueChanged = { [weak self] value in
            self?.wishColor.green = value
        }
        return titledSlider
    }()
    
    private lazy var blueSlider: TitledSlider = {
        let titledSlider = TitledSlider(Constants.Strings.blue)
        titledSlider.valueChanged = { [weak self] value in
            self?.wishColor.blue = value
        }
        return titledSlider
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        return blurView
    }()
    
    // MARK: Buttons
    private lazy var randomizeButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = Constants.Strings.randomize
        configuration.image = UIImage(systemName: "sparkles")
        configuration.imagePadding = Constants.Layout.spacing
        configuration.cornerStyle = .fixed
        configuration.background.cornerRadius = Constants.Layout.secondaryButtonHeight
        
        let button = UIButton(configuration: configuration)
        let action = UIAction { [weak self] _ in
            self?.randomizeColor()
        }
        
        button.addAction(action, for: .touchUpInside)

        return button
    }()
    
    private lazy var colorPickerButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = Constants.Strings.colorPicker
        configuration.image = UIImage(systemName: "eyedropper")
        configuration.imagePadding = Constants.Layout.spacing
        configuration.cornerStyle = .fixed
        configuration.background.cornerRadius = Constants.Layout.secondaryButtonHeight

        
        let button = UIButton(configuration: configuration)
        let action = UIAction { [weak self] _ in
            self?.showColorPicker()
        }
        
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var myWishesButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = Constants.Strings.myWishes
        configuration.cornerStyle = .large
        
        let button = UIButton(configuration: configuration)
        let action = UIAction { [weak self] _ in
            self?.showMyWishes()
        }
        
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Stack Views
    private lazy var slidersStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.spacing
        
        stackView.addArrangedSubview(redSlider)
        stackView.addArrangedSubview(greenSlider)
        stackView.addArrangedSubview(blueSlider)
        
        return stackView
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constants.Layout.spacing
        stackView.addArrangedSubview(randomizeButton)
        stackView.addArrangedSubview(colorPickerButton)
        return stackView
    }()
    
    private lazy var controlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.spacing
        stackView.addArrangedSubview(slidersStackView)
        stackView.addArrangedSubview(buttonsStackView)
        return stackView
    }()
    
    private lazy var controlsView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.Layout.primaryCornerRadius
        view.addSubview(blurView)
        view.addSubview(controlsStackView)
        return view
    }()
    
    // MARK: – Properties
    private var areControlsHidden = false
    
    private var wishColor = WishColor() {
        didSet {
            updateUI()
        }
    }
    
    //MARK: – Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: – Methods
    
    // MARK: Setup
    private func setupUI() {
        view.backgroundColor = wishColor.color
        
        setupNavigationBar()
        setupLabels()
        setupMyWishesButton()
        setupControls()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.Strings.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: wishColor.color.idealTextColor]
        
        let showControlsAction = UIAction { [weak self] _ in
            self?.toggleControls()
        }
        
        let settingsBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "slider.horizontal.2.square"),
            primaryAction: showControlsAction
        )
        
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
    private func setupLabels() {
        view.addSubview(descriptionLabel)
        descriptionLabel.pinEdges(
            [.top, .leading, .trailing],
            to: view,
            constant: Constants.Layout.padding
        )
    }
    
    private func setupMyWishesButton() {
        view.addSubview(myWishesButton)
        myWishesButton.pinHeight(Constants.Layout.primaryButtonHeight)
        myWishesButton.pinEdges(
            [.leading, .trailing, .bottom],
            to: view,
            constant: Constants.Layout.padding
        )
    }
    
    private func setupControls() {
        // Controls View
        view.addSubview(controlsView)
        controlsView.pinHorizontal(to: view, Constants.Layout.padding)
        controlsView.pinBottomToTop(of: myWishesButton, constant: Constants.Layout.padding)
        
        // Blur View
        blurView.pinEdges(
            UIView.Edge.allCases,
            to: controlsView,
            constant: Constants.Layout.zero
        )
        
        // Controls Stack View
        controlsStackView.pinEdges(
            UIView.Edge.allCases,
            to: controlsView,
            constant: Constants.Layout.spacing
        )
        
        // Control Buttons
        randomizeButton.pinHeight(Constants.Layout.secondaryButtonHeight)
        colorPickerButton.pinHeight(Constants.Layout.secondaryButtonHeight)
    }
    
    // MARK: Update
    private func updateUI() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: wishColor.color.idealTextColor]
        descriptionLabel.textColor = wishColor.color.idealTextColor
        
        redSlider.slider.setValue(Float(wishColor.red), animated: true)
        greenSlider.slider.setValue(Float(wishColor.green), animated: true)
        blueSlider.slider.setValue(Float(wishColor.blue), animated: true)
        
        for slider in [redSlider, greenSlider, blueSlider] {
            slider.setTextColor(for: wishColor.color)
        }
        
        UIView.animate(withDuration: Constants.Settings.animationDuratione) {
            self.view.backgroundColor = self.wishColor.color
        }
    }
    
    // MARK: Actions
    private func randomizeColor() {
        let randomColor = UIColor.randomRGB()
        wishColor.red = randomColor.red
        wishColor.green = randomColor.green
        wishColor.blue = randomColor.blue
    }
    
    private func showColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = Constants.Strings.colorPicker
        colorPicker.supportsAlpha = false
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        colorPicker.popoverPresentationController?.sourceItem = colorPickerButton
        
        present(colorPicker, animated: true)
    }
    
    private func toggleControls() {
        areControlsHidden.toggle()
        
        if areControlsHidden {
            UIView.animate(withDuration: Constants.Settings.animationDuratione) {
                self.controlsView.alpha = self.areControlsHidden ? 0 : 1
            } completion: { _ in
                self.controlsView.isHidden = self.areControlsHidden
            }
        } else {
            controlsView.isHidden = false
            
            UIView.animate(withDuration: Constants.Settings.animationDuratione) {
                self.controlsView.alpha = self.areControlsHidden ? 0 : 1
            }
        }
    }
    
    // MARK: Navigation
    private func showMyWishes() {
        let wishStoringTableViewController = WishStoringTableViewController()
        let navigationController = UINavigationController(rootViewController: wishStoringTableViewController)
        
        present(navigationController, animated: true)
    }
}

extension WishMakerViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        let (red, green, blue) = color.components()
        wishColor.red = red
        wishColor.green = green
        wishColor.blue = blue
    }
}
