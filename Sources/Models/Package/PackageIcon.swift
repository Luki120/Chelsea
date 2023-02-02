import Foundation


enum PackageIcon: String {
	case addons = "Addons"
	case applications = "Applications"
	case themes = "Themes"
	case tweaks = "Tweaks"
	case utilities = "Utilities"
	case widgets = "Widgets"

	// credits ⇝ https://stackoverflow.com/a/60676515
	// custom initializer to provide a default value in case the switch doesn't fall into one of the provided cases
	init(_ optionalValue: RawValue?) {
		guard let rawValue = optionalValue, let validValue = PackageIcon(rawValue: rawValue) else {
			self = .tweaks
			return
		}
		self = validValue
	}

	private var utilitiesIcon: String {
		return "https://raw.githubusercontent.com/Sileo/Sileo/main/Icons/Category%20Icons/utilities.PNG"
	}

	var section: String {
		switch self {
			case .addons: return "https://cdn-static.yourepo.com/images/sections/users/1.png"
			case .applications, .utilities: return utilitiesIcon
			case .themes: return "https://repo.packix.com/icons/theme.png"
			case .tweaks: return "https://repo.packix.com/icons/tweak.png"
			case .widgets: return "https://repo.packix.com/icons/widget.png"
		}
	}
}
