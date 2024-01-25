// URLImage.swift

import SwiftUI

struct URLImage: View {
    @StateObject private var imageLoader = ImageLoader()
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

    private func downloadImage() async {
        do {
            try await imageLoader.fetchImage(url: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}
