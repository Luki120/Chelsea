import UIKit

/// Controller that'll show the main packages list
final class HomeVC: UIViewController {

	private let packageListView = PackageListView()

	var coordinator: HomeCoordinator?

	// ! Lifecycle

	override func loadView() { view = packageListView }

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemGroupedBackground
		setupSearchController()
		packageListView.delegate = self

		let tabBarController = tabBarController as? TabBarVC
		tabBarController?.chDelegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		shouldHideTabView(false)
	}

	// ! Private

	private func setupSearchController() {
		let searchController = UISearchController()
		searchController.searchBar.placeholder = "Search for tweaks, themes, tools"
		searchController.searchBar.returnKeyType = .default
		searchController.searchResultsUpdater = packageListView
		searchController.obscuresBackgroundDuringPresentation = false

		navigationItem.searchController = searchController
	}

}

// ! CHPackagesViewDelegate

extension HomeVC: PackageListViewDelegate {

	func packageListViewDidSelect(package: Package) {
		coordinator?.eventOccurred(with: .packageCellTapped(package: package))
	}

}

// ! TabBarVCDelegate

extension HomeVC: TabBarVCDelegate {

	func didSelectTabBarItem() {
 		let selector = NSSelectorFromString("_scrollToTopIfPossible:")
		guard packageListView.collectionView.responds(to: selector) else { return }
		packageListView.collectionView.performSelector(onMainThread: selector, with: true, waitUntilDone: true)
	}

}
