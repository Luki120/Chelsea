import UIKit


final class CHRootVC: UIViewController {

	private let chPackageListView = CHPackageListView()

	// ! Lifecycle

	override func loadView() { view = chPackageListView }

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupSearchController()
		chPackageListView.delegate = self
	}

	// ! Private

	private func setupUI() {
		title = "Chelsea"
		view.backgroundColor = .systemBackground
	}

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

	func chPackageListView(_ chPackageListView: CHPackageListView, didSelectPackage package: Package) {
		let viewModel = CHPackageDetailsViewViewModel(package: package)
		let packageDetailsVC = CHPackageDetailsVC(viewModel: viewModel)
		navigationController?.pushViewController(packageDetailsVC, animated: true)
	}

}
