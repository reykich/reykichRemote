import Foundation
import Combine

final class DefaultMainViewModel {
    private let likeManager: LikeManager
    private let getImageRequest: GetImageRequest
    private var images: [CollectionOfImageResponse]?
    private var likeImages: [LikeImageObject]?
    private var imagesInfo: [ImageInfo]?
    private var searchText = ""
    
    private let collectionOfImagesSubject = PassthroughSubject<CollectionOfImages, Never>()
    private let aboutTheImageSubjet = PassthroughSubject<ImageInfo, Never>()
    private let isFavoriteSubject = CurrentValueSubject<Bool, Never>(false)
    private let favoritePlaceholderEnabledSubject = PassthroughSubject<Bool, Never>()
    
    
    init(likeManager: LikeManager,
         getImageRequest: GetImageRequest) {
        self.likeManager = likeManager
        self.getImageRequest = getImageRequest
    }
}

extension DefaultMainViewModel: MainViewModel {
    var collectionOfImages: AnyPublisher<CollectionOfImages, Never> {
        collectionOfImagesSubject.eraseToAnyPublisher()
    }
    
    var aboutTheImage: AnyPublisher<ImageInfo, Never> {
        aboutTheImageSubjet.eraseToAnyPublisher()
    }
    
    var isFavorite: AnyPublisher<Bool, Never> {
        isFavoriteSubject.eraseToAnyPublisher()
    }
    
    var favoritePlaceholderEnabled: AnyPublisher<Bool, Never> {
        favoritePlaceholderEnabledSubject.eraseToAnyPublisher()
    }
    
    func viewViewAppear() {
        Task {
            do {
                await checkActualLikeImages()
                guard let images = images else {
                    try loadImages()
                    return
                }
                
                if isFavoriteSubject.value, !searchText.isEmpty {
                    await searchLikedImages(with: searchText)
                } else if isFavoriteSubject.value {
                    await showFavorites()
                } else if !searchText.isEmpty {
                    await search(with: searchText)
                } else {
                    collectionOfImagesSubject.send(
                        CollectionOfImages(
                            section: .main,
                            imagesInfo: imagesInfo ?? []
                        )
                    )
                }
            } catch {
                print(error)
            }
        }
    }
    
    func selectAboutTheImage(with index: Int) {
        Task { @MainActor in
            if isFavoriteSubject.value, let image = getImageByTappingOnFavorites(with: index) {
                print(image)
                aboutTheImageSubjet.send(image)
            } else {
                guard let imagesInfo else { return }
                aboutTheImageSubjet.send(imagesInfo[index])
            }
        }
    }
    
    //MARK: - favorite method
    func processLike(with id: Int) {
        Task { @MainActor in
            print(index)
            if let imagesInfo = imagesInfo?.first(where: { $0.id == index }) {
                likeManager.handleLike(with: imagesInfo)
            }
            await checkActualLikeImages()

            if isFavoriteSubject.value {
                showFavorites()
            } else {
                collectionOfImagesSubject.send(
                    CollectionOfImages(
                        section: .main,
                        imagesInfo: imagesInfo ?? []
                    )
                )
            }
        }
    }
    
    func updateFavoritesDisplay() {
        Task { @MainActor in
            if isFavoriteSubject.value {
                hideFavorites()
            } else {
                showFavorites()
            }
        }
    }
    
    //MARK: - search method
    @MainActor
    func search(with text: String) {
        searchText = text
        if text.isEmpty, isFavoriteSubject.value {
            showFavorites()
        } else if text.isEmpty, !isFavoriteSubject.value {
            guard let images else { return }
            let collectionOfImages = convertToImageCollection(with: images)
            self.imagesInfo = collectionOfImages.imagesInfo
            collectionOfImagesSubject.send(collectionOfImages)
        } else if isFavoriteSubject.value {
            searchLikedImages(with: text)
        } else {
            searchImages(with: text)
        }
    }
}

//MARK: - Private Extension
private extension DefaultMainViewModel {
    func loadImages() throws {
        Task {
            let collectionOfImageResponse = try await getImageRequest.getImages()
            self.images = collectionOfImageResponse
            let collectionOfImage = await convertToImageCollection(with: collectionOfImageResponse)
            collectionOfImagesSubject.send(collectionOfImage)
        }
    }
    
    @MainActor
    func convertToImageCollection(with model: [CollectionOfImageResponse]) -> CollectionOfImages {
        let imagesInfo = model.map { collectionOfImageResponse in
            return ImageInfo(
                id: collectionOfImageResponse.id,
                albumId: collectionOfImageResponse.albumId,
                imageUrl: collectionOfImageResponse.thumbnailUrl,
                fullSizeImageUrl: collectionOfImageResponse.url,
                title: collectionOfImageResponse.title,
                isLiked: checkIsLiked(with: collectionOfImageResponse.id)
            )
        }
        self.imagesInfo = imagesInfo
        return CollectionOfImages(section: .main, imagesInfo: imagesInfo)
    }

