import Foundation
import Combine

protocol MainViewModel: AnyObject {
    var collectionOfImages: AnyPublisher<CollectionOfImages, Never> { get }
    var collectionOfImageResponse: AnyPublisher<CollectionOfImageResponse, Never> { get }
    func viewViewAppear()
    func selectAboutTheImage(with index: Int)
    func processLike(with index: Int)
}
