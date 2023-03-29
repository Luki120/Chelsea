import SwiftUI
import UIKit

/// Controller that'll show the settings view
final class SettingsVC: UIViewController {

	private let viewModel = SettingsViewViewModel()
	private var swiftUIVC: UIHostingController<SettingsView>!
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

	private func setupUI() {
		swiftUIVC = UIHostingController(rootView: SettingsView(viewModel: viewModel))
		addChild(swiftUIVC)
		swiftUIVC.didMove(toParent: self)

		view.addSubview(swiftUIVC.view)
		swiftUIVC.view.translatesAutoresizingMaskIntoConstraints = false
	}

}

// ! SettingsViewViewModelDelegate

extension SettingsVC: SettingsViewViewModelDelegate {

	func didTapDev(_ developer: SettingsDeveloper) {
		coordinator?.eventOccurred(with: .devCellTapped(developer: developer))
	}

	func didTapApp(_ app: SettingsApp) {
		coordinator?.eventOccurred(with: .appCellTapped(app: app))
	}

	func didTapSourceCodeButton() {
		coordinator?.eventOccurred(with: .sourceCodeButtonTapped)
	}

}
