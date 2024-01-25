// URLImage.swift

import SwiftUI

struct URLImage: View {
    /// The image loader
    @StateObject private var imageLoader = ImageLoader()
    
    /// The URL to fetch the image from
    let url: URL?

    var body: some View {
        VStack {
            if let uiImage = imageLoader.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .task {
            await downloadImage()
        }
    }

    /// Downloads an image from a given URL
    private func downloadImage() async {
        do {
            try await imageLoader.fetchImage(url: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}
