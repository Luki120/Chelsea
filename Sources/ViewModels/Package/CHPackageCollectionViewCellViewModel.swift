import UIKit

/// View model class for CHPackageCollectionViewCell
final class CHPackageCollectionViewCellViewModel: Hashable {

	let packageName: String
	let packageDescription: String
	let packageIconURL: String?
	let packageAuthor: String
	let packageLatestVersion: String

	/// Designated initializer
	/// - Parameters:
	/// 	- packageName: A string to represent the package's name
	/// 	- packageDescription: A string to represent the package's description
	/// 	- packageIconURL: An optional string to represent the package's icon url
	/// 	- packageAuthor: A string to represent the package's author
	/// 	- packageLatestVersion: A string to represent the package's latest version
	init(
		packageName: String,
		packageDescription: String,
		packageIconURL: String?,
		packageAuthor: String,
		packageLatestVersion: String
	) {
		self.packageName = packageName
		self.packageDescription = packageDescription
		self.packageIconURL = packageIconURL
		self.packageAuthor = packageAuthor
		self.packageLatestVersion = packageLatestVersion
	}

	/// Function to retrieve the image either from the cache or the network
	/// - Parameters:
	///		- completion: completion closure that gives either a UIImage & a boolean to check
	///		if the image is coming from the cache or the network or an error
	func fetchImage(completion: @escaping (Result<(image: UIImage, isFromNetwork: Bool), Error>) -> ()) {
		guard let urlString = packageIconURL else {
			completion(.failure(URLError(.badURL)))
			return
		}
		CHImageManager.sharedInstance.fetchImage(urlString, completion: completion)
	}

 	// ! Hashable

	static func == (lhs: CHPackageCollectionViewCellViewModel, rhs: CHPackageCollectionViewCellViewModel) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(packageName)
		hasher.combine(packageDescription)
		hasher.combine(packageIconURL)
		hasher.combine(packageAuthor)
		hasher.combine(packageLatestVersion)
	}

}
