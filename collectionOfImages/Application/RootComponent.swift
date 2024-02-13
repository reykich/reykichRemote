import Foundation
import UIKit
import NeedleFoundation

public final class RootComponent: BootstrapComponent {
    var rootNavigationController: UINavigationController {
        shared {
            let mainViewController = UIViewController()
            mainViewController.view.backgroundColor = .yellow
            return UINavigationController(rootViewController: mainViewController)
        }
    }
    
    private var mainComponent: MainComponent {
        return MainComponent(parent: self)
    }
}
