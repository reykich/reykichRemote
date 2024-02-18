import Foundation
import NeedleFoundation

protocol AboutTheImageDependency: Dependency {
    var likeManager: LikeManager { get }
}

final class AboutTheImageBuilder: Component<AboutTheImageDependency> {
    func getViewController(with collectionOfImage: CollectionOfImageResponse) -> UIViewController {
        return AboutTheImageViewController(viewModel: getViewModel(with: collectionOfImage))
    }
    
    private func getViewModel(with collectionOfImage: CollectionOfImageResponse) -> AboutTheImageViewModel {
        return AboutTheImageDefaultViewModel(likeManager: dependency.likeManager, image: collectionOfImage)
    }
}
