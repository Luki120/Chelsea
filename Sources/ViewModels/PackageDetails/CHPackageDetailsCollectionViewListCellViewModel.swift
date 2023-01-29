import UIKit


struct CHPackageDetailsCollectionViewListCellViewModel: Hashable {

	private let mainText: String
	private let secondaryText: String?
	private let textColor: UIColor?

	var displayMainText: String { return mainText }
	var displaySecondaryText: String { return secondaryText ?? "" }
	var displayTextColor: UIColor { return textColor ?? .label }

	init(mainText: String, secondaryText: String? = nil, textColor: UIColor? = .label) {
		self.mainText = mainText
		self.secondaryText = secondaryText
		self.textColor = textColor
	}

}
