import UIKit


final class CHPackageDetailsHeaderCollectionReusableView : UICollectionReusableView {

	private lazy var headerImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerCurve = .continuous
		imageView.layer.cornerRadius = 20
		addSubview(imageView)
		return imageView
	}()

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		layoutUI()
	}

	// ! Private

	private func layoutUI() {
		let topAnchor = headerImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20)
		topAnchor.priority = UILayoutPriority(999)

		let bottomAnchor = headerImageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -20)
		bottomAnchor.priority = UILayoutPriority(999)

		NSLayoutConstraint.activate([
			topAnchor,
			bottomAnchor,
			headerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			headerImageView.widthAnchor.constraint(equalToConstant: 100),
			headerImageView.heightAnchor.constraint(equalToConstant: 100)
		])
	}

}

extension CHPackageDetailsHeaderCollectionReusableView {

	// ! Public

	func configure(with viewModel: CHPackageDetailsHeaderCollectionReusableViewViewModel) {
		viewModel.fetchHeaderImage { [weak self] result in
			switch result {
				case .success((let image, _)):
					DispatchQueue.main.async {
						self?.headerImageView.image = image
					}
				case .failure: break
			}
		}
	}

}
