import UIKit


final class CHPackageDetailsVC: UIViewController {

	let viewModel: CHPackageDetailsViewViewModel
	let chPackageDetailsView: CHPackageDetailsView

	// ! Lifecycle

	required init?(coder: NSCoder) {
		fatalError("L")
	}

	init(viewModel: CHPackageDetailsViewViewModel) {
		self.viewModel = viewModel
		self.chPackageDetailsView = CHPackageDetailsView(viewModel: viewModel)
		super.init(nibName: nil, bundle: nil)
	}

 	override func loadView() { view = chPackageDetailsView }

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
