import UIKit

/// View model struct for CHPackageDetailsCollectionViewListCell
struct CHPackageDetailsCollectionViewListCellViewModel: Hashable {

	private let mainText: String
	private let secondaryText: String?
	private let textColor: UIColor?

	var displayMainText: String { return mainText }
	var displaySecondaryText: String { return secondaryText ?? "" }
	var displayTextColor: UIColor { return textColor ?? .label }

	/// Designated initializer
	/// - Parameters:
	/// 	- mainText: A string to represent the cell's main text
	/// 	- secondaryText: An optional string to represent the cell's secondary text,
	///		defaulting to nil if none was provided
	/// 	- textColor: An optional UIColor to represent the cell's main text color,
	///		defaulting to .label if none was specified
	init(mainText: String, secondaryText: String? = nil, textColor: UIColor? = .label) {
		self.mainText = mainText
		self.secondaryText = secondaryText
		self.textColor = textColor
	}

}
