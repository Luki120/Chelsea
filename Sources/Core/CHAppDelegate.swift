import UIKit


@UIApplicationMain
class CHAppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		window = UIWindow()
		window?.tintColor = .chelseaPurpleColor
		window?.rootViewController = CHTabBarVC()
		window?.makeKeyAndVisible()
		return true
	}

}
