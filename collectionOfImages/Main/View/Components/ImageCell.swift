import Foundation
import UIKit
import SnapKit

final class ImageCell: UICollectionViewCell {
    private let image = AsyncImage()
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
    
    override func prepareForReuse() {
        image.cancel()
    }
    
    func updateUI(with model: ImageInfo) {
        image.setImage(with: model.imageUrl)
        title.text = model.title
    }
}

private extension ImageCell {
    func setupUI() {
        backgroundColor = R.color.gray()
        setupImage()
        setupTitle()
    }
    
    func setupImage() {
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        contentView.addSubview(image)
        
        image.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(5.scaled)
            $0.width.equalTo(90.scaled)
        }
    }
    
    func setupTitle() {
        title.font = R.font.manropeRegular(size: 16.scaled)
        title.textColor = R.color.black()
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        contentView.addSubview(title)
        
        title.snp.makeConstraints {
            $0.left.equalTo(image.snp.right).offset(12.scaled)
            $0.right.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(10.scaled)
        }
    }
}
