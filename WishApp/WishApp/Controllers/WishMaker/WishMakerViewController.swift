import UIKit

final class WishMakerViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        enum Layout {
            static let zero: CGFloat = 0
            static let spacing: CGFloat = 8
            static let padding: CGFloat = 20
            
            static let primaryButtonHeight: CGFloat = 48
            static let secondaryButtonHeight: CGFloat = 40
            
            static let cornerRadius: CGFloat = 24
        }
        
        enum Settings {
            static let sliderMin: Double = 0
            static let sliderMax: Double = 1
            
            static let animationDuratione: TimeInterval = 0.2
            
            static let gradientStart: NSNumber = 0.16
            static let gradientEnd: NSNumber = 0.64
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
            static let scheduleWishes = "Schedule Wishes"
        }
    }
    
    // MARK: - UI
    
    // MARK: Labels
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Strings.description
        label.numberOfLines = 0
        label.textColor = wishColor.color.idealTextColor
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
    
    // MARK: Buttons
    private lazy var randomizeButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = Constants.Strings.randomize
        configuration.image = UIImage(systemName: "sparkles")
        configuration.imagePadding = Constants.Layout.spacing
        configuration.cornerStyle = .capsule
        
        let button = UIButton(configuration: configuration)
        let action = UIAction { [weak self] _ in
            self?.randomizeColor()
        }
        
        button.addAction(action, for: .touchUpInside)

        return button
    }()
    
    private lazy var colorPickerButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = Constants.Strings.colorPicker
        configuration.image = UIImage(systemName: "eyedropper")
        configuration.imagePadding = Constants.Layout.spacing
        configuration.cornerStyle = .capsule

        
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
    
    private lazy var scheduleButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = Constants.Strings.scheduleWishes
        configuration.cornerStyle = .large
        
        let button = UIButton(configuration: configuration)
        let action = UIAction { [weak self] _ in
            self?.showCalendar()
        }
        
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Views
    private lazy var gradientLayer = CAGradientLayer()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        return blurView
    }()
    
    private lazy var slidersStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.spacing
        
        stackView.addArrangedSubview(redSlider)
        stackView.addArrangedSubview(greenSlider)
        stackView.addArrangedSubview(blueSlider)
        
        return stackView
    }()
    
    private lazy var colorButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constants.Layout.spacing
        stackView.addArrangedSubview(randomizeButton)
        stackView.addArrangedSubview(colorPickerButton)
        return stackView
    }()
    
    private lazy var colorControlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.spacing
        stackView.addArrangedSubview(slidersStackView)
        stackView.addArrangedSubview(colorButtonsStackView)
        return stackView
    }()
    
    private lazy var colorControlsView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.Layout.cornerRadius
        view.addSubview(blurView)
        view.addSubview(colorControlsStackView)
        return view
    }()
    
    private lazy var primaryControlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.spacing
        stackView.addArrangedSubview(myWishesButton)
        stackView.addArrangedSubview(scheduleButton)
        return stackView
    }()
    
    private lazy var controlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.spacing
        stackView.addArrangedSubview(slidersStackView)
        stackView.addArrangedSubview(colorControlsView)
        return stackView
    }()
    
    // MARK: - Properties
    private let dependenciesContainer: DependenciesContainer
    private var areControlsHidden = false
    
    private var wishColor = WishColor() {
        didSet {
            updateUI()
        }
    }
    
    init(dependenciesContainer: DependenciesContainer) {
        self.dependenciesContainer = dependenciesContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        randomizeColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Methods
    
    // MARK: Setup
    private func setupUI() {
        setupBackground()
        setupNavigationBar()
        setupLabels()
        setupPrimaryControls()
        setupColorControls()
    }
    
    private func setupBackground() {
        view.backgroundColor = .systemBackground
        view.layer.addSublayer(gradientLayer)
        
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.updateUI()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.Strings.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: wishColor.color.idealTextColor]
        
        let showControlsAction = UIAction { [weak self] _ in
            self?.toggleControls()
        }
        
        let image = UIImage(systemName: "eye.slash") ?? .actions
        let settingsBarButtonItem = UIBarButtonItem(
            image: image,
            primaryAction: showControlsAction
        )
        settingsBarButtonItem.setSymbolImage(image, contentTransition: .automatic)
        settingsBarButtonItem.tintColor = wishColor.color.idealTextColor
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
    
    private func setupPrimaryControls() {
        view.addSubview(primaryControlsStackView)
        [myWishesButton, scheduleButton].forEach { button in
            button.pinHeight(Constants.Layout.primaryButtonHeight)
        }
        
        primaryControlsStackView.pinEdges(
            [.leading, .trailing, .bottom],
            to: view,
            constant: Constants.Layout.padding
        )
    }
    
    private func setupColorControls() {
        // Controls Stack View
        view.addSubview(colorControlsView)
        colorControlsView.pinHorizontal(to: view, Constants.Layout.padding)
        colorControlsView.pinBottomToTop(of: primaryControlsStackView, constant: Constants.Layout.padding)
        
        // Blur View
        blurView.pinEdges(
            UIView.Edge.allCases,
            to: colorControlsView,
            constant: Constants.Layout.zero
        )
        
        // Color Controls Stack View
        colorControlsStackView.pinEdges(
            UIView.Edge.allCases,
            to: colorControlsView,
            constant: Constants.Layout.spacing
        )
        
        [randomizeButton, colorPickerButton].forEach { button in
            button.pinHeight(Constants.Layout.secondaryButtonHeight)
        }
    }
    
    // MARK: Update
    private func updateUI() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: wishColor.color.idealTextColor]
        descriptionLabel.textColor = wishColor.color.idealTextColor
        navigationItem.rightBarButtonItem?.tintColor = wishColor.color.idealTextColor
        
        let adjustedColor = wishColor.color.adjustedForContrast(with: view.backgroundColor ?? .systemBackground)
        updateSliders(with: adjustedColor)
        updateButtons(with: adjustedColor)
        updateGradient()
    }
    
    private func updateSliders(with color: UIColor) {
        redSlider.slider.setValue(Float(wishColor.red), animated: true)
        greenSlider.slider.setValue(Float(wishColor.green), animated: true)
        blueSlider.slider.setValue(Float(wishColor.blue), animated: true)
        
        [redSlider, greenSlider, blueSlider].forEach { slider in
            slider.tintColor = color
        }
    }
    
    private func updateButtons(with color: UIColor) {
        [randomizeButton, colorPickerButton, myWishesButton, scheduleButton].forEach { button in
            button.tintColor = color
        }
        
        [myWishesButton, scheduleButton].forEach { button in
            button.configuration?.baseForegroundColor = color.idealTextColor
        }
    }
    
    private func updateGradient() {
        gradientLayer.colors = [wishColor.color.cgColor, UIColor.systemBackground.cgColor]
        gradientLayer.locations = [Constants.Settings.gradientStart, Constants.Settings.gradientEnd]
    }
    
    // MARK: Actions
    private func randomizeColor() {
        let randomColor = UIColor.randomRGB()
        wishColor.red = randomColor.red
        wishColor.green = randomColor.green
        wishColor.blue = randomColor.blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateGradient()
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
        
        let image = UIImage(systemName: areControlsHidden ? "eye" : "eye.slash") ?? .actions
        navigationItem.rightBarButtonItem?.setSymbolImage(image, contentTransition: .automatic)
        
        if areControlsHidden {
            UIView.animate(withDuration: Constants.Settings.animationDuratione) {
                self.colorControlsView.alpha = self.areControlsHidden ? 0 : 1
            } completion: { _ in
                self.colorControlsView.isHidden = self.areControlsHidden
            }
        } else {
            colorControlsView.isHidden = false
            
            UIView.animate(withDuration: Constants.Settings.animationDuratione) {
                self.colorControlsView.alpha = self.areControlsHidden ? 0 : 1
            }
        }
    }
    
    // MARK: Navigation
    private func showMyWishes() {
        let wishStoringTableViewController = WishStoringTableViewController(
            dependenciesContainer: dependenciesContainer
        )
        
        let navigationController = UINavigationController(rootViewController: wishStoringTableViewController)
        present(navigationController, animated: true)
    }
    
    private func showCalendar() {
        let wishCalendarViewController = WishCalendarViewController(
            dependenciesContainer: dependenciesContainer,
            wishColor: wishColor
        )
        
        let navigationController = UINavigationController(rootViewController: wishCalendarViewController)
        present(navigationController, animated: true)
    }
}

extension WishMakerViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        let (red, green, blue, _) = color.components()
        wishColor.red = red
        wishColor.green = green
        wishColor.blue = blue
    }
}
