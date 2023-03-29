import UIKit

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
