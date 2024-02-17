import Foundation
import UIKit

final class AsyncImage: UIImageView {
    private var loadTask: Task<Void, Never>? {
        didSet {
            oldValue?.cancel()
        }
    }
        
    func setImage(with stringURL: String) {
        self.image = R.image.placeholder()
        guard let url = URL(string: stringURL) else { return }
        loadTask = Task {
            do {
                let (imageData, _) = try await URLSession.shared.data(from: url)
                guard Task.isCancelled == false else { return }
                self.image = UIImage(data: imageData)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancel() {
        loadTask?.cancel()
    }
}
