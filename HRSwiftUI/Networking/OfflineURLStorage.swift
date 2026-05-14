import Foundation

struct OfflineRequest: Codable, Equatable {
    let url: String
    let method: String
    let headers: [String: String]
    let body: String?
    let timestamp: Date
    let actionType: String?
}

final class OfflineURLStorage {
    static let shared = OfflineURLStorage()

    private let key = "OfflineFailedRequests"

    private init() {}

    func save(_ request: OfflineRequest) {
        var stored = fetch()
        stored.append(request)
        if let data = try? JSONEncoder().encode(stored) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func fetch() -> [OfflineRequest] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let stored = try? JSONDecoder().decode([OfflineRequest].self, from: data)
        else { return [] }
        return stored
    }

    func remove(_ requests: [OfflineRequest]) {
        var stored = fetch()
        stored.removeAll { requests.contains($0) }
        if let data = try? JSONEncoder().encode(stored) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
