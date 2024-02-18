import Foundation
import RealmSwift

final class DefaultLikeManager {
    private let realm: Realm?
    
    init() {
        realm = try? Realm(queue: .main)
    }
}

extension DefaultLikeManager: LikeManager {
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
    @MainActor
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
    
    @MainActor
    func deleteObject(with likeImage: LikeImageObject) {
        do {
            try realm?.write {
                realm?.delete(likeImage)
            }
        } catch {
            print("Catched Realm error: \(error)")
        }
    }
    
    @MainActor
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
