import UIKit


protocol PackageDetailsViewViewModelDelegate: AnyObject {
	func didSelectAuthorCell()
	func didSelectViewDepictionCell()
}

/// View model class for PackageDetailsView
final class PackageDetailsViewViewModel: NSObject {

	// ! Utilities

	var authorEmail: String { .authorEmail(package.author ?? "") }
	var depictionURL: String { package.depiction ?? "" }
	var price: String { package.status == "online" ? package.price : "Unavailable" }
	var title: String { package.name ?? package.identifier }

	var priceTextColor: UIColor { package.status == "online" ? .chelseaPurpleColor : .systemRed }

	// ! UICollectionViewDiffableDataSource

	@frozen private enum Sections: Hashable {
		case main
		case footer
	}

	private typealias CellRegistration = UICollectionView.CellRegistration<PackageDetailsCollectionViewListCell, PackageDetailsCollectionViewListCellViewModel>
	private typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<PackageDetailsHeaderCollectionReusableView>
	private typealias DataSource = UICollectionViewDiffableDataSource<Sections, PackageDetailsCollectionViewListCellViewModel>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, PackageDetailsCollectionViewListCellViewModel>

	private var dataSource: DataSource!

	private var cellDetailViewModels = [PackageDetailsCollectionViewListCellViewModel]()
	private var detailHeaderViewModel: PackageDetailsHeaderCollectionReusableViewViewModel!
	private var footerViewModels = [PackageDetailsCollectionViewListCellViewModel]()

	weak var delegate: PackageDetailsViewViewModelDelegate?

	private let package: Package

	/// Designated initializer
	/// - Parameters:
	/// 	- package: The package model object
	init(package: Package) {
		self.package = package
		super.init()
		setupModels()
	}

	// ! Private

	private func setupModels() {
		let cleanAuthor: String = .cleanAuthor(package.author ?? "Unknown")

		detailHeaderViewModel = .init(imageURLString: package.packageIcon ?? PackageIcon(package.section).section)

		cellDetailViewModels = [
			.init(mainText: package.name ?? "-"),
			.init(mainText: package.identifier),
			.init(mainText: cleanAuthor, secondaryText: authorEmail),
			.init(mainText: "Version", secondaryText: package.latestVersion),
			.init(mainText: "Repository", secondaryText: package.repository.name)
		]

		footerViewModels = [
			.init(mainText: package.description)
		]

		guard package.depiction != nil else { return }
		footerViewModels.append(.init(mainText: "View depiction", textColor: .chelseaPurpleColor))
	}

}

// ! CollectionView

extension PackageDetailsViewViewModel {

	/// Function to setup the list collection view's data source
	/// - Parameters:
	///		- listCollectionView: The collection view
	func setupListCollectionView(_ listCollectionView: UICollectionView) {
		let cellRegistration = CellRegistration { cell, _, viewModel in
			cell.viewModel = viewModel
		}

		dataSource = DataSource(collectionView: listCollectionView) { collectionView, indexPath, identifier in
			let cell = collectionView.dequeueConfiguredReusableCell(
				using: cellRegistration,
				for: indexPath,
				item: identifier
			)
			return cell
		}

		setupHeader()

		var snapshot = Snapshot()
		snapshot.appendSections([.main, .footer])
		snapshot.appendItems(cellDetailViewModels, toSection: .main)
		snapshot.appendItems(footerViewModels, toSection: .footer)

		dataSource.apply(snapshot)
	}

	private func setupHeader() {
		let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { detailHeaderView, _, _ in
			detailHeaderView.configure(with: self.detailHeaderViewModel)
		}

		dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
			return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
		}
	}

}

extension PackageDetailsViewViewModel: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		switch indexPath.section {
			case 0:
				switch indexPath.item {
					case 2:
						guard authorEmail != "" else { return } 
						delegate?.didSelectAuthorCell()
					default: break
				}
			case 1:
				switch indexPath.item {
					case 1: delegate?.didSelectViewDepictionCell()
					default: break
				}
			default: break
		}
	}

}
