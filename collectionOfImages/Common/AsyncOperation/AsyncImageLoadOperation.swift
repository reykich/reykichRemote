import Foundation
import UIKit

class AsyncImageLoadOperation: AsyncOperation {
    var stringURL: String
    var image: UIImage?
    
    init(with stringURL: String) {
        self.stringURL = stringURL
        super.init()
    }
    
    override func main() {
        loadImage()
    }
}

private extension AsyncImageLoadOperation {
    func loadImage() {
        guard let url = URL(string: stringURL) else { return }
        Task {
            do {
                guard !isCancelled else { return }
                let (imageData, _) = try await URLSession.shared.data(from: url)
                
                guard !isCancelled else { return }
                image = UIImage(data: imageData)
                state = .finished
            } catch {
                print(error.localizedDescription)
                state = .finished
            }
        }
    }
}
