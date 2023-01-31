import UIKit


final class SettingsCoordinator: Coordinator {

	enum Event {}

	var navigationController = UINavigationController()

	init() {
		let settingsVC = CHSettingsVC()
		settingsVC.coordinator = self
		settingsVC.title = "Settings"

		navigationController.viewControllers = [settingsVC]
	}

	func eventOccurred(with event: Event) {}

}
