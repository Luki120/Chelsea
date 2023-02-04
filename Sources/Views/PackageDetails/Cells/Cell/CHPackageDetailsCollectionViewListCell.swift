import UIKit

/// Class to represent the package details cell
final class CHPackageDetailsCollectionViewListCell: UICollectionViewListCell {

	var viewModel: CHPackageDetailsCollectionViewListCellViewModel?

	override func updateConfiguration(using state: UICellConfigurationState) {
		var newConfiguration = CHPackageDetailsContentConfiguration().updated(for: state)
		newConfiguration.mainText = viewModel?.displayMainText
		newConfiguration.secondaryText = viewModel?.displaySecondaryText
		newConfiguration.textColor = viewModel?.displayTextColor

		contentConfiguration = newConfiguration
	}

}
