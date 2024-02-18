import Foundation
import UIKit

final class AsyncImage: UIImageView {
    private var loadTask: Task<Void, Never>? {
        didSet {
            oldValue?.cancel()
        }
    }
        
    func setImage(with stringURL: String) {
        guard let image = ImageCacheManager.getImage(with: stringURL) else {
            downloadImage(with: stringURL)
            return
        }
        self.image = image
    }
    
    func cancel() {
        loadTask?.cancel()
    }
}

//MARK: - Private extension
private extension AsyncImage {
    func downloadImage(with stringURL: String) {
        self.image = R.image.placeholder()
        guard let url = URL(string: stringURL) else { return }
        loadTask = Task {
            do {
                let (imageData, _) = try await URLSession.shared.data(from: url)
                guard Task.isCancelled == false, let downloadImage = UIImage(data: imageData) else { return }
                self.image = downloadImage
                ImageCacheManager.saveImage(by: downloadImage, and: stringURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
