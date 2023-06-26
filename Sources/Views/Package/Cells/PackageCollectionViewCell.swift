import UIKit

/// Class to represent the package cell
final class PackageCollectionViewCell: UICollectionViewCell {

	private var activeViewModel: PackageCollectionViewCellViewModel?

	private lazy var packageImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleToFill
		imageView.clipsToBounds = true
		imageView.layer.cornerCurve = .continuous
		imageView.layer.cornerRadius = 10
		contentView.addSubview(imageView)
		return imageView
	}()

	private lazy var packageInfoStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 2
		stackView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(stackView)
		return stackView
	}()

	private lazy var spinnerView = createSpinnerView(withStyle: .medium, childOf: contentView) 

	private var packageNameLabel, packageAuthorLabel, packageDescriptionLabel: UILabel!

	// ! Lifecyle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layoutUI()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		activeViewModel = nil
		packageImageView.image = nil
		[packageNameLabel, packageAuthorLabel, packageDescriptionLabel].forEach { $0.text = nil }

		spinnerView.startAnimating()
	}

	// ! Private

	private func setupUI() {
		spinnerView.startAnimating()

		contentView.backgroundColor = .secondarySystemGroupedBackground
		contentView.layer.cornerCurve = .continuous
		contentView.layer.cornerRadius = 10

		packageNameLabel = createLabel(withFontSize: 14)
		packageAuthorLabel = createLabel(withFontSize: 12)
		packageDescriptionLabel = createLabel(withFontSize: 10, textColor: .secondaryLabel, numberOfLines: 3)

		packageInfoStackView.addArrangedSubviews(packageNameLabel, packageAuthorLabel, packageDescriptionLabel)
	}

	private func layoutUI() {
		setupSizeConstraints(forView: packageImageView, width: 50, height: 50)
		packageImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		packageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true

		packageInfoStackView.centerYAnchor.constraint(equalTo: packageImageView.centerYAnchor).isActive = true		
		packageInfoStackView.leadingAnchor.constraint(equalTo: packageImageView.trailingAnchor, constant: 10).isActive = true
		packageInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true

		packageImageView.centerViewOnBothAxes(spinnerView)
		setupSizeConstraints(forView: spinnerView, width: 100, height: 100)
	}

	// ! Reusable

	private func createLabel(withFontSize size: CGFloat, textColor: UIColor = .label, numberOfLines lines: Int = 1) -> UILabel {
		let label = UILabel()
		label.font = .systemFont(ofSize: size)
		label.textColor = textColor
		label.numberOfLines = lines
		return label
	}

}

extension PackageCollectionViewCell {

	// ! Public

	/// Function to configure the cell with its respective view model
	/// - Parameters:
	/// 	- with: The cell's view model
	func configure(with viewModel: PackageCollectionViewCellViewModel) {
		activeViewModel = viewModel

		packageNameLabel.text = viewModel.packageName
		packageDescriptionLabel.text = viewModel.packageDescription
		packageAuthorLabel.text = "\(viewModel.packageAuthor) • \(viewModel.packageLatestVersion)"

		viewModel.fetchImage { [weak self] result in
			switch result {
				case .success((let image, let isFromNetwork)):
					DispatchQueue.main.async {
						guard let self, self.activeViewModel == viewModel else { return }
						guard !isFromNetwork else {
							UIView.transition(with: self.packageImageView, duration: 0.5, options: .transitionCrossDissolve) {
								self.packageImageView.image = image
							}
							return
						}
						self.packageImageView.image = image
						self.spinnerView.stopAnimating()
					}
				case .failure: break
			}
		}
	}

}
