import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window!.overrideUserInterfaceStyle = .light
        window?.windowScene = windowScene
        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = .green
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = rootNavigationController //Self.rootComponent.tabBar
        window?.makeKeyAndVisible()
    }
}

