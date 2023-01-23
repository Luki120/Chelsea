import UIKit


final class CHRootVC: UIViewController {

	private let chPackagesView = CHPackagesView()

	// ! Lifecycle

	override func loadView() { view = chPackagesView }

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	// ! Private

	private func setupUI() {
		title = "Chelsea"
		view.backgroundColor = .systemBackground
	}

}
