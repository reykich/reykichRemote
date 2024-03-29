import Foundation
import Combine

final class AboutTheImageDefaultViewModel {
    private let likeManager: LikeManager
    private var image: ImageInfo
    private let aboutTheImageSubject = PassthroughSubject<AboutTheImage, Never>()
    private let isLikedSubject = PassthroughSubject<Bool, Never>()
    
    init(likeManager: LikeManager, image: ImageInfo) {
        self.likeManager = likeManager
        self.image = image
    }
}

extension AboutTheImageDefaultViewModel: AboutTheImageViewModel {
    var aboutTheImage: AnyPublisher<AboutTheImage, Never> {
        aboutTheImageSubject.eraseToAnyPublisher()
    }
    
    var isLiked: AnyPublisher<Bool, Never> {
        isLikedSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        Task { @MainActor in
            aboutTheImageSubject.send(getAboutTheImage())
        }
    }
    
    func processLike() {
        Task { @MainActor in
            likeManager.handleLike(with: image)
            isLikedSubject.send(checkIsLiked(with: image.id))
        }
    }
}

//MARK: - Private Extension
private extension AboutTheImageDefaultViewModel {
    @MainActor
    func getAboutTheImage() -> AboutTheImage {
        return AboutTheImage(
            id: image.id,
            url: image.fullSizeImageUrl,
            title: image.title,
            isLiked: checkIsLiked(with: image.id)
        )
    }
    
    @MainActor
    func checkIsLiked(with id: Int) -> Bool {
        guard let likeImages = likeManager.getLikeImages() else {
            return false
        }
        return likeImages.contains { $0.id == id }
    }
}
