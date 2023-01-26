import Foundation


struct CHPackagesDetailCollectionViewListCellViewModel: Hashable {

	private let mainText: String
	private let secondaryText: String?

	var displayMainText: String { return mainText }
	var displaySecondaryText: String { return secondaryText ?? "" }

	init(mainText: String, secondaryText: String? = nil) {
		self.mainText = mainText
		self.secondaryText = secondaryText
	}

}
