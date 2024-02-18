import Foundation

final class GetImageDefaultRequest: GetImageRequest {
    private let stringUrl = "https://jsonplaceholder.typicode.com/photos"
    
    func getImages() async throws -> [CollectionOfImageResponse] {
        guard let url = URL(string: stringUrl) else {
            throw NSError(domain: "url is nil", code: -99)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let collectionOfImageResponse = try JSONDecoder().decode(
            [CollectionOfImageResponse].self,
            from: data
        )
        return collectionOfImageResponse
    }
}

struct CollectionOfImageResponse: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
