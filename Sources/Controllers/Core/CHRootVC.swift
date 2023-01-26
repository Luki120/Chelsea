import UIKit


final class CHRootVC: UIViewController {

	private let chPackagesView = CHPackagesView()

	// ! Lifecycle

	override func loadView() { view = chPackagesView }

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupSearchController()
		chPackagesView.delegate = self
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

// ! CHPackagesViewDelegate

extension CHRootVC: CHPackagesViewDelegate {

	func chPackagesView(_ chPackagesView: CHPackagesView, didSelectPackage package: Package) {
		let viewModel = CHPackagesDetailViewViewModel(package: package)
		let packagesDetailVC = CHPackagesDetailVC(viewModel: viewModel)
		navigationController?.pushViewController(packagesDetailVC, animated: true)
	}

}
