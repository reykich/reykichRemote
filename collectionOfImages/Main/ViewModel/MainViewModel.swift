import Foundation
import Combine

protocol MainViewModel: AnyObject {
    var collectionOfImages: AnyPublisher<CollectionOfImages, Never> { get }
    var aboutTheImage: AnyPublisher<AboutTheImage, Never> { get }
    func viewViewAppear()
    func selectAboutTheImage(with index: Int)
    func processLike(with index: Int)
}
