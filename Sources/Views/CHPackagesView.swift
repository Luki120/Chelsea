import UIKit


final class CHPackagesView: UIView {

	private let viewModel = CHPackagesViewViewModel()

	private lazy var packagesCollectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.backgroundColor = .systemBackground
		collectionView.register(CHPackagesCollectionViewCell.self, forCellWithReuseIdentifier: CHPackagesCollectionViewCell.identifier)
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

	private func setupCollectionView() {
		packagesCollectionView.dataSource = viewModel
		packagesCollectionView.delegate = viewModel
	}

	private func layoutUI() {
		pinViewToAllEdges(packagesCollectionView)
	}

}

extension CHPackagesView: CHPackagesViewViewModelDelegate {

	func didFetchPackages() {
		packagesCollectionView.reloadData()
	}

}
