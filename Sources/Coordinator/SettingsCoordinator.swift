import UIKit


final class SettingsCoordinator: Coordinator {

	enum Event {}

	var navigationController: UINavigationController

	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController

		let settingsVC = CHSettingsVC()
		settingsVC.coordinator = self
		settingsVC.title = "Settings"

		navigationController.viewControllers = [settingsVC]
	}

	func eventOccurred(with event: Event) {}

}
