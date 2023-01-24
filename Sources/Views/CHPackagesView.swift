import Combine
import UIKit


final class CHPackagesView: UIView {

	private let packagesViewModel = CHPackagesViewViewModel()
	private let searchQueryViewModel = CHPackagesSearchQueryViewModel()

	private var subscriptions = Set<AnyCancellable>()

	private lazy var packagesCollectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.alpha = 0
		collectionView.backgroundColor = .systemBackground
		collectionView.register(CHPackagesCollectionViewCell.self, forCellWithReuseIdentifier: CHPackagesCollectionViewCell.identifier)
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
		packagesCollectionView.dataSource = packagesViewModel
		packagesCollectionView.delegate = packagesViewModel
	}

	private func layoutUI() {
		pinViewToAllEdges(packagesCollectionView)

		spinnerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		spinnerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		spinnerView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		spinnerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
	}

	private func setupViewModels() {
		packagesViewModel.delegate = self
		packagesViewModel.fetchPackages()
 
		searchQueryViewModel.$searchQuery
			.debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
			.sink { [weak self] in
				self?.packagesViewModel.wipeViewModels()
				self?.packagesViewModel.fetchPackages(fromQuery: $0)
			}
			.store(in: &subscriptions)
	}

}

extension CHPackagesView: CHPackagesViewViewModelDelegate {

	func didFetchPackages() {
		spinnerView.stopAnimating()
		packagesCollectionView.reloadData()

		UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve) {
			self.packagesCollectionView.alpha = 1
		}
	}

}

extension CHPackagesView: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		searchQueryViewModel.searchQuery = searchController.searchBar.text ?? ""
	}

}
