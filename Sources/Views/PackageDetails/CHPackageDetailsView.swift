import UIKit


protocol CHPackageDetailsViewDelegate: AnyObject {
	func chPackageDetailsViewDidSelectAuthorCell()
	func chPackageDetailsViewDidSelectViewDepictionCell()
}

/// Class to represent the package details view
final class CHPackageDetailsView: UIView {

	let viewModel: CHPackageDetailsViewViewModel

	private lazy var listCollectionView: UICollectionView = {
		let sectionProvider = {
			(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
			var listConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
			listConfig.headerMode = sectionIndex == 0 ? .supplementary : .none
			return NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
		}
		let listLayout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
		collectionView.backgroundColor = .systemBackground
		collectionView.delegate = viewModel
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(collectionView)
		return collectionView
	}()

	weak var delegate: CHPackageDetailsViewDelegate?

	// ! Lifecycle

	required init?(coder: NSCoder) {
		fatalError("L")	
	}

	/// Designated initializer
	/// - Parameters:
	/// 	- viewModel: the view's view model
	init(viewModel: CHPackageDetailsViewViewModel) {
		self.viewModel = viewModel
		super.init(frame: .zero)
		viewModel.delegate = self
		viewModel.setupListCollectionView(listCollectionView)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		pinViewToAllEdges(listCollectionView)
	}

}

// ! CHPackageDetailsViewViewModelDelegate

extension CHPackageDetailsView: CHPackageDetailsViewViewModelDelegate {

	func didSelectAuthorCell() {
		delegate?.chPackageDetailsViewDidSelectAuthorCell()
	}

	func didSelectViewDepictionCell() {
		delegate?.chPackageDetailsViewDidSelectViewDepictionCell()	
	}

}
