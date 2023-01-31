import UIKit


final class CHRootVC: UIViewController {

	private let chPackageListView = CHPackageListView()

	var coordinator: HomeCoordinator?

	// ! Lifecycle

	override func loadView() { view = chPackageListView }

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		setupSearchController()
		chPackageListView.delegate = self

		let chTabBarController = tabBarController as? CHTabBarVC
		chTabBarController?.chDelegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		shouldHideTabView(false)
	}

	// ! Private

	private func setupSearchController() {
		let searchController = UISearchController()
		searchController.searchBar.returnKeyType = .default
		searchController.searchResultsUpdater = chPackageListView
		searchController.obscuresBackgroundDuringPresentation = false

		navigationItem.searchController = searchController
	}

}

// ! CHPackagesViewDelegate

extension CHRootVC: CHPackageListViewDelegate {

	func chPackageListViewDidSelect(package: Package) {
		coordinator?.eventOccurred(with: .packageCellTapped(package: package))
	}

}

// ! CHTabBarVCDelegate

extension CHRootVC: CHTabBarVCDelegate {

	func didSelectTabBarItem() {
 		let selector = NSSelectorFromString("_scrollToTopIfPossible:")
		guard chPackageListView.collectionView.responds(to: selector) else { return }
		chPackageListView.collectionView.performSelector(onMainThread: selector, with: true, waitUntilDone: true)
	}

}
