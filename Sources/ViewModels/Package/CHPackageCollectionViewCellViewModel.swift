import UIKit


final class CHPackageCollectionViewCellViewModel: Hashable {

	let packageName: String
	let packageDescription: String
	let packageIconURL: String?
	let packageAuthor: String
	let packageLatestVersion: String

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

	func fetchImage(completion: @escaping (Result<UIImage, Error>) -> ()) {
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