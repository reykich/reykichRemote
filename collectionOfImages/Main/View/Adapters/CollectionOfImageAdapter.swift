import Foundation
import UIKit
final class CollectionOfImageAdapter {
    typealias CollectionOfImageDataSource = UICollectionViewDiffableDataSource<Section, ImageInfo>
    
    private let collectionView: UICollectionView
    private var dataSource: CollectionOfImageDataSource?
    
    private var action: EmptyClosure?
    
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

private extension CollectionOfImageAdapter {
    func createDataSource() -> CollectionOfImageDataSource {
        let dataSource = CollectionOfImageDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, imageInfo in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ImageCell.identifier,
                    for: indexPath) as? ImageCell else {
                    assertionFailure()
                    return UICollectionViewCell()
                }
                cell.updateUI(with: imageInfo)
                cell.layer.cornerRadius = 5
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
    let imageUrl: String
    let title: String
}
