import UIKit

/// Controller that'll show the package details view
final class CHPackageDetailsVC: UIViewController {

	let viewModel: CHPackageDetailsViewViewModel
	let chPackageDetailsView: CHPackageDetailsView

	var coordinator: HomeCoordinator?

	private lazy var priceLabel: UILabel = {
		let label = UILabel()
		label.text = viewModel.price
		label.textColor = viewModel.priceTextColor
		label.numberOfLines = 0
		return label
	}()

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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		shouldHideTabView(true)
	}

	// ! Private

	private func setupUI() {
		title = viewModel.title
		view.backgroundColor = .systemBackground
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: priceLabel)
	}

}

// ! CHPackageDetailsViewDelegate

extension CHPackageDetailsVC: CHPackageDetailsViewDelegate {

	func chPackageDetailsViewDidSelectAuthorCell() {
		coordinator?.eventOccurred(with: .authorCellTapped)
	}

	func chPackageDetailsViewDidSelectViewDepictionCell() {
		coordinator?.eventOccurred(with: .depictionCellTapped)
	} 

}
