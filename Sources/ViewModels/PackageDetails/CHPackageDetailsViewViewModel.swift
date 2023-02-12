import UIKit


protocol CHPackageDetailsViewViewModelDelegate: AnyObject {
	func didSelectAuthorCell()
	func didSelectViewDepictionCell()
}

/// View model class for CHPackageDetailsView
final class CHPackageDetailsViewViewModel: NSObject {

	let package: Package

	var depictionURL: String { package.depiction ?? "" }
	var price: String { package.status == "online" ? package.price : "Unavailable" }
	var title: String { package.name ?? package.identifier }

	var priceTextColor: UIColor { package.status == "online" ? .chelseaPurpleColor : .systemRed }

	// ! Utilities

	var authorEmail: String! { .authorEmail(package.author ?? "") }
	private var cleanAuthor: String! { .cleanAuthor(package.author ?? "Unknown") }

	// ! UICollectionViewDiffableDataSource

	@frozen private enum Sections: Hashable {
		case main
		case footer
	}

	private typealias CellRegistration = UICollectionView.CellRegistration<CHPackageDetailsCollectionViewListCell, CHPackageDetailsCollectionViewListCellViewModel>
	private typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<CHPackageDetailsHeaderCollectionReusableView>
	private typealias DataSource = UICollectionViewDiffableDataSource<CHPackageDetailsViewViewModel.Sections, CHPackageDetailsCollectionViewListCellViewModel>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<CHPackageDetailsViewViewModel.Sections, CHPackageDetailsCollectionViewListCellViewModel>

	private var dataSource: DataSource!
	private var snapshot: Snapshot!

	private var cellDetailViewModels = [CHPackageDetailsCollectionViewListCellViewModel]()
	private var detailHeaderViewModel: CHPackageDetailsHeaderCollectionReusableViewViewModel!
	private var footerViewModel = [CHPackageDetailsCollectionViewListCellViewModel]()

	weak var delegate: CHPackageDetailsViewViewModelDelegate?

	/// Designated initializer
	/// - Parameters:
	/// 	- package: the package model object
	init(package: Package) {
		self.package = package
		super.init()
		setupModels()
	}

	// ! Private

	private func setupModels() {
		detailHeaderViewModel = .init(imageURLString: package.packageIcon ?? PackageIcon(package.section).section)

		cellDetailViewModels = [
			.init(mainText: package.name ?? "-"),
			.init(mainText: package.identifier),
			.init(mainText: cleanAuthor, secondaryText: authorEmail),
			.init(mainText: "Version", secondaryText: package.latestVersion),
			.init(mainText: "Repository", secondaryText: package.repository.name)
		]

		footerViewModel = [
			.init(mainText: package.description)
		]

		guard package.depiction != nil else { return }
		footerViewModel.append(.init(mainText: "View depiction", textColor: .chelseaPurpleColor))
	}

}

// ! CollectionView

extension CHPackageDetailsViewViewModel {

	/// Function to setup the list collection view's data source
	/// - Parameters:
	///		- listCollectionView: the collection view
	func setupListCollectionView(_ listCollectionView: UICollectionView) {
		let cellRegistration = CellRegistration { cell, _, viewModel in
			cell.viewModel = viewModel
		}

		dataSource = DataSource(collectionView: listCollectionView) { collectionView, indexPath, identifier -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(
				using: cellRegistration,
				for: indexPath,
				item: identifier
			)
			return cell
		}

		setupHeader()

		snapshot = Snapshot()
		snapshot.appendSections([.main, .footer])
		snapshot.appendItems(cellDetailViewModels, toSection: .main)
		snapshot.appendItems(footerViewModel, toSection: .footer)

		dataSource.apply(snapshot)
	}

	private func setupHeader() {
		let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { detailHeaderView, _, _ in
			detailHeaderView.configure(with: self.detailHeaderViewModel)
		}

		dataSource.supplementaryViewProvider = { collectionView, _, indexPath -> UICollectionReusableView? in
			return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
		}
	}

}

extension CHPackageDetailsViewViewModel: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		switch indexPath.section {
			case 0:
				switch indexPath.row {
					case 2:
						guard authorEmail != nil else { return } 
						delegate?.didSelectAuthorCell()
					default: break
				}
			case 1:
				switch indexPath.row {
					case 1: delegate?.didSelectViewDepictionCell()
					default: break
				}
			default: break
		}
	}

}
