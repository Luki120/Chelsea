import SwiftUI
import UIKit


final class CHSettingsVC: UIViewController {

	private let viewModel = CHSettingsViewViewModel()
	private var swiftUIVC: UIHostingController<CHSettingsView>!
	var coordinator: SettingsCoordinator?

	// ! Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.delegate = self
		view.backgroundColor = .systemBackground
		setupUI()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		view.pinViewToAllEdges(swiftUIVC.view)
	}

	// ! Private

	func setupUI() {
		swiftUIVC = UIHostingController(rootView: CHSettingsView(viewModel: viewModel))
		addChild(swiftUIVC)
		swiftUIVC.didMove(toParent: self)

		view.addSubview(swiftUIVC.view)
		swiftUIVC.view.translatesAutoresizingMaskIntoConstraints = false
	}

}

// ! CHSettingsViewViewModelDelegate

extension CHSettingsVC: CHSettingsViewViewModelDelegate {

	func didTapDev(_ developer: CHSettingsDeveloper) {
		coordinator?.eventOccurred(with: .devCellTapped(developer: developer))
	}

	func didTapApp(_ app: CHSettingsApp) {
		coordinator?.eventOccurred(with: .appCellTapped(app: app))
	}

	func didTapSourceCodeButton() {
		coordinator?.eventOccurred(with: .sourceCodeButtonTapped)
	}

}
