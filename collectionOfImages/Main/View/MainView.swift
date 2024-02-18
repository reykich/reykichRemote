import Foundation
import UIKit
import SnapKit

final class MainView: BaseView {
    private let headerView = HeaderView()
    private let collectionFlowLayout = UICollectionViewFlowLayout()
    private let dataSource: CollectionOfImageAdapter
    private let collectionView: UICollectionView
    private let scrollToTopButton = UIButton()
    private let placeholder = UILabel()
    
    private var action: ((Int) -> Void)?
    private var scrollToTopAction: EmptyClosure?
    
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
        setupHeaderView()
        setupCollectionView()
        setupScrollToTopButton()
        setupPlaceholder()
    }
    
    func updateUI(with model: CollectionOfImages) {
        dataSource.update(with: model)
    }
    
    func updateFavoriteImage(with isFavorite: Bool) {
        headerView.updateUI(with: isFavorite)
    }
    
    func scrollToTop() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    func updateShowPlaceholder(with showPlaceholder: Bool) {
        collectionView.isHidden = showPlaceholder
        placeholder.isHidden = !showPlaceholder
    }
}

//MARK: - Setup Action
extension MainView {
    func setupActions(_ action: @escaping (Int) -> Void) {
        self.action = action
    }
    
    func setupScrollToTopAction(_ action: @escaping EmptyClosure) {
        self.scrollToTopAction = action
    }
    
    func setupLikeAction(_ action: @escaping (Int) -> Void) {
        dataSource.setupLikeAction(action)
    }
    
    func setupFavoriteAction(_ action: @escaping EmptyClosure) {
        headerView.setupAction(action)
    }
    
    func setupTextFieldChangedAction(_ action: @escaping (String) -> Void) {
        headerView.setupChangedAction(action)
    }
}

//MARK: - Private Extension
private extension MainView {
    func setupHeaderView() {
        addSubview(headerView)
        
        headerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(40.scaled)
        }
    }
    
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
            $0.top.equalTo(headerView.snp.bottom)
            $0.left.right.equalToSuperview().inset(16.scaled)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupScrollToTopButton() {
        scrollToTopButton.isHidden = true
        scrollToTopButton.backgroundColor = .white
        scrollToTopButton.layer.cornerRadius = 15.scaled
        scrollToTopButton.layer.borderWidth = 1
        scrollToTopButton.layer.borderColor = R.color.black()!.cgColor
        scrollToTopButton.setImage(R.image.arrowUp(), for: .normal)
        scrollToTopButton.addTarget(self, action: #selector(didTapScrollToTopButton), for: .touchUpInside)
        addSubview(scrollToTopButton)
        
        scrollToTopButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(30.scaled)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(50.scaled)
            $0.size.equalTo(30.scaled)
        }
    }
    
    func setupPlaceholder() {
        placeholder.isHidden = true
        placeholder.textAlignment = .center
        placeholder.lineBreakMode = .byWordWrapping
        placeholder.numberOfLines = 0
        placeholder.text = R.string.localizable.mainScreenPlaceholder()
        placeholder.font = R.font.manropeSemiBold(size: 22.scaled)
        placeholder.textColor = R.color.black()
        addSubview(placeholder)
        
        placeholder.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func didTapScrollToTopButton() {
        scrollToTopAction?()
    }
}

extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        action?(indexPath.row)
    }
}

extension MainView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y > 0 else {
            scrollToTopButton.isHidden = true
            return
        }
        scrollToTopButton.isHidden = false
    }
}
