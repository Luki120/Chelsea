import UIKit

/// Controller that'll show the package details view
final class PackageDetailsVC: UIViewController {

	let viewModel: PackageDetailsViewViewModel
	let packageDetailsView: PackageDetailsView

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

	init(viewModel: PackageDetailsViewViewModel) {
		self.viewModel = viewModel
		self.packageDetailsView = PackageDetailsView(viewModel: viewModel)
		super.init(nibName: nil, bundle: nil)
		packageDetailsView.delegate = self
	}

	override func loadView() { view = packageDetailsView }

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

// ! PackageDetailsViewDelegate

extension PackageDetailsVC: PackageDetailsViewDelegate {

	func packageDetailsViewDidSelectAuthorCell() {
		coordinator?.eventOccurred(with: .authorCellTapped)
	}

	func packageDetailsViewDidSelectViewDepictionCell() {
		coordinator?.eventOccurred(with: .depictionCellTapped)
	} 

}
