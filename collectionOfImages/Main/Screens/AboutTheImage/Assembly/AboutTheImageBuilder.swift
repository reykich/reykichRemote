import Foundation
import NeedleFoundation

final class AboutTheImageBuilder: Component<EmptyDependency> {
    func getViewController(with aboutTheImage: AboutTheImage) -> UIViewController {
        return AboutTheImageViewController(viewModel: getViewModel(with: aboutTheImage))
    }
    
    private func getViewModel(with aboutTheImage: AboutTheImage) -> AboutTheImageViewModel {
        return AboutTheImageDefaultViewModel(aboutTheImage: aboutTheImage)
    }
}
