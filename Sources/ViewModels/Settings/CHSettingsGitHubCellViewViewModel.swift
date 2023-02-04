import UIKit

/// View model class for CHSettingsGitHubCellView
final class CHSettingsGitHubCellViewViewModel: Identifiable, ObservableObject {

	private(set) var id = UUID()
	@Published private(set) var image = UIImage()

	let developer: CHSettingsDeveloper
	let onTap: (CHSettingsDeveloper) -> ()
	private let imageURLString: String?

	var devName: String { return developer.devName }
	var targetURL: URL? { return developer.targetURL }

	/// Designated initializer
	/// - Parameters:
	/// 	- developer: A CHSettingsDeveloper object to represent the developer
	/// 	- imageURLString: An optional string to represent the image's url string
	/// 	- onTap: An escaping closure that takes a CHSettingsDeveloper object as argument & returns void
	init(developer: CHSettingsDeveloper, imageURLString: String?, onTap: @escaping (CHSettingsDeveloper) -> ()) {
		self.developer = developer
		self.imageURLString = imageURLString
		self.onTap = onTap
		fetchImage()
	}

	private func fetchImage() {
 		guard let imageURLString = imageURLString else { return }
 			CHImageManager.sharedInstance.fetchImage(imageURLString) { [weak self] result in
			switch result {
				case .success((let image, _)):
					DispatchQueue.main.async {
						self?.image = image
					}

				case .failure: break
			}
		}
	}

}
