import UIKit


final class CHPackagesView: UIView {

	private let viewModel = CHPackagesViewViewModel()

	private lazy var packagesCollectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.register(CHPackagesCollectionViewCell.self, forCellWithReuseIdentifier: CHPackagesCollectionViewCell.identifier)
		collectionView.backgroundColor = .systemBackground
		addSubview(collectionView)
		return collectionView
	}()

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		viewModel.fetchPackages()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layoutUI()
	}

	// ! Private

	private func setupUI() {
		backgroundColor = .systemBackground
		setupCollectionView()
	}

	private func layoutUI() {
		packagesCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		packagesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		packagesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		packagesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}

	private func setupCollectionView() {
		packagesCollectionView.dataSource = viewModel
		packagesCollectionView.delegate = viewModel
	}

}

extension CHPackagesView: CHPackagesViewViewModelDelegate {

	func didFetchPackages() {
		packagesCollectionView.reloadData()
	}

}
