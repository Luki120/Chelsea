import Foundation


final class CHService {

	static let sharedInstance = CHService()
	private init() {}

	struct Constants {
		static let baseURL = "https://api.ios-repo-updates.com/1.0/search/?s="
	}

	func fetchPackages<T: Codable>(
		withURLString urlString: String,
		expecting type: T.Type,
		completion: @escaping (Result<T, Error>) -> ()
	) {
		guard let url = URL(string: urlString) else { return }

		let task = URLSession.shared.dataTask(with: url) { data, _, error in
			guard let data = data, error == nil else {
				completion(.failure(error!))
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
