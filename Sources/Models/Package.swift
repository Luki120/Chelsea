import Foundation


struct APIResponse: Codable {
	let success: Bool
	let packages: [Package]
}

struct Package: Codable, Hashable {
	let identifier: String
	let name: String?
	let description: String
	let packageIcon: String?
	let author: String?
	let latestVersion: String
	let depiction: String?
	let section: String
	let price: String
	let status: String
	let repository: PackageRepository
}

struct PackageRepository: Codable, Hashable {
	let uri: String
	let name: String
}
