import Foundation
import RealmSwift

class LikeImageObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var albumId: Int
    @Persisted var title: String
    @Persisted var url: String
    @Persisted var thumbnailUrl: String
}
