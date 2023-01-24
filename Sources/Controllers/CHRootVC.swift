import UIKit


final class CHRootVC: UIViewController {

	private let chPackagesView = CHPackagesView()

	// ! Lifecycle

	override func loadView() { view = chPackagesView }

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupSearchController()
	}

	// ! Private

	private func setupUI() {
		title = "Chelsea"
		view.backgroundColor = .systemBackground
	}

	private func setupSearchController() {
		let searchController = UISearchController()
		searchController.searchBar.returnKeyType = .default
		searchController.searchResultsUpdater = chPackagesView
		searchController.obscuresBackgroundDuringPresentation = false

		navigationItem.searchController = searchController
	}

}
