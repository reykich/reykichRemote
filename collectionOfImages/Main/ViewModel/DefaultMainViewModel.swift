import Foundation
import Combine

final class DefaultMainViewModel {
    private let likeManager: LikeManager
    private let getImageRequest: GetImageRequest
    private var images: [CollectionOfImageResponse]?
    private var likeImages: [LikeImageObject]?
    private let collectionOfImagesSubject = PassthroughSubject<CollectionOfImages, Never>()
    private let collectionOfImageResponseSubject = PassthroughSubject<CollectionOfImageResponse, Never>()
    private let isFavoriteSubject = CurrentValueSubject<Bool, Never>(false)
    private let favoritePlaceholderEnabledSubject = PassthroughSubject<Bool, Never>()
    
    
    init(likeManager: LikeManager,
         getImageRequest: GetImageRequest) {
        self.likeManager = likeManager
        self.getImageRequest = getImageRequest
    }
}

extension DefaultMainViewModel: MainViewModel {
    var collectionOfImages: AnyPublisher<CollectionOfImages, Never> {
        collectionOfImagesSubject.eraseToAnyPublisher()
    }
    
    var collectionOfImageResponse: AnyPublisher<CollectionOfImageResponse, Never> {
        collectionOfImageResponseSubject.eraseToAnyPublisher()
    }
    
    var isFavorite: AnyPublisher<Bool, Never> {
        isFavoriteSubject.eraseToAnyPublisher()
    }
    
    var favoritePlaceholderEnabled: AnyPublisher<Bool, Never> {
        favoritePlaceholderEnabledSubject.eraseToAnyPublisher()
    }
    
    func viewViewAppear() {
        Task {
            do {
                await checkActualLikeImages()
                guard let images = images else {
                    try loadImages()
                    return
                }
                
                if isFavoriteSubject.value {
                    await showFavorites()
                } else {
                    let collectionOfImage = await convertToImageCollection(with: images)
                    collectionOfImagesSubject.send(collectionOfImage)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func selectAboutTheImage(with index: Int) {
        Task { @MainActor in
            if isFavoriteSubject.value, let image = getImageByTappingOnFavorites(with: index) {
                collectionOfImageResponseSubject.send(image)
            } else {
                guard let images else { return }
                collectionOfImageResponseSubject.send(images[index])
            }
        }
    }
    
    func processLike(with index: Int) {
        Task { @MainActor in
            guard let images else { return }
            likeManager.handleLike(with: images[index])
            checkActualLikeImages()
            if isFavoriteSubject.value {
                showFavorites()
            } else {
                let collectionOfImage = convertToImageCollection(with: images)
                collectionOfImagesSubject.send(collectionOfImage)
            }
        }
    }
    
    func updateFavoritesDisplay() {
        Task { @MainActor in
            if isFavoriteSubject.value {
                hideFavorites()
            } else {
                showFavorites()
            }
        }
    }
}

private extension DefaultMainViewModel {
    func loadImages() throws {
        Task {
            let collectionOfImageResponse = try await getImageRequest.getImages()
            self.images = collectionOfImageResponse
            let collectionOfImage = await convertToImageCollection(with: collectionOfImageResponse)
            collectionOfImagesSubject.send(collectionOfImage)
        }
    }
    
    @MainActor
    func showFavorites() {
        if let likeImages = likeImageConvertToImageCollection(),
           likeImages.imagesInfo.count > 0 {
            isFavoriteSubject.send(true)
            collectionOfImagesSubject.send(likeImages)
        } else {
            isFavoriteSubject.send(true)
            favoritePlaceholderEnabledSubject.send(true)
        }
    }
    
    @MainActor
    func hideFavorites() {
        Task { @MainActor in
            guard let images else { return }
            let collectionOfImage = convertToImageCollection(with: images)
            favoritePlaceholderEnabledSubject.send(false)
            isFavoriteSubject.send(false)
            collectionOfImagesSubject.send(collectionOfImage)
        }
    }
    
    @MainActor
    func convertToImageCollection(with model: [CollectionOfImageResponse]) -> CollectionOfImages {
        let imagesInfo = model.map { collectionOfImageResponse in
            return ImageInfo(
                imageUrl: collectionOfImageResponse.thumbnailUrl,
                title: collectionOfImageResponse.title,
                isLiked: checkIsLiked(with: collectionOfImageResponse.id)
            )
        }
        return CollectionOfImages(section: .main, imagesInfo: imagesInfo)
    }
    
    @MainActor
    func likeImageConvertToImageCollection() -> CollectionOfImages? {
        guard let likeImages else { return nil }
        let collectionOfImages = likeImages.map { likeImageObject in
            return ImageInfo(
                imageUrl: likeImageObject.thumbnailUrl,
                title: likeImageObject.title,
                isLiked: true
            )
        }
        return CollectionOfImages(section: .main, imagesInfo: collectionOfImages)
    }
    
    @MainActor
    func checkActualLikeImages() {
        guard let likeImages = likeManager.getLikeImages() else { return }
        self.likeImages = likeImages
    }
    
    @MainActor
    func checkIsLiked(with id: Int) -> Bool {
        guard let likeImages = likeImages else { return false }
        return likeImages.contains { $0.id == id }
    }
    
    @MainActor
    func getImageByTappingOnFavorites(with index: Int) -> CollectionOfImageResponse? {
        guard let imageId = likeImages?[index].id, let images else { return nil }
        return images.first(where: { $0.id == imageId })
    }
}

struct AboutTheImage {
    let id: Int
    let url: String
    let title: String
    let isLiked: Bool
}
