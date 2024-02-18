import Foundation
import NeedleFoundation

protocol AboutTheImageDependency: Dependency {
    var likeManager: LikeManager { get }
}

final class AboutTheImageBuilder: Component<AboutTheImageDependency> {
    func getViewController(with imageInfo: ImageInfo) -> UIViewController {
        return AboutTheImageViewController(viewModel: getViewModel(with: imageInfo))
    }
    
    private func getViewModel(with imageInfo: ImageInfo) -> AboutTheImageViewModel {
        return AboutTheImageDefaultViewModel(likeManager: dependency.likeManager, image: imageInfo)
    }
}
