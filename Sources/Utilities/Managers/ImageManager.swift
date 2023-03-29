import UIKit

/// Singleton manager to handle the image fetching logic
final class ImageManager {

	static let sharedInstance = ImageManager()
	private init() {}

	private let imageCache = NSCache<NSString, UIImage>()

	/// Function that'll handle the image fetching data task
	/// - Parameters:
	///		- urlString: the image's url string
	///		- completion: completion closure that gives either a UIImage & a boolean to check
	///		if the image is coming from the cache or the network or an error
	func fetchImage(_ urlString: String, completion: @escaping (Result<(image: UIImage, isFromNetwork: Bool), Error>) -> ()) {
		if let cachedImage = imageCache.object(forKey: urlString as NSString) {
			completion(.success((cachedImage, false)))
			return
		}

		guard let url = URL(string: isValidURL(urlString)) else {
			completion(.failure(URLError(.badURL)))
			return
		}

		let task = URLSession.shared.dataTask(with: url) { data, _, error in
			guard let data = data, let image = UIImage(data: data), error == nil else {
				completion(.failure(error ?? URLError(.badServerResponse)))
				return
			}
			self.imageCache.setObject(image, forKey: urlString as NSString)
			completion(.success((image, true)))
		}
		task.resume()
	}

	private func isValidURL(_ urlString: String) -> String {
		guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
			return "https://repo.packix.com/icons/tweak.png"
		}
		return urlString
	}

}
