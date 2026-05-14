import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var actionType: String? { get }
}

extension Endpoint {
    var url: URL? {
        URL(string: baseURL + path)
    }

    var urlRequest: URLRequest? {
        guard let url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = body
        return request
    }

    var actionType: String? { nil }
}
