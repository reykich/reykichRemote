import Foundation
import SnapKit

class BaseViewController<ContentView: BaseView>: UIViewController {
    let contentView: ContentView
    var navBarIsHidden: Bool {
        return true
    }
    
    init() {
        self.contentView = ContentView()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarLeftButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = navBarIsHidden
    }
    
    private func setupNavigationBarLeftButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(
            image: R.image.arrowBack()?.withTintColor(
                R.color.black()!,
                renderingMode: .alwaysOriginal
            ),
            style: .plain,
            target: self,
            action: #selector(tapBackButton))
    }
    
    @objc private func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
