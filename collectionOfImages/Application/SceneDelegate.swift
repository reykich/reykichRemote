import UIKit
import NeedleFoundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private lazy var rootComponent = RootComponent()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        registerProviderFactories()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window!.overrideUserInterfaceStyle = .light
        window?.windowScene = windowScene
        let rootNavigationController = rootComponent.rootNavigationController
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
}

