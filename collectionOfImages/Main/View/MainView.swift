import Foundation
import UIKit
import SnapKit

final class MainView: BaseView {
    private let collectionFlowLayout = UICollectionViewFlowLayout()
    private var dataSource: CollectionOfImageAdapter
    private var collectionView: UICollectionView
    
    private let button = UIButton()
    private var action: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
        dataSource = CollectionOfImageAdapter(collectionView)
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func setupUI() {
        backgroundColor = .white
        setupCollectionView()
    }
    
    func updateUI(with model: CollectionOfImages) {
        dataSource.update(with: model)
    }
}

extension MainView {
    func setupActions(_ action: @escaping (Int) -> Void) {
        self.action = action
    }
}

private extension MainView {
    func setupCollectionView() {
        collectionView.delegate = self
        collectionFlowLayout.minimumLineSpacing = 5.scaled
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.itemSize = CGSize(width: 358.scaled, height: 100.scaled)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            ImageCell.self,
            forCellWithReuseIdentifier: ImageCell.identifier
        )
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview().inset(16.scaled)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        action?(indexPath.row)
    }
}
