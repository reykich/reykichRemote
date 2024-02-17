import Foundation
import UIKit
import Combine

final class AboutTheImageViewController: BaseViewController<AboutTheImageView> {
    private let viewModel: AboutTheImageViewModel
    private var cancellableSet: Set<AnyCancellable> = []
    override var navBarIsHidden: Bool { false }
    
    init(viewModel: AboutTheImageViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
    }
    
    deinit {
        cancellableSet.forEach { anyCancellable in
            anyCancellable.cancel()
        }
    }
}

private extension AboutTheImageViewController {
    func configureBindings() {
        viewModel.aboutTheImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] aboutTheImage in
                self?.contentView.updateUI(with: aboutTheImage)
            }
            .store(in: &cancellableSet)
    }
}
