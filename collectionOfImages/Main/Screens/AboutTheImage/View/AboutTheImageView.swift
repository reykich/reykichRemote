import Foundation
import UIKit
import SnapKit

final class AboutTheImageView: BaseView {
    private let image = AsyncImage()
    private let title = UILabel()
    
    override func setupUI() {
        backgroundColor = .white
        setupImage()
        setupTitle()
    }
    
    func updateUI(with model: AboutTheImage) {
        image.setImage(with: model.url)
        title.text = model.title
    }
}

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
}
