/*--- credits & slightly modified from ⇝ https://github.com/chrishoste/printerest-tabbar ---*/

import UIKit


protocol CHFloatingTabViewDelegate: AnyObject {
	func didSelect(index: Int)
}

/// Custom floating tab bar view class
final class CHFloatingTabView: UIView {

	private lazy var buttonsStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: tabBarButtons)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private lazy var tabBarVisualEffectView: UIVisualEffectView = {
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
		visualEffectView.clipsToBounds = true
		insertSubview(visualEffectView, at: 0)
		return visualEffectView
	}()

	private var tabBarButton: UIButton!
	private var tabBarButtons = [UIButton]()

	weak var delegate: CHFloatingTabViewDelegate?

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	/// Designated initializer
	/// - Parameters:
	/// 	- withItems: An array of strings to represent each tab bar item
	init(withItems items: [String]) {
		super.init(frame: .zero)
		setupButtons(withItems: items)
		updateState(withSelectedIndex: 0)
		addSubview(buttonsStackView)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layoutUI()
	}

	// ! Private

	private func setupButtons(withItems items: [String]) {
		for (index, item) in items.enumerated() {
			let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
			let image = UIImage(systemName: item, withConfiguration: symbolConfiguration) ?? UIImage()
			tabBarButton = createButton(withImage: image, index: index)
			tabBarButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
			tabBarButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
			tabBarButtons.append(tabBarButton)
		}
	}

	private func layoutUI() {
		pinViewToAllEdges(tabBarVisualEffectView)

		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: buttonsStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: buttonsStackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: buttonsStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15),
			NSLayoutConstraint(item: buttonsStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15)
		])

		layer.cornerCurve = .continuous
		layer.cornerRadius = bounds.height / 2
		layer.shadowColor = UIColor.label.cgColor
		layer.shadowOpacity = 0.15
		layer.shadowPath = UIBezierPath(rect: bounds).cgPath
		layer.shadowRadius = bounds.height / 2

		tabBarVisualEffectView.layer.cornerCurve = .continuous
		tabBarVisualEffectView.layer.cornerRadius = bounds.height / 2
	}

	private func createButton(withImage image: UIImage, index: Int) -> UIButton {
		let button = UIButton()
		button.tag = index
		button.adjustsImageWhenHighlighted = false
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(didTapTabBarButton(_:)), for: .touchUpInside)
		return button
	}

	@objc
	private func didTapTabBarButton(_ button: UIButton) {
		button.setPulseAnimation()
		delegate?.didSelect(index: button.tag)
		updateState(withSelectedIndex: button.tag)
	}

	private func updateState(withSelectedIndex selectedIndex: Int) {
		for (index, button) in tabBarButtons.enumerated() {
			if index == selectedIndex {
				button.isSelected = true
				button.tintColor = .chelseaPurpleColor
			}
			else {
				button.isSelected = false
				button.tintColor = .gray
			}
		}
	}

}

extension CHFloatingTabView {

	// ! Public

	func shouldHide(_ hide: Bool) {
		if !hide { isHidden = hide }
		UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
			self.alpha = hide ? 0 : 1
		}) { _ in
			if hide { self.isHidden = hide }
		}
	}

}

private extension UIButton {

	func setPulseAnimation() {
		let pulseAnimation = CASpringAnimation(keyPath: "transform.scale")
		pulseAnimation.duration = 0.15
		pulseAnimation.fromValue = 0.80
		pulseAnimation.toValue = 1.0
		layer.add(pulseAnimation, forKey: nil)
	}

}
