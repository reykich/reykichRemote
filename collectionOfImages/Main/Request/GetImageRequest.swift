import Foundation

protocol GetImageRequest: AnyObject {
    func getImages() async throws -> [CollectionOfImageResponse]
}
