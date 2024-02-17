import Foundation
import UIKit

final class AsyncImage: UIImageView {
    private let operationQueue = OperationQueue()
    
    func setImage(with stringURL: String) {
        
        let asyncImageLoadOperation = AsyncImageLoadOperation(with: stringURL)
        asyncImageLoadOperation.completionBlock = { [weak self] in
            OperationQueue.main.addOperation { [weak self] in
                self?.image = asyncImageLoadOperation.image
            }
        }
        operationQueue.addOperation(asyncImageLoadOperation)
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}
