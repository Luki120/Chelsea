import Foundation

/// Enum to represent each developer for the GitHub cell
enum SettingsDeveloper: String {
	case luki = "Luki120"
	case zemyoro = "Zemyoro"

	var devName: String {
		switch self {
			case .luki, .zemyoro: return rawValue
		}
	}

	var targetURL: URL? {
		switch self {
			case .luki: return URL(string: "https://github.com/Luki120")
			case .zemyoro: return URL(string: "https://github.com/Zemyoro")
		}
	}
}

/// Enum to represent each app for the app cell
enum SettingsApp: String {
	case tweakIndex = "TweakIndex"
	case azure = "Azure"

	var appName: String {
		switch self {
			case .tweakIndex, .azure: return rawValue
		}
	}

	var appDescription: String {
		switch self {
			case .tweakIndex: return "SwiftUI version"
			case .azure: return "FOSS TOTP 2FA app with a clean, straightforward UI"
		}
	}

	var appURL: URL? {
		switch self {
			case .tweakIndex: return URL(string: "https://github.com/Zemyoro/TweakIndex")
			case .azure: return URL(string: "https://github.com/Luki120/Azure")
		}
	}

}
