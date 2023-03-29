import UIKit

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

	private var mainLabel: UILabel!
	private var secondaryLabel: UILabel!

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	init(configuration: PackageDetailsContentConfiguration) {
		super.init(frame: .zero)

		setupUI()
		layoutUI()
		self.configuration = configuration
	}

	// ! Private

	private func setupUI() {
		mainLabel = createLabel(withFontSize: 17, textColor: .label)
		secondaryLabel = createLabel(withFontSize: 11, textColor: .secondaryLabel)

		labelsStackView.addArrangedSubviews(mainLabel, secondaryLabel)
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
