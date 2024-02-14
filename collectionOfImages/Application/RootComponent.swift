import Foundation
import UIKit
import NeedleFoundation

public final class RootComponent: BootstrapComponent {
    public var rootNavigationController: UINavigationController {
        shared {
            return UINavigationController()
        }
    }
    
    var mainViewController: UIViewController {
        return MainViewController(router: mainRouter, viewModel: mainViewModel)
    }
    
    private var mainViewModel: MainViewModel {
        return DefaultMainViewModel()
    }
    
    private var mainRouter: MainRouter {
        return DefaultMainRouter(
            mainComponent: mainComponent,
            navigationController: rootNavigationController
        )
    }
    
    private var mainComponent: MainComponent {
        return MainComponent(parent: self)
    }
}
