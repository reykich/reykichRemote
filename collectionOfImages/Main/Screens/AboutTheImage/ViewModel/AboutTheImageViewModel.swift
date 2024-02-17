import Foundation
import Combine

protocol AboutTheImageViewModel: AnyObject {
    var aboutTheImage: AnyPublisher<AboutTheImage, Never> { get }
}
