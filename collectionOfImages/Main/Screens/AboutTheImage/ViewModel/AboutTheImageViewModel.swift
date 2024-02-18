import Foundation
import Combine

protocol AboutTheImageViewModel: AnyObject {
    var aboutTheImage: AnyPublisher<AboutTheImage, Never> { get }
    var isLiked: AnyPublisher<Bool, Never> { get }
    func viewDidLoad()
    func processLike()
}
