import UIKit


extension UIView {
	func addSubviews(_ views: UIView ...) {
		views.forEach { addSubview($0) }
	}
}

extension UIStackView {
	func addArrangedSubviews(_ views: UIView ...) {
		views.forEach { addArrangedSubview($0) }
	}
}
