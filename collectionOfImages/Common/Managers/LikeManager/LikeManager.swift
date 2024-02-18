import Foundation
import RealmSwift

protocol LikeManager: AnyObject {
    @MainActor
    func handleLike(with image: ImageInfo)
    @MainActor
    func getLikeImages() -> [LikeImageObject]?
    @MainActor
    func getLikeObject(with id: Int) -> LikeImageObject?
}
