import Foundation
import UIKit

final class DefaultMainRouter {
    private let mainComponent: MainComponent
    private let navigationController: UINavigationController
    
    init(mainComponent: MainComponent,
         navigationController: UINavigationController) {
        self.mainComponent = mainComponent
        self.navigationController = navigationController
    }
}

extension DefaultMainRouter: MainRouter {
    func openAboutTheImageScreen() {
        let viewController = mainComponent.aboutTheImageViewController
        navigationController.pushViewController(viewController, animated: true)
    }
}
