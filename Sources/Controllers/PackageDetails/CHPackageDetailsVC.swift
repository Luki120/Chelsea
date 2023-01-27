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
		chPackageDetailsView.delegate = self
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

// ! CHPackageDetailsViewDelegate

extension CHPackageDetailsVC: CHPackageDetailsViewDelegate {

	func chPackageDetailsViewDidSelectAuthorCell() {
		guard let url = URL(string: "mailto:\(viewModel.authorEmail!)") else { return }
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}

}
