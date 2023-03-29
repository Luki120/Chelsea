import UIKit

/// View model class for SettingsGitHubCellView
final class SettingsGitHubCellViewViewModel: Identifiable, ObservableObject {

	private(set) var id = UUID()
	@Published private(set) var image = UIImage()

	let developer: SettingsDeveloper
	let onTap: (SettingsDeveloper) -> ()
	private let imageURLString: String?

	var devName: String { return developer.devName }
	var targetURL: URL? { return developer.targetURL }

	/// Designated initializer
	/// - Parameters:
	/// 	- developer: A SettingsDeveloper object to represent the developer
	/// 	- imageURLString: An optional string to represent the image's url string
	/// 	- onTap: An escaping closure that takes a SettingsDeveloper object as argument & returns void
	init(developer: SettingsDeveloper, imageURLString: String?, onTap: @escaping (SettingsDeveloper) -> ()) {
		self.developer = developer
		self.imageURLString = imageURLString
		self.onTap = onTap
		fetchImage()
	}

	private func fetchImage() {
 		guard let imageURLString = imageURLString else { return }
 			ImageManager.sharedInstance.fetchImage(imageURLString) { [weak self] result in
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
