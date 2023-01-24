import UIKit


protocol CHPackagesViewViewModelDelegate: AnyObject {
	func didFetchPackages()
}

final class CHPackagesViewViewModel: NSObject {

	private var cellViewModels = [CHPackagesCollectionViewCellViewModel]()
	private var packages = [Package]() {
		didSet {
			for package in packages {
				let viewModel = CHPackagesCollectionViewCellViewModel(
					packageName: package.name ?? "Unknown",
					packageDescription: package.description,
					packageIconURL: package.packageIcon ?? "https://repo.packix.com/icons/tweak.png",
					packageAuthor: package.author ?? "Unknown",
					packageLatestVersion: package.latestVersion
				)
				if !cellViewModels.contains(viewModel) {
					cellViewModels.append(viewModel)
				}
			}
		}
	}

	weak var delegate: CHPackagesViewViewModelDelegate?

	// ! Public

	func fetchPackages(fromQuery query: String? = nil) {
		CHService.sharedInstance.fetchPackages(
			withURLString: "\(CHService.Constants.baseURL)\(query ?? "")",
			expecting: APIResponse.self
		) { result in
			switch result {
				case .success(let response):
					self.packages = response.packages
					DispatchQueue.main.async {
						self.delegate?.didFetchPackages()
					}
				case .failure: break
			}
		}
	}

	func wipeViewModels() { cellViewModels.removeAll() }

}

extension CHPackagesViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cellViewModels.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: CHPackagesCollectionViewCell.identifier,
			for: indexPath
		) as? CHPackagesCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.configure(with: cellViewModels[indexPath.row])
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.size.width - 30, height: 85)
	}

}
