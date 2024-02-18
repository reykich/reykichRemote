import Foundation
import Combine

protocol MainViewModel: AnyObject {
    var collectionOfImages: AnyPublisher<CollectionOfImages, Never> { get }
    var aboutTheImage: AnyPublisher<ImageInfo, Never> { get }
    var isFavorite: AnyPublisher<Bool, Never> { get }
    var favoritePlaceholderEnabled: AnyPublisher<Bool, Never> { get }
    func viewViewAppear()
    func selectAboutTheImage(with id: Int)
    func processLike(with id: Int)
    func updateFavoritesDisplay()
    func search(with text: String)
}
