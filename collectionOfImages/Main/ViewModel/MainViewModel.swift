import Foundation
import Combine

protocol MainViewModel: AnyObject {
    var collectionOfImages: AnyPublisher<CollectionOfImages, Never> { get }
    var aboutTheImage: AnyPublisher<AboutTheImage, Never> { get }
    func viewDidLoad()
    func selectAboutTheImage(with index: Int)
}
