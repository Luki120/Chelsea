import UIKit


final class CHGitHubCellViewModel: Identifiable, ObservableObject {

	private(set) var id = UUID()
	@Published private(set) var image = UIImage()

	let developer: CHSettingsDeveloper
	let onTap: (CHSettingsDeveloper) -> ()
	private let imageURLString: String?

	var devName: String { return developer.devName }
	var targetURL: URL? { return developer.targetURL }

	init(developer: CHSettingsDeveloper, imageURLString: String?, onTap: @escaping (CHSettingsDeveloper) -> ()) {
		self.developer = developer
		self.imageURLString = imageURLString
		self.onTap = onTap
		fetchImage()
	}

	private func fetchImage() {
 		guard let imageURLString = imageURLString else { return }
 			CHImageManager.sharedInstance.fetchImage(imageURLString) { result in
			switch result {
				case .success((let image, _)):
					DispatchQueue.main.async {
						self.image = image
					}

				case .failure: break
			}
		}
	}

}
