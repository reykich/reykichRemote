import Foundation
import Combine

protocol MainViewModel: AnyObject {
    var collectionOfImages: AnyPublisher<CollectionOfImages, Never> { get }
    func viewDidLoad()
}
