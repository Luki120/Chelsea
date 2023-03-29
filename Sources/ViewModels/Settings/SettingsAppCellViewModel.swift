import Foundation

/// View model struct to construct the app cell for SettingsView
struct SettingsAppCellViewModel: Identifiable {

	private(set) var id = UUID()

	let app: SettingsApp
	let onTap: (SettingsApp) -> ()

	var appName: String { return app.appName }
	var appDescription: String { return app.appDescription }

}
