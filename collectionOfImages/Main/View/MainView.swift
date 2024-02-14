import Foundation
import UIKit
import SnapKit

final class MainView: BaseView {
    private let button = UIButton()
    private var action: EmptyClosure?
    
    override func setupUI() {
        backgroundColor = .gray
        setupButton()
    }
}

extension MainView {
    func setupActions(_ action: @escaping EmptyClosure) {
        self.action = action
    }
}

private extension MainView {
    func setupButton() {
        button.frame = CGRect(x: 200, y: 200, width: 150, height: 50)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        addSubview(button)
    }
    
    @objc func didTap() {
        action?()
    }
}
