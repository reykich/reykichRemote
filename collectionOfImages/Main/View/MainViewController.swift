import UIKit

class MainViewController: BaseViewController<MainView> {
    private let router: MainRouter
    private let viewModel: MainViewModel
    
    init(router: MainRouter,
         viewModel: MainViewModel) {
        self.router = router
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
}

private extension MainViewController {
    func setupActions() {
        contentView.setupActions { [weak self] index in
            self?.router.openAboutTheImageScreen()
        }
    }
}

