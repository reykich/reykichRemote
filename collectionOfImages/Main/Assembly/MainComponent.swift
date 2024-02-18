import Foundation
import NeedleFoundation
import UIKit

final class MainComponent: Component<EmptyDependency> {
    func getAboutTheImageViewController(
        with collectionOfImage: CollectionOfImageResponse
    ) -> UIViewController {
        return aboutTheImageBuilder.getViewController(with: collectionOfImage)
    }
    
    private var aboutTheImageBuilder: AboutTheImageBuilder {
        return AboutTheImageBuilder(parent: self)
    }
}