    //MARK: - private favorite method
    @MainActor
    func showFavorites() {
        let likeImages = likeImageConvertToImageCollection()
        if likeImages.imagesInfo.count > 0 {
            isFavoriteSubject.send(true)
            self.imagesInfo = likeImages.imagesInfo
            collectionOfImagesSubject.send(likeImages)
        } else {
            isFavoriteSubject.send(true)
            favoritePlaceholderEnabledSubject.send(true)
        }
    }
    
    @MainActor
    func hideFavorites() {
        Task { @MainActor in
            favoritePlaceholderEnabledSubject.send(false)
            isFavoriteSubject.send(false)
            guard let images else { return }
            let collectionOfImages = convertToImageCollection(with: images)
            self.imagesInfo = collectionOfImages.imagesInfo
            collectionOfImagesSubject.send(collectionOfImages)
        }
    }
    
    @MainActor
    func likeImageConvertToImageCollection() -> CollectionOfImages {
        let imagesInfo = likeImages?.map { likeImageObject in
            return ImageInfo(
                id: likeImageObject.id,
                albumId: likeImageObject.albumId,
                imageUrl: likeImageObject.thumbnailUrl,
                fullSizeImageUrl: likeImageObject.url,
                title: likeImageObject.title,
                isLiked: true
            )
        }
        return CollectionOfImages(section: .main, imagesInfo: imagesInfo ?? [])
    }
    
    @MainActor
    func checkActualLikeImages() async {
        guard let likeImages = likeManager.getLikeImages() else { return }
        self.likeImages = likeImages
        await searchText.isEmpty ? updateImagesInfo() : updateImageInfoForSearch()
    }
    
    @MainActor
    func updateImagesInfo() async {
        guard let images else { return }
        let imagesInfo = images.map { image in
            return ImageInfo(
                id: image.id,
                albumId: image.albumId,
                imageUrl: image.thumbnailUrl,
                fullSizeImageUrl: image.url,
                title: image.title,
                isLiked: checkIsLiked(with: image.id)
            )
        }
        self.imagesInfo = imagesInfo
    }
    
    @MainActor
    func updateImageInfoForSearch() {
        var searchLikeImagesInfo: [ImageInfo] = []
        guard let images else { return }
        for image in images {
            guard image.title.contains(searchText) else { continue }
            searchLikeImagesInfo.append(
                ImageInfo(
                    id: image.id,
                    albumId: image.albumId,
                    imageUrl: image.thumbnailUrl,
                    fullSizeImageUrl: image.url,
                    title: image.title,
                    isLiked: checkIsLiked(with: image.id)
                )
            )
        }
        self.imagesInfo = searchLikeImagesInfo
    }
    
    @MainActor
    func checkIsLiked(with id: Int) -> Bool {
        guard let likeImages = likeImages else { return false }
        return likeImages.contains { $0.id == id }
    }
    
    @MainActor
    func getImageByTappingOnFavorites(with index: Int) -> ImageInfo? {
        guard let imageId = likeImages?[index].id, let imagesInfo else { return nil }
        return imagesInfo.first(where: { $0.id == imageId })
    }
    
    //MARK: - private search method
    @MainActor
    func searchImages(with text: String) {
        guard let images else { return }
        var searchImagesInfo: [ImageInfo] = []
        for image in images {
            guard image.title.contains(text) else { continue }
            searchImagesInfo.append(
                ImageInfo(
                    id: image.id,
                    albumId: image.albumId,
                    imageUrl: image.thumbnailUrl,
                    fullSizeImageUrl: image.url,
                    title: image.title,
                    isLiked: checkIsLiked(with: image.id)
                )
            )
        }
        
        if searchImagesInfo.isEmpty {
            collectionOfImagesSubject.send(CollectionOfImages(section: .main, imagesInfo: []))
        } else {
            self.imagesInfo = searchImagesInfo
            collectionOfImagesSubject.send(
                CollectionOfImages(
                    section: .main,
                    imagesInfo: searchImagesInfo
                )
            )
        }
    }
    
    @MainActor
    func searchLikedImages(with text: String) {
        guard let images else { return }
        var searchLikeImagesInfo: [ImageInfo] = []
        for image in images {
            let isLiked = checkIsLiked(with: image.id)
            guard isLiked, image.title.contains(text) else { continue }
            searchLikeImagesInfo.append(
                ImageInfo(
                    id: image.id,
                    albumId: image.albumId,
                    imageUrl: image.thumbnailUrl,
                    fullSizeImageUrl: image.url,
                    title: image.title,
                    isLiked: isLiked
                )
            )
        }
        
        if searchLikeImagesInfo.isEmpty {
            collectionOfImagesSubject.send(CollectionOfImages(section: .main, imagesInfo: []))
        } else {
            self.imagesInfo = searchLikeImagesInfo
            collectionOfImagesSubject.send(
                CollectionOfImages(
                    section: .main,
                    imagesInfo: searchLikeImagesInfo
                )
            )
        }
    }
}

struct AboutTheImage {
    let id: Int
    let url: String
    let title: String
    let isLiked: Bool
}
