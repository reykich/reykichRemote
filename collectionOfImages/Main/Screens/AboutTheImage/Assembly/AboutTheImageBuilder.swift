import Foundation
import NeedleFoundation

final class AboutTheImageBuilder: Component<EmptyDependency> {
    var viewController: UIViewController {
        return AboutTheImageViewController(viewModel: viewModel)
    }
    
    private var viewModel: AboutTheImageViewModel {
        return AboutTheImageDefaultViewModel()
    }
}
