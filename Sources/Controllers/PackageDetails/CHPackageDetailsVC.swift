import SafariServices
import UIKit


final class CHPackageDetailsVC: UIViewController {

	let viewModel: CHPackageDetailsViewViewModel
	let chPackageDetailsView: CHPackageDetailsView

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
		guard let url = URL(string: "mailto:\(viewModel.authorEmail!)") else { return }
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}

	func chPackageDetailsViewDidSelectViewDepictionCell() {
		guard let url = URL(string: viewModel.depictionURL) else { return }
		let safariVC = SFSafariViewController(url: url)
		safariVC.modalPresentationStyle = .pageSheet
		present(safariVC, animated: true)
	} 
}
