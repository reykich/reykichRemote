import Foundation
import NeedleFoundation
import UIKit

final class MainComponent: Component<EmptyDependency> {
    func getAboutTheImageViewController(
        with imageInfo: ImageInfo
    ) -> UIViewController {
        return aboutTheImageBuilder.getViewController(with: imageInfo)
    }
    
    private var aboutTheImageBuilder: AboutTheImageBuilder {
        return AboutTheImageBuilder(parent: self)
    }
}
