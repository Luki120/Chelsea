import UIKit


final class CHPackageDetailsView: UIView {

	var viewModel: CHPackageDetailsViewViewModel

	private lazy var listCollectionView: UICollectionView = {
		let sectionProvider = {
			(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
			var section: NSCollectionLayoutSection
			var listConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
			listConfig.headerMode = sectionIndex == 0 ? .supplementary : .none
			section = NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
			return section
		}
		let listLayout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
		collectionView.backgroundColor = .systemBackground
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(collectionView)
		return collectionView
	}()

	// ! Lifecycle

	required init?(coder: NSCoder) {
		fatalError("L")	
	}

	init(viewModel: CHPackageDetailsViewViewModel) {
		self.viewModel = viewModel
		super.init(frame: .zero)
		setupUI()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layoutUI()
	}

	// ! Private

	private func setupUI() {
		viewModel.setupListCollectionView(listCollectionView)
		setupCollectionView()
	}

	private func setupCollectionView() {
		listCollectionView.delegate = viewModel
	}

	private func layoutUI() {
		pinViewToAllEdges(listCollectionView)
	}

}
