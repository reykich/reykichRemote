import Foundation
import Kingfisher

final class ImageCacheManager {
    static let config = MemoryStorage.Config(totalCostLimit: 150000)
    static let cache = ImageCache.default
    
    static func saveImage(by image: UIImage, and key: String) {
        cache.memoryStorage.store(value: image, forKey: key)
    }
    
    static func getImage(with stringUrl: String) -> UIImage? {
        guard cache.isCached(forKey: stringUrl) else { return nil }
        return cache.retrieveImageInMemoryCache(forKey: stringUrl, options: .none)
    }
}
