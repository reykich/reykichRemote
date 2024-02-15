import Foundation
import Combine

final class DefaultMainViewModel {
    private var photos: [CollectionOfImageResponse]?
    private let collectionOfImagesSubject = PassthroughSubject<CollectionOfImages, Never>()
}

extension DefaultMainViewModel: MainViewModel {
    var collectionOfImages: AnyPublisher<CollectionOfImages, Never> {
        collectionOfImagesSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let collectionOfImageResponse = try JSONDecoder().decode(
                    [CollectionOfImageResponse].self,
                    from: data
                )
                self.photos = collectionOfImageResponse
                let collectionOfImage = convertToImageCollection(with: collectionOfImageResponse)
                collectionOfImagesSubject.send(collectionOfImage)
            } catch {
                print(error)
            }
        }
    }
}

private extension DefaultMainViewModel {
    func convertToImageCollection(with model: [CollectionOfImageResponse]) -> CollectionOfImages {
        let imagesInfo = model.map { collectionOfImageResponse in
            return ImageInfo(
                imageUrl: collectionOfImageResponse.thumbnailUrl,
                title: collectionOfImageResponse.title
            )
        }
        return CollectionOfImages(section: .main, imagesInfo: imagesInfo)
    }
}

struct CollectionOfImageResponse: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
