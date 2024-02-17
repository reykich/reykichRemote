import Foundation
import Combine

final class DefaultMainViewModel {
    private let likeManager: LikeManager
    private var images: [CollectionOfImageResponse]?
    private var likeImages: [LikeImageObject]?
    private let collectionOfImagesSubject = PassthroughSubject<CollectionOfImages, Never>()
    private let aboutTheImageSubject = PassthroughSubject<AboutTheImage, Never>()
    
    init(likeManager: LikeManager) {
        self.likeManager = likeManager
    }
}

extension DefaultMainViewModel: MainViewModel {
    var collectionOfImages: AnyPublisher<CollectionOfImages, Never> {
        collectionOfImagesSubject.eraseToAnyPublisher()
    }
    
    var aboutTheImage: AnyPublisher<AboutTheImage, Never> {
        aboutTheImageSubject.eraseToAnyPublisher()
    }
    
    func viewViewAppear() {
        Task {
            do {
                await updateLikeImages()
                guard let images = images else {
                    try loadImages()
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
        let image = images[index]
        aboutTheImageSubject.send(AboutTheImage(id: image.id, url: image.url, title: image.title))
    }
    
    func processLike(with index: Int) {
        Task { @MainActor in
            guard let images else { return }
            likeManager.handleLike(with: images[index])
            updateLikeImages()
            let collectionOfImage = convertToImageCollection(with: images)
            collectionOfImagesSubject.send(collectionOfImage)
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
}
