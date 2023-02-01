import Foundation


enum CHSettingsDeveloper {
	case luki
	case zemyoro

	var devName: String {
		switch self {
			case .luki: return "Luki120"
			case .zemyoro: return "Zemyoro"
		}
	}

	var targetURL: URL? {
		switch self {
			case .luki: return URL(string: "https://github.com/Luki120")
			case .zemyoro: return URL(string: "https://github.com/Zemyoro")
		}
	}
}
