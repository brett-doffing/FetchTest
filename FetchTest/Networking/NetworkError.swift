// NetworkError.swift

import Foundation

/// The errors for the API
enum NetworkError: Error {
    case invalidURL
    case invalidHTTPURLResponse
    case invalidStatusCode(statusCode: Int)
    case failedToDecode(error: Error)
    case unsupportedImage

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidHTTPURLResponse:
            return "Invalid HTTPURLResponse"
        case .invalidStatusCode(let statusCode):
            return "Invalid Status Code: \(statusCode)"
        case .failedToDecode(let error):
            return "Failed to Decode: \(error.localizedDescription)"
        case .unsupportedImage:
            return "Unsupported Image"
        }
    }
}
