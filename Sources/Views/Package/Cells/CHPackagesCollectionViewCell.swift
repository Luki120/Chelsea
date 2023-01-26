import UIKit


final class CHPackagesCollectionViewCell: UICollectionViewCell {

	static let identifier = "CHPackagesCollectionViewCell"

	private weak var activeViewModel: CHPackagesCollectionViewCellViewModel?

	private lazy var packageImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleToFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
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

	private var packageNameLabel: UILabel!
	private var packageAuthorLabel: UILabel!
	private var packageDescriptionLabel: UILabel!

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
 		packageNameLabel.text = nil
		packageAuthorLabel.text = nil
		packageDescriptionLabel.text = nil
		packageImageView.image = nil
	}

	// ! Private

	private func setupUI() {
		contentView.backgroundColor = .secondarySystemBackground
		contentView.layer.cornerCurve = .continuous
		contentView.layer.cornerRadius = 10

		packageNameLabel = createLabel(withFontSize: 14, textColor: .label, numberOfLines: 1)
		packageAuthorLabel = createLabel(withFontSize: 12, textColor: .label, numberOfLines: 1)
		packageDescriptionLabel = createLabel(withFontSize: 10, textColor: .secondaryLabel, numberOfLines: 3)

		packageInfoStackView.addArrangedSubviews(packageNameLabel, packageAuthorLabel, packageDescriptionLabel)
	}

	private func layoutUI() {
		packageImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		packageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
		packageImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
		packageImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

		packageInfoStackView.centerYAnchor.constraint(equalTo: packageImageView.centerYAnchor).isActive = true		
		packageInfoStackView.leadingAnchor.constraint(equalTo: packageImageView.trailingAnchor, constant: 10).isActive = true
		packageInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
	}

	// ! Reusable

	private func createLabel(withFontSize size: CGFloat, textColor: UIColor, numberOfLines lines: Int) -> UILabel {
		let label = UILabel()
		label.font = .systemFont(ofSize: size)
		label.textColor = textColor
		label.numberOfLines = lines
		return label
	}

}

extension CHPackagesCollectionViewCell {

	// ! Public

	func configure(with viewModel: CHPackagesCollectionViewCellViewModel) {
		activeViewModel = viewModel

		packageNameLabel.text = viewModel.packageName
		packageDescriptionLabel.text = viewModel.packageDescription
		packageAuthorLabel.text = "\(viewModel.packageAuthor) • \(viewModel.packageLatestVersion)"

		viewModel.fetchImage { [weak self] result in
			guard let self = self, self.activeViewModel == viewModel else { return }
			switch result {
				case .success(let image):
					DispatchQueue.main.async {
						self.packageImageView.image = image
					}
				case .failure: break
			}
		}
	}

}
