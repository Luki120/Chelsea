import UIKit

/// Class to represent the package details cell
final class PackageDetailsCollectionViewListCell: UICollectionViewListCell {

	var viewModel: PackageDetailsCollectionViewListCellViewModel?

	override func updateConfiguration(using state: UICellConfigurationState) {
		var newConfiguration = PackageDetailsContentConfiguration().updated(for: state)
		newConfiguration.mainText = viewModel?.mainText
		newConfiguration.secondaryText = viewModel?.secondaryText
		newConfiguration.textColor = viewModel?.textColor

		contentConfiguration = newConfiguration
	}

}

/// Struct to represent the content configuration for the package details cell
struct PackageDetailsContentConfiguration: UIContentConfiguration, Hashable {

	var mainText: String?
	var secondaryText: String?
	var textColor: UIColor?

	func makeContentView() -> UIView & UIContentView {
		return PackageDetailsContentView(configuration: self)
	}

	func updated(for state: UIConfigurationState) -> PackageDetailsContentConfiguration {
		return self
	}

}

/// Class to represent the content view for the package details cell
final class PackageDetailsContentView: UIView, UIContentView {

	private var currentConfiguration: PackageDetailsContentConfiguration!

	var configuration: UIContentConfiguration {
		get { currentConfiguration }
		set {
			guard let newConfiguration = newValue as? PackageDetailsContentConfiguration else { return }
			apply(configuration: newConfiguration)
		}
	}

	private lazy var labelsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 0.5
		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)
		return stackView
	}()

	private var mainLabel, secondaryLabel: UILabel!

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	init(configuration: PackageDetailsContentConfiguration) {
		super.init(frame: .zero)

		setupUI()
		self.configuration = configuration
	}

	// ! Private

	private func setupUI() {
		mainLabel = createLabel(withFontSize: 17, textColor: .label)
		secondaryLabel = createLabel(withFontSize: 11, textColor: .secondaryLabel)

		labelsStackView.addArrangedSubviews(mainLabel, secondaryLabel)
		layoutUI()
	}

	private func layoutUI() {
		NSLayoutConstraint.activate([
			labelsStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 3.5),
			labelsStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -3.5),
			labelsStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 10),
			labelsStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -10)
		])
	}

	private func apply(configuration: PackageDetailsContentConfiguration) {
		guard currentConfiguration != configuration else { return }

		currentConfiguration = configuration

		mainLabel.text = configuration.mainText
		mainLabel.textColor = configuration.textColor
		secondaryLabel.text = configuration.secondaryText
	}

	// ! Reusable

	private func createLabel(withFontSize size: CGFloat, textColor: UIColor) -> UILabel {
		let label = UILabel()
		label.font = .systemFont(ofSize: size)
		label.textColor = textColor
		label.numberOfLines = 0
		return label
	}

}
