import Foundation
import UIKit
import SnapKit

final class ImageCell: UICollectionViewCell {
    private let image = UIImageView()
    private let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    func updateUI(with model: ImageInfo) {
//        image.image = model.image
        title.text = model.title
    }
}

private extension ImageCell {
    func setupUI() {
        setupImage()
        setupTitle()
    }
    
    func setupImage() {
        contentView.addSubview(image)
        
        image.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(16.scaled)
            $0.width.equalTo(60.scaled)
        }
    }
    
    func setupTitle() {
        title.font = R.font.manropeRegular(size: 16.scaled)
        title.textColor = R.color.black()
        contentView.addSubview(title)
        
        title.snp.makeConstraints {
            $0.left.equalTo(image.snp.right).offset(12.scaled)
            $0.centerY.equalToSuperview()
        }
    }
}
