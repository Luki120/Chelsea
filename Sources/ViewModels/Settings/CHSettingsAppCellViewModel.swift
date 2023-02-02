import Foundation


struct CHSettingsAppCellViewModel: Identifiable {

	private(set) var id = UUID()

	let app: CHSettingsApp
	let onTap: (CHSettingsApp) -> ()

	var appName: String { return app.appName }
	var appDescription: String { return app.appDescription }

}
