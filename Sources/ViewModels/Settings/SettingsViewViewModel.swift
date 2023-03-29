import Foundation


protocol SettingsViewViewModelDelegate: AnyObject {
	func didTapDev(_ developer: SettingsDeveloper)
	func didTapApp(_ app: SettingsApp)
	func didTapSourceCodeButton()
}

/// View model class for SettingsView
final class SettingsViewViewModel {

	private var lukiIcon = "https://avatars.githubusercontent.com/u/74214115?v=4"
	private var zemyoroIcon = "https://avatars.githubusercontent.com/u/85952603?v=4"

	private(set) var ghCellViewModels = [SettingsGitHubCellViewViewModel]()
	private(set) var appCellViewModels = [SettingsAppCellViewModel]()
	private(set) var footerViewModel: SettingsFooterViewModel!

	weak var delegate: SettingsViewViewModelDelegate?

	/// Designated initializer
	init() {
		setupModels()
	}

	private func setupModels() {
		ghCellViewModels = [
			.init(developer: .luki, imageURLString: lukiIcon) { [weak self] developer in
				self?.delegate?.didTapDev(developer)
			},
			.init(developer: .zemyoro, imageURLString: zemyoroIcon) { [weak self] developer in
				self?.delegate?.didTapDev(developer)
			}
		]

		appCellViewModels = [
			.init(app: .tweakIndex) { [weak self] app in
				self?.delegate?.didTapApp(app)
			},
			.init(app: .azure) { [weak self] app in
				self?.delegate?.didTapApp(app)
			}
		]

		footerViewModel = .init() { [weak self] in
			self?.delegate?.didTapSourceCodeButton()
		}
	}

}
