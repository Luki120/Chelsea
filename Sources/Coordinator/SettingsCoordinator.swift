import SafariServices
import UIKit

/// Settings coordinator, which will take care of any navigation events related to SettingsVC
final class SettingsCoordinator: Coordinator {

	enum Event {
		case devCellTapped(developer: SettingsDeveloper)
		case appCellTapped(app: SettingsApp)
		case sourceCodeButtonTapped
	}

	var navigationController = UINavigationController()

	init() {
		let settingsVC = SettingsVC()
		settingsVC.coordinator = self
		settingsVC.title = "Settings"

		navigationController.viewControllers = [settingsVC]
	}

	func eventOccurred(with event: Event) {
		switch event {
			case .devCellTapped(let developer):
				guard let url = developer.targetURL else { return }
				UIApplication.shared.open(url, options: [:], completionHandler: nil)

			case .appCellTapped(let app):
				presentSafariVC(withURL: app.appURL)

			case .sourceCodeButtonTapped:
				presentSafariVC(withURL: URL(string: "https://github.com/Luki120/Chelsea"))
		}
	}

	private func presentSafariVC(withURL url: URL?) {
		guard let url = url else { return }
		let safariVC = SFSafariViewController(url: url)
		safariVC.modalPresentationStyle = .pageSheet
		navigationController.present(safariVC, animated: true)
	}

}
