import Foundation
import RealmSwift
import NeedleFoundation

protocol LikeManager: AnyObject {
    @MainActor
    func handleLike(with image: CollectionOfImageResponse)
    @MainActor
    func getLikeImages() -> [LikeImageObject]?
    @MainActor
    func getLikeObject(with id: Int) -> LikeImageObject?
}

final class DefaultLikeManager: LikeManager {
    private let realm: Realm?
    
    init() {
        realm = try? Realm(queue: .main)
    }
    
    @MainActor
    public func handleLike(with image: CollectionOfImageResponse) {
        guard let likeImage = getLikeObject(with: image.id) else {
            addObject(with: image)
            return
        }
        deleteObject(with: likeImage)
    }
    
    @MainActor
    public func getLikeObject(with id: Int) -> LikeImageObject? {
        return realm?.object(ofType: LikeImageObject.self, forPrimaryKey: id)
    }
    
    @MainActor
    public func getLikeImages() -> [LikeImageObject]? {
        guard let objects =  realm?.objects(LikeImageObject.self) else {
            print("ActiveAccountObject not found")
            return nil
        }
        var likeImages: [LikeImageObject] = []
        for object in objects {
            likeImages.append(object)
        }
        return likeImages
    }
}

private extension DefaultLikeManager {
    func addObject(with image: CollectionOfImageResponse) {
        let likeImage = createLikeImageObject(with: image)
        do {
            try realm?.write {
                realm?.add(likeImage, update: .modified)
            }
        } catch {
            print("Catched Realm error: \(error)")
        }
    }
    
    func deleteObject(with likeImage: LikeImageObject) {
        do {
            try realm?.write {
                realm?.delete(likeImage)
            }
        } catch {
            print("Catched Realm error: \(error)")
        }
    }
    
    func createLikeImageObject(with image: CollectionOfImageResponse) -> LikeImageObject {
        let likeImage = LikeImageObject()
        likeImage.id = image.id
        likeImage.albumId = image.albumId
        likeImage.url = image.url
        likeImage.title = image.title
        likeImage.thumbnailUrl = image.thumbnailUrl
        return likeImage
    }
}
