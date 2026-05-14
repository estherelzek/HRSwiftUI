import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case decodingError
    case noData
    case unknown
}
