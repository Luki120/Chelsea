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
