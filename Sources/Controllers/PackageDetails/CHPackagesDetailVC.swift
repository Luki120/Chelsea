import UIKit


final class CHPackagesDetailVC: UIViewController {

	let viewModel: CHPackagesDetailViewViewModel
	let chPackagesDetailView: CHPackagesDetailView

	// ! Lifecycle

	required init?(coder: NSCoder) {
		fatalError("L")
	}

	init(viewModel: CHPackagesDetailViewViewModel) {
		self.viewModel = viewModel
		self.chPackagesDetailView = CHPackagesDetailView(viewModel: viewModel)
		super.init(nibName: nil, bundle: nil)
	}

 	override func loadView() { view = chPackagesDetailView }

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	// ! Private

	private func setupUI() {
		title = viewModel.title
		view.backgroundColor = .systemBackground
	}

}
