import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let peopleViewController = PeopleViewModuleBuilder().build()
        let navigationController = UINavigationController(
            rootViewController: peopleViewController
        )

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

}

