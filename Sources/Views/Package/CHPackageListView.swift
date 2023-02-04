import Combine
import UIKit


protocol CHPackageListViewDelegate: AnyObject {
	func chPackageListViewDidSelect(package: Package)
}

/// Class to represent the package list view
final class CHPackageListView: UIView {

	private let packageListViewModel = CHPackageListViewViewModel()
	private let searchQueryViewModel = CHPackageSearchQueryViewModel()

	private var subscriptions = Set<AnyCancellable>()

	private lazy var packagesCollectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.alpha = 0
		collectionView.backgroundColor = .systemGroupedBackground
		collectionView.showsVerticalScrollIndicator = false
		collectionView.register(CHPackageCollectionViewCell.self, forCellWithReuseIdentifier: CHPackageCollectionViewCell.identifier)
		addSubview(collectionView)
		return collectionView
	}()

	private lazy var spinnerView = createSpinnerView(withStyle: .large, childOf: self)

	weak var delegate: CHPackageListViewDelegate?

	var collectionView: UICollectionView { return packagesCollectionView }

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCollectionView()
		setupUI()
		setupViewModels()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layoutUI()
	}

	// ! Private

	private func setupCollectionView() {
		packagesCollectionView.dataSource = packageListViewModel
		packagesCollectionView.delegate = packageListViewModel
	}

	private func setupUI() {
		backgroundColor = .systemGroupedBackground
		spinnerView.startAnimating()
	}

	private func layoutUI() {
		pinViewToAllEdges(packagesCollectionView, leadingConstant: 20, trailingConstant: -20)

		centerViewOnBothAxes(spinnerView)
		setupSizeConstraints(forView: spinnerView, width: 100, height: 100)
	}

	private func setupViewModels() {
		packageListViewModel.delegate = self
		packageListViewModel.fetchPackages()

		searchQueryViewModel.searchQuerySubject
			.debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
			.sink { [weak self] in
				self?.packageListViewModel.wipeViewModels()
				self?.packageListViewModel.fetchPackages(fromQuery: $0)
				self?.setupDataSourceTransition()
			}
			.store(in: &subscriptions)
	}

	private func setupDataSourceTransition() {
		let transition = CATransition()
		transition.type = .fade
		transition.duration = 0.6
		transition.timingFunction = .init(name: .easeInEaseOut)
		packagesCollectionView.layer.add(transition, forKey: nil)
	}

}

// ! CHPackageListViewViewModelDelegate

extension CHPackageListView: CHPackageListViewViewModelDelegate {

	func didFetchPackages() {
		guard packageListViewModel.isFromQuery else {
			spinnerView.stopAnimating()
			packagesCollectionView.reloadData()

			UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve) {
				self.packagesCollectionView.alpha = 1
			}
			return
		}
		packagesCollectionView.reloadData()
	}

	func didSelect(package: Package) {
		delegate?.chPackageListViewDidSelect(package: package)
	}

}

// ! UISearchResultsUpdating

extension CHPackageListView: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		let textToSearch = searchController.searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !textToSearch.isEmpty else { return }
		searchQueryViewModel.searchQuerySubject.send(textToSearch)
	}

}
