import Foundation
import Combine

final class DefaultMainViewModel {
    private let likeManager: LikeManager
    private var images: [CollectionOfImageResponse]?
    private var likeImages: [LikeImageObject]?
    private let collectionOfImagesSubject = PassthroughSubject<CollectionOfImages, Never>()
    private let collectionOfImageResponseSubject = PassthroughSubject<CollectionOfImageResponse, Never>()
    private let isFavoriteSubject = CurrentValueSubject<Bool, Never>(false)
    private let favoritePlaceholderEnabledSubject = PassthroughSubject<Bool, Never>()
    
    
    init(likeManager: LikeManager) {
        self.likeManager = likeManager
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
                await updateLikeImages()
                guard let images = images else {
                    try loadImages()
                    return
                }
                guard !isFavoriteSubject.value else {
                    await showFavorites()
                    return
                }
                let collectionOfImage = await convertToImageCollection(with: images)
                collectionOfImagesSubject.send(collectionOfImage)
            } catch {
                print(error)
            }
        }
    }
    
    func selectAboutTheImage(with index: Int) {
        guard let images else { return }
        Task { @MainActor in
            let image = images[index]
            collectionOfImageResponseSubject.send(image)
        }
    }
    
    func processLike(with index: Int) {
        Task { @MainActor in
            guard let images else { return }
            likeManager.handleLike(with: images[index])
            updateLikeImages()
            guard !isFavoriteSubject.value else {
                showFavorites()
                return
            }
            let collectionOfImage = convertToImageCollection(with: images)
            collectionOfImagesSubject.send(collectionOfImage)
        }
    }
    
    func updateFavoritesDisplay() {
        Task { @MainActor in
            guard isFavoriteSubject.value else {
                showFavorites()
                return
            }
            hideFavorites()
        }
    }
}

private extension DefaultMainViewModel {
    func loadImages() throws {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return }
        Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            let collectionOfImageResponse = try JSONDecoder().decode(
                [CollectionOfImageResponse].self,
                from: data
            )
            self.images = collectionOfImageResponse
            let collectionOfImage = await convertToImageCollection(with: collectionOfImageResponse)
            collectionOfImagesSubject.send(collectionOfImage)
        }
    }
    
    @MainActor
    func showFavorites() {
        guard let likeImages = likeImageConvertToImageCollection(), likeImages.imagesInfo.count > 0 else {
            isFavoriteSubject.send(true)
            favoritePlaceholderEnabledSubject.send(true)
            return
        }
        isFavoriteSubject.send(true)
        collectionOfImagesSubject.send(likeImages)
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
    func updateLikeImages() {
        guard let likeImages = likeManager.getLikeImages() else {
            return
        }
        self.likeImages = likeImages
    }
    
    @MainActor
    func checkIsLiked(with id: Int) -> Bool {
        guard let likeImages = likeImages else {
            return false
        }
        return likeImages.contains { $0.id == id }
    }
}

struct CollectionOfImageResponse: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

struct AboutTheImage {
    let id: Int
    let url: String
    let title: String
    let isLiked: Bool
}
