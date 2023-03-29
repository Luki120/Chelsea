import UIKit


protocol PackageDetailsViewDelegate: AnyObject {
	func packageDetailsViewDidSelectAuthorCell()
	func packageDetailsViewDidSelectViewDepictionCell()
}

/// Class to represent the package details view
final class PackageDetailsView: UIView {

	let viewModel: PackageDetailsViewViewModel

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
		addSubview(collectionView)
		return collectionView
	}()

	weak var delegate: PackageDetailsViewDelegate?

	// ! Lifecycle

	required init?(coder: NSCoder) {
		fatalError("L")	
	}

	/// Designated initializer
	/// - Parameters:
	/// 	- viewModel: the view's view model
	init(viewModel: PackageDetailsViewViewModel) {
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

// ! PackageDetailsViewViewModelDelegate

extension PackageDetailsView: PackageDetailsViewViewModelDelegate {

	func didSelectAuthorCell() {
		delegate?.packageDetailsViewDidSelectAuthorCell()
	}

	func didSelectViewDepictionCell() {
		delegate?.packageDetailsViewDidSelectViewDepictionCell()	
	}

}
