import SafariServices
import UIKit

/// Home coordinator, which will take care of any navigation events related to HomeVC
final class HomeCoordinator: Coordinator {

	enum Event {
		case packageCellTapped(package: Package)
		case authorCellTapped
		case depictionCellTapped
	}

	var navigationController = UINavigationController()

	private var packageDetailsVC: PackageDetailsVC!

	init() {
		let homeVC = HomeVC()
		homeVC.coordinator = self
		homeVC.title = "Chelsea"

		navigationController.viewControllers = [homeVC]
	}

	func eventOccurred(with event: Event) {
		switch event {
			case .packageCellTapped(let package):
				let viewModel = PackageDetailsViewViewModel(package: package)
				packageDetailsVC = PackageDetailsVC(viewModel: viewModel)
				packageDetailsVC.coordinator = self
				navigationController.pushViewController(packageDetailsVC, animated: true)

			case .authorCellTapped:
				guard let url = URL(string: "mailto:\(packageDetailsVC.viewModel.authorEmail!)") else { return }
				UIApplication.shared.open(url, options: [:], completionHandler: nil)

			case .depictionCellTapped:
				guard let url = URL(string: packageDetailsVC.viewModel.depictionURL) else { return }
				let safariVC = SFSafariViewController(url: url)
				safariVC.modalPresentationStyle = .pageSheet
				navigationController.present(safariVC, animated: true)
		}
	}

}
