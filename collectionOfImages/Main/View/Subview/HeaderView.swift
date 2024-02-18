import Foundation
import SnapKit
import UIKit

final class HeaderView: BaseView {
    private let like = UIButton()
    private let title = UILabel()
    
    private var action: EmptyClosure?
    
    override func setupUI() {
        setupLike()
        setupTitle()
    }
    
    func updateUI(with isFavorite: Bool) {
        like.setImage(isFavorite ? R.image.like() : R.image.notLike(), for: .normal)
    }
}

//MARK: - Setup Action
extension HeaderView {
    func setupAction(_ action: @escaping EmptyClosure) {
        self.action = action
    }
}

//MARK: - Private Extension
private extension HeaderView {
    func setupLike() {
        like.setImage(R.image.notLike(), for: .normal)
        like.addTarget(self, action: #selector(likeDidTap), for: .touchUpInside)
        addSubview(like)
        
        like.snp.makeConstraints {
            $0.right.equalToSuperview().inset(15.scaled)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(35.scaled)
        }
    }
    
    func setupTitle() {
        title.text = R.string.localizable.mainScreenShowFavorites()
        title.font = R.font.manropeSemiBold(size: 18.scaled)
        title.textColor = R.color.black()
        title.textAlignment = .right
        addSubview(title)
        
        title.snp.makeConstraints {
            $0.right.equalTo(like.snp.left).offset(-15.scaled)
            $0.centerY.equalToSuperview()
        }
    }
    
    @objc func likeDidTap() {
        action?()
    }
}
