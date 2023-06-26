import UIKit


protocol PackageListViewDelegate: AnyObject {
	func packageListView(_ packageListView: PackageListView, didSelect package: Package)
}

/// Class to represent the package list view
final class PackageListView: UIView {

	private let packageListViewModel = PackageListViewViewModel()

	private let compositionalLayout: UICollectionViewCompositionalLayout = {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)

		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(95))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
		return UICollectionViewCompositionalLayout(section: section)
	}()

	private lazy var packagesCollectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
		collectionView.alpha = 0
		collectionView.refreshControl = refreshControl
		collectionView.backgroundColor = .systemGroupedBackground
		collectionView.showsVerticalScrollIndicator = false
		addSubview(collectionView)
		return collectionView
	}()

	private lazy var refreshControl = UIRefreshControl()
	private lazy var spinnerView = createSpinnerView(withStyle: .large, childOf: self)

	weak var delegate: PackageListViewDelegate?

	var collectionView: UICollectionView { return packagesCollectionView }

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		packagesCollectionView.delegate = packageListViewModel
		packageListViewModel.setupCollectionView(packagesCollectionView)
		setupUI()
		setupViewModel()

		refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layoutUI()
	}

	// ! Private

	private func setupUI() {
		backgroundColor = .systemGroupedBackground
		spinnerView.startAnimating()
	}

	private func layoutUI() {
		pinViewToAllEdges(packagesCollectionView, leadingConstant: 20, trailingConstant: -20)

		centerViewOnBothAxes(spinnerView)
		setupSizeConstraints(forView: spinnerView, width: 100, height: 100)
	}

	private func setupViewModel() {
		packageListViewModel.delegate = self
		packageListViewModel.fetchPackages()
		packageListViewModel.setupSearchQuerySubject()
	}

	// ! Selectors

	@objc private func didPullToRefresh() {
		packageListViewModel.isRefreshing = true
		packageListViewModel.fetchPackages(isPullToRefresh: true)
		packageListViewModel.isRefreshing = false
	}

}

// ! PackageListViewViewModelDelegate

extension PackageListView: PackageListViewViewModelDelegate {

	func didFetchPackages() {
		guard packageListViewModel.isFromQuery else {
			spinnerView.stopAnimating()
			packageListViewModel.applySnapshot()

			UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve) {
				self.packagesCollectionView.alpha = 1
			}
			return
		}
		packageListViewModel.applySnapshot()
	}

	func didSelect(package: Package) {
		delegate?.packageListView(self, didSelect: package)
	}

}

// ! UISearchResultsUpdating

extension PackageListView: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		let textToSearch = searchController.searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !textToSearch.isEmpty else { return }
		packageListViewModel.searchQuerySubject.send(textToSearch)
	}

}
