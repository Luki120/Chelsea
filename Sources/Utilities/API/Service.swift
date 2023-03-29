import Foundation

/// Singleton service to make API calls
final class Service {

	static let sharedInstance = Service()
	private init() {}

	struct Constants {
		static let baseURL = "https://api.ios-repo-updates.com/1.0/search/?s="
	}

	/// Function that'll handle the API call
	/// - Parameters:
	///		- withURLString: the API url string
	///		- expecting: the given type that conforms to Codable from which we will decode the JSON data
	///		- completion: completion closure that gives us either data or an error
	func fetchPackages<T: Codable>(
		withURLString urlString: String,
		expecting type: T.Type,
		completion: @escaping (Result<T, Error>) -> ()
	) {
		guard let url = URL(string: urlString) else { return }

		let task = URLSession.shared.dataTask(with: url) { data, _, error in
			guard let data = data, error == nil else {
				completion(.failure(error ?? URLError(.badServerResponse)))
				return
			}

			do {
				let result = try JSONDecoder().decode(type.self, from: data)
				completion(.success(result))
			}
			catch { completion(.failure(error)) }
		}
		task.resume()
	}

}
