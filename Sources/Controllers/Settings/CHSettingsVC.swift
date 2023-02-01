import SwiftUI
import UIKit


final class CHSettingsVC: UIViewController {

	var coordinator: SettingsCoordinator?
	private var swiftUIVC: UIHostingController<CHSettingsView>!
	private var viewModel: CHSettingsViewViewModel!

	private var lukiIcon = "https://avatars.githubusercontent.com/u/74214115?v=4"
	private var zemyoroIcon = "https://avatars.githubusercontent.com/u/85952603?v=4"

	// ! Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		setupUI()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		view.pinViewToAllEdges(swiftUIVC.view)
	}

	// ! Private

	func setupUI() {
		viewModel = CHSettingsViewViewModel(cellViewModels: [
			.init(developer: .luki, imageURLString: lukiIcon) { [weak self] developer in
				self?.didTapDev(developer)
			},
			.init(developer: .zemyoro, imageURLString: zemyoroIcon) { [weak self] developer in
				self?.didTapDev(developer)
			}
		])

		swiftUIVC = UIHostingController(rootView: CHSettingsView(viewModel: viewModel))
		addChild(swiftUIVC)
		swiftUIVC.didMove(toParent: self)

		view.addSubview(swiftUIVC.view)
		swiftUIVC.view.translatesAutoresizingMaskIntoConstraints = false
	}

	private func didTapDev(_ developer: CHSettingsDeveloper) {
		coordinator?.eventOccurred(with: .devCellTapped(developer: developer))
	}

}
