import UIKit


struct CHPackagesDetailContentConfiguration: UIContentConfiguration, Hashable {

	var mainText: String?
	var secondaryText: String?

	func makeContentView() -> UIView & UIContentView {
		return CHPackagesDetailContentView(configuration: self)
	}

	func updated(for state: UIConfigurationState) -> CHPackagesDetailContentConfiguration {
		return self
	}

}
