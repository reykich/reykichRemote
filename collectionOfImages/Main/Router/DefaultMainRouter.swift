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
    func openAboutTheImageScreen(with imageInfo: ImageInfo) {
        let viewController = mainComponent.getAboutTheImageViewController(with: imageInfo)
        navigationController.pushViewController(viewController, animated: false)
    }
}
