import Foundation
import UIKit
import NeedleFoundation

final class RootComponent: BootstrapComponent {
    public var rootNavigationController: UINavigationController {
        shared {
            return UINavigationController()
        }
    }
    
    var mainViewController: UIViewController {
        return MainViewController(router: mainRouter, viewModel: mainViewModel)
    }
    
    private var mainViewModel: MainViewModel {
        return DefaultMainViewModel(likeManager: likeManager)
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
    
    public var likeManager: LikeManager {
        shared {
            return DefaultLikeManager()
        }
    }
}
