import UIKit


protocol CHPackageListViewViewModelDelegate: AnyObject {
	func didFetchPackages()
	func didSelectPackage(_ package: Package)
}

final class CHPackageListViewViewModel: NSObject {

	private var cellViewModels = [CHPackageCollectionViewCellViewModel]()
	private var packages = [Package]() {
		didSet {
			for package in packages {
				let viewModel = CHPackageCollectionViewCellViewModel(
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

	weak var delegate: CHPackageListViewViewModelDelegate?

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

// ! CollectionView

extension CHPackageListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cellViewModels.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: CHPackageCollectionViewCell.identifier,
			for: indexPath
		) as? CHPackageCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.configure(with: cellViewModels[indexPath.row])
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.size.width - 30, height: 85)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)		
		let package = packages[indexPath.row]
		delegate?.didSelectPackage(package)
	}

}