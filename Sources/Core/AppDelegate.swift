import UIKit


@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		window = UIWindow()
		window?.tintColor = .chelseaPurpleColor
		window?.rootViewController = TabBarVC()
		window?.makeKeyAndVisible()
		return true
	}

}
