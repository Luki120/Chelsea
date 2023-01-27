import UIKit


struct CHPackageDetailsContentConfiguration: UIContentConfiguration, Hashable {

	var mainText: String?
	var secondaryText: String?

	func makeContentView() -> UIView & UIContentView {
		return CHPackageDetailsContentView(configuration: self)
	}

	func updated(for state: UIConfigurationState) -> CHPackageDetailsContentConfiguration {
		return self
	}

}
