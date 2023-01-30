import UIKit


struct CHPackageDetailsHeaderCollectionReusableViewViewModel {

	private let imageURLString: String?

	init(imageURLString: String?) {
		self.imageURLString = imageURLString
	}

	func fetchHeaderImage(completion: @escaping (Result<(image: UIImage, isFromNetwork: Bool), Error>) -> ()) {
		guard let imageURLString = imageURLString else {
			completion(.failure(URLError(.badURL)))
			return
		}
		CHImageManager.sharedInstance.fetchImage(imageURLString, completion: completion)
	}

}
