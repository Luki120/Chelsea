import Combine
import UIKit


protocol CHPackageListViewDelegate: AnyObject {
	func chPackageListView(_ chPackageListView: CHPackageListView, didSelectPackage package: Package)
}

final class CHPackageListView: UIView {

	private let packageListViewModel = CHPackageListViewViewModel()
	private let searchQueryViewModel = CHPackageSearchQueryViewModel()

	private var subscriptions = Set<AnyCancellable>()

	weak var delegate: CHPackageListViewDelegate?

	private lazy var packagesCollectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.alpha = 0
		collectionView.backgroundColor = .systemBackground
		collectionView.register(CHPackageCollectionViewCell.self, forCellWithReuseIdentifier: CHPackageCollectionViewCell.identifier)
		addSubview(collectionView)
		return collectionView
	}()

	private lazy var spinnerView: UIActivityIndicatorView = {
		let spinnerView = UIActivityIndicatorView(style: .large)
		spinnerView.hidesWhenStopped = true
		spinnerView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(spinnerView)
		return spinnerView
	}()

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		setupViewModels()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layoutUI()
	}

	// ! Private

	private func setupUI() {
		backgroundColor = .systemBackground
		setupCollectionView()
		spinnerView.startAnimating()
	}

	private func setupCollectionView() {
		packagesCollectionView.dataSource = packageListViewModel
		packagesCollectionView.delegate = packageListViewModel
	}

	private func layoutUI() {
		pinViewToAllEdges(packagesCollectionView)

		spinnerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		spinnerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		spinnerView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		spinnerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
	}

	private func setupViewModels() {
		packageListViewModel.delegate = self
		packageListViewModel.fetchPackages()
 
		searchQueryViewModel.$searchQuery
			.debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
			.sink { [weak self] in
				self?.packageListViewModel.wipeViewModels()
				self?.packageListViewModel.fetchPackages(fromQuery: $0)
			}
			.store(in: &subscriptions)
	}

}

extension CHPackageListView: CHPackageListViewViewModelDelegate {

	func didFetchPackages() {
		spinnerView.stopAnimating()
		packagesCollectionView.reloadData()

		UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve) {
			self.packagesCollectionView.alpha = 1
		}
	}

	func didSelectPackage(_ package: Package) {
		delegate?.chPackageListView(self, didSelectPackage: package)
	}

}

extension CHPackageListView: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		let textToSearch = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		searchQueryViewModel.searchQuery = textToSearch ?? ""
	}

}