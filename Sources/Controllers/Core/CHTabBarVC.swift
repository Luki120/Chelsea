import UIKit


protocol CHTabBarVCDelegate: AnyObject {
	func didSelectTabBarItem()
}

final class CHTabBarVC: UITabBarController {

	private let floatingTabView = FloatingTabView(withItems: ["shippingbox", "gear"])

	weak var chDelegate: CHTabBarVCDelegate?

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nil, bundle: nil)

		let coreVC = CHRootVC()
		let settingsVC = CHSettingsVC()

		coreVC.title = "Chelsea"
		settingsVC.title = "Settings"

		let firstNav = UINavigationController(rootViewController: coreVC)
		let secondNav = UINavigationController(rootViewController: settingsVC)

		viewControllers = [firstNav, secondNav]
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

extension CHTabBarVC: FloatingTabViewDelegate {

	func didSelect(index: Int) {
		selectedIndex = index
		chDelegate?.didSelectTabBarItem()
	}

}
