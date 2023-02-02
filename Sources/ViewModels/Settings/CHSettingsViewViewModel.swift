import Foundation


protocol CHSettingsViewViewModelDelegate: AnyObject {
	func didTapDev(_ developer: CHSettingsDeveloper)
	func didTapApp(_ app: CHSettingsApp)
	func didTapSourceCodeButton()
}

final class CHSettingsViewViewModel {

	private var lukiIcon = "https://avatars.githubusercontent.com/u/74214115?v=4"
	private var zemyoroIcon = "https://avatars.githubusercontent.com/u/85952603?v=4"

	private(set) var ghCellViewModels = [CHGitHubCellViewModel]()
	private(set) var appCellViewModels = [CHSettingsAppCellViewModel]()
	private(set) var footerViewModel: CHSettingsFooterViewModel!

	weak var delegate: CHSettingsViewViewModelDelegate?

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
