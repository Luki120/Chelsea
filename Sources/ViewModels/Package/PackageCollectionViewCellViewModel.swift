import UIKit

/// View model struct for PackageCollectionViewCell
struct PackageCollectionViewCellViewModel: Hashable {

	let packageIdentifier: String
	let packageName: String
	let packageDescription: String
	let packageIconURL: String?
	let packageAuthor: String
	let packageLatestVersion: String

	/// Function to retrieve the image either from the cache or the network
	/// - Parameters:
	///		- completion: Completion closure that takes a Result as argument which gives either a tuple of type
	///		UIImage & a boolean to check if the image is coming from the cache or the network or an error
	func fetchImage(completion: @escaping (Result<(image: UIImage, isFromNetwork: Bool), Error>) -> ()) {
		guard let urlString = packageIconURL else {
			completion(.failure(URLError(.badURL)))
			return
		}
		ImageManager.sharedInstance.fetchImage(urlString, completion: completion)
	}

}
