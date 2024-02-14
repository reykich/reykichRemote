import Foundation
import UIKit

final class AboutTheImageViewController: BaseViewController<AboutTheImageView> {
    private let viewModel: AboutTheImageViewModel
    override var navBarIsHidden: Bool { false }
    
    init(viewModel: AboutTheImageViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
