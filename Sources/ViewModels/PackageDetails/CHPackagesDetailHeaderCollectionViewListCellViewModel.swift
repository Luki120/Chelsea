import UIKit


struct CHPackagesDetailHeaderCollectionReusableViewViewModel {

	private let imageURLString: String?

	init(imageURLString: String?) {
		self.imageURLString = imageURLString
	}

	func fetchHeaderImage(completion: @escaping (Result<UIImage, Error>) -> ()) {
		guard let imageURLString = imageURLString else {
			completion(.failure(URLError(.badURL)))
			return
		}
		CHImageManager.sharedInstance.fetchImage(imageURLString, completion: completion)
	}

}
