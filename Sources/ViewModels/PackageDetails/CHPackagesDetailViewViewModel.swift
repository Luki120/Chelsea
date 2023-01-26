import UIKit


final class CHPackagesDetailViewViewModel: NSObject {

	let package: Package

	// ! Utilities

	var title: String { package.name ?? "Unknown" }

	private var cleanAuthor: String? {
		let scanner = Scanner(string: package.author ?? "")
		guard let scannedString = scanner.scanUpToString("<") else { return nil }
		return scannedString
	}

	private var authorEmail: String? {
		let scanner = Scanner(string: package.author ?? "")

		guard scanner.scanUpToString("<") != nil,
			scanner.scanString("<") != nil,
			let scannedString = scanner.scanUpToString(">") else { return nil }

		return scannedString
	}

	// ! UICollectionViewDiffableDataSource

	@frozen private enum Sections: Hashable {
		case main
		case footer
	}

	private var dataSource: UICollectionViewDiffableDataSource<CHPackagesDetailViewViewModel.Sections, CHPackagesDetailCollectionViewListCellViewModel>!
	private var snapshot: NSDiffableDataSourceSnapshot<CHPackagesDetailViewViewModel.Sections, CHPackagesDetailCollectionViewListCellViewModel>!

	private var cellDetailViewModels = [CHPackagesDetailCollectionViewListCellViewModel]()
	private var detailHeaderViewModel: CHPackagesDetailHeaderCollectionReusableViewViewModel!
	private var footerViewModel = [CHPackagesDetailCollectionViewListCellViewModel]()

	init(package: Package) {
		self.package = package
		super.init()
		setupModels()
	}

	// ! Private

	private func setupModels() {
		detailHeaderViewModel = .init(imageURLString: package.packageIcon ?? "https://repo.packix.com/icons/tweak.png")

		cellDetailViewModels = [
			.init(mainText: package.name ?? "-"),
			.init(mainText: package.identifier),
			.init(mainText: cleanAuthor ?? "Unknown", secondaryText: authorEmail ?? ""),
			.init(mainText: "Version", secondaryText: package.latestVersion),
			.init(mainText: "Repository", secondaryText: package.repository.name)
		]

		footerViewModel = [
			.init(mainText: package.description)
		]
	}

}

// ! CollectionView

extension CHPackagesDetailViewViewModel: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
	}

	func setupListCollectionView(_ listCollectionView: UICollectionView) {
		let cellRegistration = UICollectionView.CellRegistration
		<CHPackagesDetailCollectionViewListCell, CHPackagesDetailCollectionViewListCellViewModel> { cell, _, viewModel in
			cell.viewModel = viewModel
		}

		dataSource = UICollectionViewDiffableDataSource<CHPackagesDetailViewViewModel.Sections, CHPackagesDetailCollectionViewListCellViewModel>(collectionView: listCollectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, identifier: CHPackagesDetailCollectionViewListCellViewModel) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(
				using: cellRegistration,
				for: indexPath,
				item: identifier
			)
			return cell
		}

		setupHeader()

		snapshot = NSDiffableDataSourceSnapshot<CHPackagesDetailViewViewModel.Sections, CHPackagesDetailCollectionViewListCellViewModel>()
		snapshot.appendSections([.main, .footer])
		snapshot.appendItems(cellDetailViewModels, toSection: .main)
		snapshot.appendItems(footerViewModel, toSection: .footer)

		dataSource.apply(snapshot)
	}

	private func setupHeader() {
		let headerRegistration = UICollectionView.SupplementaryRegistration
		<CHPackagesDetailHeaderCollectionReusableView>(elementKind: UICollectionView.elementKindSectionHeader) { detailHeaderView, _, _ in
			detailHeaderView.configure(with: self.detailHeaderViewModel)
		}

		dataSource.supplementaryViewProvider = { collectionView, _, indexPath -> UICollectionReusableView? in
			return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
		}
	}

}
