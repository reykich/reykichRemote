import Foundation
import Combine

protocol MainViewModel: AnyObject {
    var collectionOfImages: AnyPublisher<CollectionOfImages, Never> { get }
    var aboutTheImage: AnyPublisher<ImageInfo, Never> { get }
    var isFavorite: AnyPublisher<Bool, Never> { get }
    var favoritePlaceholderEnabled: AnyPublisher<Bool, Never> { get }
    func viewViewAppear()
    func selectAboutTheImage(with index: Int)
    func processLike(with index: Int)
    func updateFavoritesDisplay()
    func search(with text: String)
}
