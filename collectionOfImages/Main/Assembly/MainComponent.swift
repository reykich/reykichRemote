import Foundation
import NeedleFoundation
import UIKit 

final class MainComponent: Component<EmptyDependency> {
    var aboutTheImageViewController: UIViewController {
        return aboutTheImageBuilder.viewController
    }
    
    private var aboutTheImageBuilder: AboutTheImageBuilder {
        return AboutTheImageBuilder(parent: self)
    }
}
