import UIKit


final class CHImageManager {

	static let sharedInstance = CHImageManager()
	private init() {}

	private let imageCache = NSCache<NSString, UIImage>()

	enum ImageState {
		case loading
		case loaded
	}

	private(set) var imageState: ImageState = .loading

	func fetchImage(_ urlString: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
		imageState = .loading
		if let cachedImage = imageCache.object(forKey: urlString as NSString) {
			completion(.success(cachedImage))
			imageState = .loading
			return
		}

		guard let url = URL(string: urlString) else {
			completion(.failure(URLError(.badURL)))
			return
		}

		let task = URLSession.shared.dataTask(with: url) { data, _, error in
			guard let data = data, let image = UIImage(data: data), error == nil else {
				completion(.failure(error ?? URLError(.badServerResponse)))
				return
			}
			self.imageCache.setObject(image, forKey: urlString as NSString)
			completion(.success(image))
			self.imageState = .loaded
		}
		task.resume()
	}

}
