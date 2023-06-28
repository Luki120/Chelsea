import UIKit


extension String {
	static func authorEmail(_ authorEmail: String) -> String {
		let scanner = Scanner(string: authorEmail)

		guard scanner.scanUpToString("<") != nil,
			scanner.scanString("<") != nil,
			let scannedString = scanner.scanUpToString(">") else { return "" }

		return scannedString
	}

	static func cleanAuthor(_ author: String) -> String {
		let scanner = Scanner(string: author)
		guard let scannedString = scanner.scanUpToString("<") else { return "" }
		return scannedString
	}
}

extension UIColor {
	static let chelseaPurpleColor = UIColor(red: 0.61, green: 0.54, blue: 1.0, alpha: 1.0)
}

extension UIStackView {
	func addArrangedSubviews(_ views: UIView ...) {
		views.forEach { addArrangedSubview($0) }
	}
}

extension UIView {
	func addSubviews(_ views: UIView ...) {
		views.forEach { addSubview($0) }
	}

	func createSpinnerView(withStyle style: UIActivityIndicatorView.Style, childOf view: UIView) -> UIActivityIndicatorView {
		let spinnerView = UIActivityIndicatorView(style: style)
		spinnerView.hidesWhenStopped = true
		view.addSubview(spinnerView)
		return spinnerView
	}

	func pinViewToAllEdges(
		_ view: UIView,
		topConstant: CGFloat = 0,
		bottomConstant: CGFloat = 0,
		leadingConstant: CGFloat = 0,
		trailingConstant: CGFloat = 0,
		pinToSafeArea: Bool = false
	) {
		view.translatesAutoresizingMaskIntoConstraints = false
		guard pinToSafeArea else {
			NSLayoutConstraint.activate([
				view.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
				view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant),
				view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant),
				view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant)
			])
			return
		}
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: topConstant),
			view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: bottomConstant),
			view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: leadingConstant),
			view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: trailingConstant)
		])
	}

	func centerViewOnBothAxes(_ view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			view.centerXAnchor.constraint(equalTo: centerXAnchor),
			view.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}

	func setupHorizontalConstraints(forView view: UIView, leadingConstant: CGFloat, trailingConstant: CGFloat) {
		view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant),
			view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant)
		])
	}

	func setupSizeConstraints(forView view: UIView, width: CGFloat, height: CGFloat) {
		view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			view.widthAnchor.constraint(equalToConstant: width),
			view.heightAnchor.constraint(equalToConstant: height)
		])
	}
}

extension UIViewController {
	func shouldHideTabView(_ hide: Bool) {
		guard let tabBarVC = tabBarController as? TabBarVC else { return }
		tabBarVC.shouldHideFloatingTabView(hide)
	}
}
