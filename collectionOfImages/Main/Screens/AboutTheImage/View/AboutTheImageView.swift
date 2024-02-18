import Foundation
import UIKit
import SnapKit

final class AboutTheImageView: BaseView {
    private let image = AsyncImage()
    private let title = UILabel()
    private let like = UIButton()
    
    private var action: EmptyClosure?
    
    override func setupUI() {
        backgroundColor = .white
        setupImage()
        setupTitle()
        setupLike()
    }
    
    func updateUI(with model: AboutTheImage) {
        image.setImage(with: model.url)
        title.text = model.title
        like.setImage(model.isLiked ? R.image.like() : R.image.notLike(), for: .normal)
    }
    
    func updateLike(with isLiked: Bool) {
        like.setImage(isLiked ? R.image.like() : R.image.notLike(), for: .normal)
    }
}

//MARK: - Setup Actions
extension AboutTheImageView {
    func setupAction(_ action: @escaping EmptyClosure) {
        self.action = action
    }
}

//MARK: - Private Extension
private extension AboutTheImageView {
    func setupImage() {
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        addSubview(image)
        
        image.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(20.scaled)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(300.scaled)
        }
    }
    
    func setupTitle() {
        title.font = R.font.manropeSemiBold(size: 18.scaled)
        title.textColor = R.color.black()
        title.textAlignment = .center
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        addSubview(title)
        
        title.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).offset(30.scaled)
            $0.left.right.equalToSuperview().inset(40.scaled)
            $0.height.equalTo(100.scaled)
        }
    }
    
    func setupLike() {
        like.setImage(R.image.notLike(), for: .normal)
        like.addTarget(self, action: #selector(likeDidTap), for: .touchUpInside)
        addSubview(like)
        
        like.snp.makeConstraints {
            $0.top.equalTo(image.snp.top).inset(15.scaled)
            $0.right.equalTo(image.snp.right).inset(15.scaled)
            $0.size.equalTo(20.scaled)
        }
    }
    
    @objc func likeDidTap() {
        action?()
    }
}
