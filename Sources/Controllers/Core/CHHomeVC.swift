import UIKit

/// Controller that'll show the main packages list
final class CHHomeVC: UIViewController {

	private let chPackageListView = CHPackageListView()

	var coordinator: HomeCoordinator?

	// ! Lifecycle

	override func loadView() { view = chPackageListView }

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemGroupedBackground
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
		searchController.searchBar.placeholder = "Search for tweaks, themes, tools"
		searchController.searchBar.returnKeyType = .default
		searchController.searchResultsUpdater = chPackageListView
		searchController.obscuresBackgroundDuringPresentation = false

		navigationItem.searchController = searchController
	}

}

// ! CHPackagesViewDelegate

extension CHHomeVC: CHPackageListViewDelegate {

	func chPackageListViewDidSelect(package: Package) {
		coordinator?.eventOccurred(with: .packageCellTapped(package: package))
	}

}

// ! CHTabBarVCDelegate

extension CHHomeVC: CHTabBarVCDelegate {

	func didSelectTabBarItem() {
 		let selector = NSSelectorFromString("_scrollToTopIfPossible:")
		guard chPackageListView.collectionView.responds(to: selector) else { return }
		chPackageListView.collectionView.performSelector(onMainThread: selector, with: true, waitUntilDone: true)
	}

}
