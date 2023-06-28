import UIKit

/// View model struct for CHPackageDetailsCollectionViewListCell
struct PackageDetailsCollectionViewListCellViewModel: Hashable {

	let mainText: String
	let secondaryText: String?
	let textColor: UIColor?

	/// Designated initializer
	/// - Parameters:
	/// 	- mainText: A string to represent the cell's main text
	/// 	- secondaryText: A nullable string to represent the cell's secondary text,
	/// 	- textColor: An optional UIColor to represent the cell's main text color,
	///		defaulting to .label if none was specified
	init(mainText: String, secondaryText: String? = nil, textColor: UIColor? = .label) {
		self.mainText = mainText
		self.secondaryText = secondaryText
		self.textColor = textColor
	}

}
