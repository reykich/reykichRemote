import Foundation
import UIKit
final class CollectionOfImageAdapter {
    typealias CollectionOfImageDataSource = UICollectionViewDiffableDataSource<Section, ImageInfo>
    
    private let collectionView: UICollectionView
    private var dataSource: CollectionOfImageDataSource?
    
    private var likeAction: ((Int) -> Void)?
    
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.dataSource = createDataSource()
    }
    
    func update(with collectionOfImages: CollectionOfImages) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.deleteAllItems()
        snapshot.appendSections([collectionOfImages.section])
        snapshot.appendItems(collectionOfImages.imagesInfo, toSection: collectionOfImages.section)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

//MARK: - Setup Action
extension CollectionOfImageAdapter {
    func setupLikeAction(_ action: @escaping (Int) -> Void) {
        self.likeAction = action
    }
}

//MARK: - Private Extension
private extension CollectionOfImageAdapter {
    func createDataSource() -> CollectionOfImageDataSource {
        let dataSource = CollectionOfImageDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, imageInfo in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ImageCell.identifier,
                    for: indexPath) as? ImageCell else {
                    assertionFailure()
                    return UICollectionViewCell()
                }
                cell.updateUI(with: imageInfo)
                cell.setupAction { [weak self] id in
                    self?.likeAction?(id)
                }
                return cell
            })
        return dataSource
    }
}

extension CollectionOfImageAdapter {
    enum Section: Int {
        case main
    }
}

struct CollectionOfImages: Hashable {
    let section: CollectionOfImageAdapter.Section
    let imagesInfo: [ImageInfo]
}

struct ImageInfo: Hashable {
    let id: Int
    let albumId: Int
    let imageUrl: String
    let fullSizeImageUrl: String
    let title: String
    let isLiked: Bool
}
