import Foundation
import UIKit
import Combine

final class AboutTheImageViewController: BaseViewController<AboutTheImageView> {
    private let viewModel: AboutTheImageViewModel
    private var cancellableSet: Set<AnyCancellable> = []
    override var navBarIsHidden: Bool { false }
    override var isAnimated: Bool { false }
    
    init(viewModel: AboutTheImageViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
        configureBindings()
        viewModel.viewDidLoad()
    }
    
    deinit {
        cancellableSet.forEach { anyCancellable in
            anyCancellable.cancel()
        }
    }
}

private extension AboutTheImageViewController {
    func setupAction() {
        contentView.setupAction { [weak self] in
            self?.viewModel.processLike()
        }
    }
    
    func configureBindings() {
        viewModel.aboutTheImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] aboutTheImage in
                self?.contentView.updateUI(with: aboutTheImage)
            }
            .store(in: &cancellableSet)
        viewModel.isLiked
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLiked in
                self?.contentView.updateLike(with: isLiked)
            }
            .store(in: &cancellableSet)
    }
}
