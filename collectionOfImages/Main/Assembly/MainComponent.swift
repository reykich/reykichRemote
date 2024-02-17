import Foundation
import NeedleFoundation
import UIKit 

final class MainComponent: Component<EmptyDependency> {
    func getAboutTheImageViewController(with aboutTheImage: AboutTheImage) -> UIViewController {
        return aboutTheImageBuilder.getViewController(with: aboutTheImage)
    }
    
    private var aboutTheImageBuilder: AboutTheImageBuilder {
        return AboutTheImageBuilder(parent: self)
    }
}
