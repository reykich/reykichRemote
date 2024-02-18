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
            let collectionOfImageResponse = CollectionOfImageResponse(
                albumId: image.albumId,
                id: image.id,
                title: image.title,
                url: image.fullSizeImageUrl,
                thumbnailUrl: image.imageUrl
            )
            
            likeManager.handleLike(with: collectionOfImageResponse)
            isLikedSubject.send(checkIsLiked(with: image.id))
        }
    }
}

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
