// ImageLoader.swift

import UIKit

@MainActor class ImageLoader: ObservableObject {

    /// The image to display
    @Published var uiImage: UIImage?
    
    /// The image cache
    private static let cache = NSCache<NSString, UIImage>()

    /// Fetches an image from a given URL and caches it
    /// - Parameter url: The URL to fetch the image from
    func fetchImage(url: URL?) async throws {
        guard let url = url else { throw NetworkError.invalidURL }

        let request = URLRequest(url: url)

        // Check if image is cached
        if let cachedImage = Self.cache.object(forKey: url.absoluteString as NSString) {
            uiImage = cachedImage
            return
        } else {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, 
            httpResponse.statusCode == 200 else {
                throw NetworkError.invalidHTTPURLResponse
            }

            guard let image = UIImage(data: data) else {
                throw NetworkError.failedToDecode(error: NetworkError.unsupportedImage)
            }

            // Cache image
            Self.cache.setObject(image, forKey: url.absoluteString as NSString)

            uiImage = image
        }
    }
}
