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
        viewModel.viewDidLoad()
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
            self?.router.openAboutTheImageScreen()
        }
    }
    
    func configureBindings() {
        viewModel.collectionOfImages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] collectionOfImages in
                self?.contentView.updateUI(with: collectionOfImages)
            }
            .store(in: &cancellableSet)
    }
}

