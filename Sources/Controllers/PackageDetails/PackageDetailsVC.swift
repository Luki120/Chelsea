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
		self.packageDetailsView = .init(viewModel: viewModel)
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
		navigationItem.rightBarButtonItem = .init(customView: priceLabel)
	}

}

// ! PackageDetailsViewDelegate

extension PackageDetailsVC: PackageDetailsViewDelegate {

	func didSelectAuthorCell(in packageDetailsView: PackageDetailsView) {
		coordinator?.eventOccurred(with: .authorCellTapped)
	}

	func didSelectViewDepictionCell(in packageDetailsView: PackageDetailsView) {
		coordinator?.eventOccurred(with: .depictionCellTapped)
	} 

}
