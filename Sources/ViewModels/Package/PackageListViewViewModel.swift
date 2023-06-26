import Combine
import UIKit


protocol PackageListViewViewModelDelegate: AnyObject {
	func didFetchPackages()
	func didSelect(package: Package)
}

/// View model class for PackageListView
final class PackageListViewViewModel: NSObject {

	private let searchQuerySubject = PassthroughSubject<String, Never>()

	private var cellViewModels = OrderedSet<PackageCollectionViewCellViewModel>()
	private var packages = [Package]() {
		didSet {
			cellViewModels += packages.compactMap { package in
				return PackageCollectionViewCellViewModel(
					packageIdentifier: package.identifier,
					packageName: package.name ?? package.identifier,
					packageDescription: package.description,
					packageIconURL: package.packageIcon ?? PackageIcon(package.section).section,
					packageAuthor: .cleanAuthor(package.author ?? "Unknown"),
					packageLatestVersion: package.latestVersion
				)
			}
		}
	}

	private var subscriptions = Set<AnyCancellable>()
	private(set) var isFromQuery = false

	weak var delegate: PackageListViewViewModelDelegate?
	var isRefreshing = false

	// ! UICollectionViewDiffableDataSource

	@frozen private enum Sections: Hashable {
		case main
	}

	private typealias CellRegistration = UICollectionView.CellRegistration<PackageCollectionViewCell, PackageCollectionViewCellViewModel>
	private typealias DataSource = UICollectionViewDiffableDataSource<Sections, PackageCollectionViewCellViewModel>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, PackageCollectionViewCellViewModel>

	private var dataSource: DataSource!
	private var snapshot: Snapshot!

	// ! Public

	/// Function to retrieve packages from the API call
	/// - Parameters:
	///		- fromQuery: An optional string to represent the given query,
	///		defaulting to nil if none was provided
	///		- isPullToRefresh: A bool to determine if the user pulled to refresh, defaulting to false
	func fetchPackages(fromQuery query: String? = nil, isPullToRefresh: Bool = false) {
		isFromQuery = query == nil || query == "" ? false : true

		let urlString = "\(Service.Constants.baseURL)\(query ?? "")"
			.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

		Service.sharedInstance.fetchPackages(withURLString: urlString, expecting: APIResponse.self) { result in
			switch result {
				case .success(let response):
					if isPullToRefresh { self.cellViewModels.removeAll() }
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
				self?.cellViewModels.removeAll()
				self?.fetchPackages(fromQuery: $0)
			}
			.store(in: &subscriptions)
	}

	/// Function to send the query subject
	/// - Parameters:
	///     - subject: A string representing the query subject
	func sendQuerySubject(_ subject: String) {
		searchQuerySubject.send(subject)
	}

}

// ! CollectionView

extension PackageListViewViewModel {

	/// Function to setup the collection view's data source
	/// - Parameters:
	///		- collectionView: The collection view
	func setupCollectionView(_ collectionView: UICollectionView) {
		let cellRegistration = CellRegistration { cell, _, viewModel in
			cell.configure(with: viewModel)
		}

		dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, identifier in
			let cell = collectionView.dequeueConfiguredReusableCell(
				using: cellRegistration,
				for: indexPath,
				item: identifier
			)
			return cell
		}

		applySnapshot()
	}

	/// Function to apply the snapshot to the diffable data source
	func applySnapshot() {
		snapshot = Snapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(Array(cellViewModels))
		dataSource.apply(snapshot)
	}

}

extension PackageListViewViewModel: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		delegate?.didSelect(package: packages[indexPath.item])
	}

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		guard let collectionView = scrollView as? UICollectionView else { return }

		if !isRefreshing && collectionView.refreshControl!.isRefreshing {
			collectionView.refreshControl!.endRefreshing()
		}
	}

}
