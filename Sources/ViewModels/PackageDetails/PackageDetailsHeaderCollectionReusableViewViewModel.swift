import UIKit

/// View model struct for PackageDetailsHeaderCollectionReusableView
struct PackageDetailsHeaderCollectionReusableViewViewModel {

	private let imageURLString: String?

	/// Designated initializer
	/// - Parameters:
	/// 	- imageURLString: An optional string to represent the image's url string
	init(imageURLString: String?) {
		self.imageURLString = imageURLString
	}

	/// Function to retrieve the header image either from the cache or the network
	/// - Parameters:
	///		- completion: completion closure that gives either a UIImage & a boolean to check
	///		if the image is coming from the cache or the network or an error
	func fetchHeaderImage(completion: @escaping (Result<(image: UIImage, isFromNetwork: Bool), Error>) -> ()) {
		guard let imageURLString = imageURLString else {
			completion(.failure(URLError(.badURL)))
			return
		}
		ImageManager.sharedInstance.fetchImage(imageURLString, completion: completion)
	}

}
