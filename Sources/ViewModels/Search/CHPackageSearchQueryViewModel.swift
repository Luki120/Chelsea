import Combine

/// View model class to handle the search queries
final class CHPackageSearchQueryViewModel: ObservableObject {

	let searchQuerySubject = PassthroughSubject<String, Never>()

}
