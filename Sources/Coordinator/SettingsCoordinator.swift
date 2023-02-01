import UIKit


final class SettingsCoordinator: Coordinator {

	enum Event {
		case devCellTapped(developer: CHSettingsDeveloper)
	}

	var navigationController = UINavigationController()

	init() {
		let settingsVC = CHSettingsVC()
		settingsVC.coordinator = self
		settingsVC.title = "Settings"

		navigationController.viewControllers = [settingsVC]
	}

	func eventOccurred(with event: Event) {
		switch event {
			case .devCellTapped(let developer):
				guard let url = developer.targetURL else { return }
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}

}
