import UIKit


final class CHRootVC: UIViewController {

	private let chPackagesView = CHPackagesView()

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(nibName: String?, bundle: Bundle?) {
		super.init(nibName: nibName, bundle: bundle)
	}

	override func loadView() { view = chPackagesView }

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Chelsea"
		view.backgroundColor = .systemBackground
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layoutUI()
	}

	// ! Private

	private func layoutUI() {
		chPackagesView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		chPackagesView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		chPackagesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		chPackagesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}

}
