import Foundation
import Combine

final class AboutTheImageDefaultViewModel {
    private let aboutTheImageSubject: CurrentValueSubject<AboutTheImage, Never>
    
    init(aboutTheImage: AboutTheImage) {
        aboutTheImageSubject = CurrentValueSubject<AboutTheImage, Never>(aboutTheImage)
    }
}

extension AboutTheImageDefaultViewModel: AboutTheImageViewModel {
    var aboutTheImage: AnyPublisher<AboutTheImage, Never> {
        aboutTheImageSubject.eraseToAnyPublisher()
    }
}
