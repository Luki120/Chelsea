import UIKit


protocol CHTabBarVCDelegate: AnyObject {
	func didSelectTabBarItem()
}

/// Root view controller, which will show our tabs
final class CHTabBarVC: UITabBarController {

	private let floatingTabView = CHFloatingTabView(withItems: ["shippingbox", "gear"])
	private let homeCoordinator = HomeCoordinator()
	private let settingsCoordinator = SettingsCoordinator()

	weak var chDelegate: CHTabBarVCDelegate?

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nil, bundle: nil)
		viewControllers = [homeCoordinator.navigationController, settingsCoordinator.navigationController]
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tabBar.isHidden = true
		setupFloatingTabView()
	}

	// ! Private

	private func setupFloatingTabView() {
		floatingTabView.delegate = self
		floatingTabView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(floatingTabView)

		floatingTabView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		floatingTabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
	}

	// ! Public

	func shouldHideFloatingTabView(_ hide: Bool) {
		floatingTabView.shouldHide(hide)
	}

}

// ! FloatingTabViewDelegate

extension CHTabBarVC: CHFloatingTabViewDelegate {

	func didSelect(index: Int) {
		selectedIndex = index
		chDelegate?.didSelectTabBarItem()
	}

}
