import UIKit


final class CHPackagesDetailCollectionViewListCell: UICollectionViewListCell {

	var viewModel: CHPackagesDetailCollectionViewListCellViewModel?

	override func updateConfiguration(using state: UICellConfigurationState) {
		var newConfiguration = CHPackagesDetailContentConfiguration().updated(for: state)
		newConfiguration.mainText = viewModel?.displayMainText
		newConfiguration.secondaryText = viewModel?.displaySecondaryText

		contentConfiguration = newConfiguration
	}

}
