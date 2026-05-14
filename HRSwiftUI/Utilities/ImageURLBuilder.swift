import Foundation

struct ImageURLBuilder {
    static func build(_ relativePath: String) -> URL? {
        let baseURL = UserDefaults.standard.baseURL ?? API.defaultBaseURL
        guard !baseURL.isEmpty else { return nil }
        let cleanBase = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
        return URL(string: cleanBase + relativePath)
    }
}
