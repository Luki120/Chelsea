import Combine
import UIKit


protocol PackageListViewViewModelDelegate: AnyObject {
	func didFetchPackages()
	func didSelect(package: Package)
}

/// View model class for PackageListView
final class PackageListViewViewModel: NSObject {

	let searchQuerySubject = PassthroughSubject<String, Never>()

	private var subscriptions = Set<AnyCancellable>()

	private var cellViewModels = [PackageCollectionViewCellViewModel]()
	private var packages = [Package]() {
		didSet {
			for package in packages {
				let viewModel = PackageCollectionViewCellViewModel(
					packageName: package.name ?? package.identifier,
					packageDescription: package.description,
					packageIconURL: package.packageIcon ?? PackageIcon(package.section).section,
					packageAuthor: .cleanAuthor(package.author ?? "Unknown") ?? "Unknown",
					packageLatestVersion: package.latestVersion
				)
				if !cellViewModels.contains(viewModel) {
					cellViewModels.append(viewModel)
				}
			}
		}
	}

	private(set) var isFromQuery = false

	weak var delegate: PackageListViewViewModelDelegate?

	// ! UICollectionViewDiffableDataSource

	@frozen private enum Sections: Hashable {
		case main
	}

	private typealias CellRegistration = UICollectionView.CellRegistration<PackageCollectionViewCell, PackageCollectionViewCellViewModel>
	private typealias DataSource = UICollectionViewDiffableDataSource<Sections, PackageCollectionViewCellViewModel>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, PackageCollectionViewCellViewModel>

	private var dataSource: DataSource!
	private var snapshot: Snapshot!

	private func wipeViewModels() { cellViewModels.removeAll() }

	// ! Public

	/// Function to retrieve packages from the API call
	/// - Parameters:
	///		- fromQuery: an optional string to represent the given query,
	///		defaulting to nil if none was provided
	func fetchPackages(fromQuery query: String? = nil) {
		isFromQuery = query == nil || query == "" ? false : true

		Service.sharedInstance.fetchPackages(
			withURLString: "\(Service.Constants.baseURL)\(query ?? "")",
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

	/// Function to setup the search query's passthrough subject to debounce API calls
	func setupSearchQuerySubject() {
		searchQuerySubject
			.debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
			.sink { [weak self] in
				self?.wipeViewModels()
				self?.fetchPackages(fromQuery: $0)
			}
			.store(in: &subscriptions)
	}

}

// ! CollectionView

extension PackageListViewViewModel {

	/// Function to setup the collection view's data source
	/// - Parameters:
	///		- collectionView: the collection view
	func setupCollectionView(_ collectionView: UICollectionView) {
		let cellRegistration = CellRegistration { cell, _, viewModel in
			cell.configure(with: viewModel)
		}

		dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, identifier -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(
				using: cellRegistration,
				for: indexPath,
				item: identifier
			)
			return cell
		}

		applySnapshot()
	}

	func applySnapshot() {
		snapshot = Snapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(cellViewModels)

		dataSource.apply(snapshot, animatingDifferences: true)
	}

}

extension PackageListViewViewModel: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		delegate?.didSelect(package: packages[indexPath.item])
	}

}
