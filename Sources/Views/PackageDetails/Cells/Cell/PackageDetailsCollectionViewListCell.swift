import UIKit

/// Class to represent the package details cell
final class PackageDetailsCollectionViewListCell: UICollectionViewListCell {

	var viewModel: PackageDetailsCollectionViewListCellViewModel?

	override func updateConfiguration(using state: UICellConfigurationState) {
		var newConfiguration = PackageDetailsContentConfiguration().updated(for: state)
		newConfiguration.mainText = viewModel?.displayMainText
		newConfiguration.secondaryText = viewModel?.displaySecondaryText
		newConfiguration.textColor = viewModel?.displayTextColor

		contentConfiguration = newConfiguration
	}

}
