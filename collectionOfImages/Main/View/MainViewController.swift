import UIKit
import Combine

class MainViewController: BaseViewController<MainView> {
    private let router: MainRouter
    private let viewModel: MainViewModel
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(router: MainRouter,
         viewModel: MainViewModel) {
        self.router = router
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewViewAppear()
    }
    
    deinit {
        cancellableSet.forEach { anyCancellable in
            anyCancellable.cancel()
        }
    }
}

private extension MainViewController {
    func setupActions() {
        contentView.setupActions { [weak self] index in
            self?.viewModel.selectAboutTheImage(with: index)
        }
        
        contentView.setupScrollToTopAction { [weak self] in
            self?.contentView.scrollToTop()
        }
        
        contentView.setupLikeAction { [weak self] index in
            self?.viewModel.processLike(with: index)
        }
        
        contentView.setupFavoriteAction { [weak self] in
            self?.viewModel.updateFavoritesDisplay()
        }
    }
    
    func configureBindings() {
        viewModel.collectionOfImages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] collectionOfImages in
                self?.contentView.updateUI(with: collectionOfImages)
            }
            .store(in: &cancellableSet)
        viewModel.collectionOfImageResponse
            .receive(on: DispatchQueue.main)
            .sink { [weak self] collectionOfImage in
                self?.router.openAboutTheImageScreen(with: collectionOfImage)
            }
            .store(in: &cancellableSet)
        viewModel.isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                self?.contentView.updateFavoriteImage(with: isFavorite)
            }
            .store(in: &cancellableSet)
        
        viewModel.favoritePlaceholderEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] placeholderEnabled in
                self?.contentView.updateShowPlaceholder(with: placeholderEnabled)
            }
            .store(in: &cancellableSet)
    }
}

