import UIKit


extension String {
	static func authorEmail(_ authorEmail: String) -> String? {
		let scanner = Scanner(string: authorEmail)

		guard scanner.scanUpToString("<") != nil,
			scanner.scanString("<") != nil,
			let scannedString = scanner.scanUpToString(">") else { return nil }

		return scannedString
	}

	static func cleanAuthor(_ author: String) -> String? {
		let scanner = Scanner(string: author)
		guard let scannedString = scanner.scanUpToString("<") else { return nil }
		return scannedString
	}
}

extension UIColor {
	static let chelseaPurpleColor = UIColor(red: 0.61, green: 0.54, blue: 1.0, alpha: 1.0)
}

extension UIView {
	func addSubviews(_ views: UIView ...) {
		views.forEach { addSubview($0) }
	}

	func pinViewToAllEdges(_ view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: topAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor),
			view.leadingAnchor.constraint(equalTo: leadingAnchor),
			view.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
}

extension UIStackView {
	func addArrangedSubviews(_ views: UIView ...) {
		views.forEach { addArrangedSubview($0) }
	}
}
