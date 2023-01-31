import UIKit


protocol Coordinator {
	associatedtype Event
	var navigationController: UINavigationController { get set }
	func eventOccurred(with event: Event)
}
