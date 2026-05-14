import Combine
import Foundation

final class OfflineAttendanceViewModel: ObservableObject {
    @Published var isSyncing = false
    @Published var syncMessage: String?
    @Published var lastSyncedCount = 0

    func sendOfflineLogs(token: String, completion: (() -> Void)? = nil) {
        let storedRequests = OfflineURLStorage.shared.fetch()
        guard !storedRequests.isEmpty else {
            syncMessage = "No offline requests to sync."
            completion?()
            return
        }

        let logs: [[String: Any]] = storedRequests.compactMap { request in
            guard let body = request.body,
                  let data = body.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let action = json["action"] as? String,
                  let lat = json["lat"],
                  let lng = json["lng"],
                  let actionTime = json["action_time"] as? String
            else { return nil }

            return [
                "action": action,
                "lat": lat,
                "lng": lng,
                "action_time": actionTime,
                "action_tz": "UTC"
            ]
        }

        guard !logs.isEmpty else {
            syncMessage = "No valid offline attendance logs found."
            completion?()
            return
        }

        isSyncing = true
        syncMessage = "Syncing \(logs.count) offline records..."

        let endpoint = API.offlineAttendance(token: token, attendanceLogs: logs)
        NetworkManager.shared.requestDecodable(endpoint, as: OfflineAttendanceResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isSyncing = false

                switch result {
                case let .success(response):
                    if response.result?.status.lowercased() == "success" {
                        self.lastSyncedCount = logs.count
                        self.syncMessage = "Successfully synced \(logs.count) logs."
                        OfflineURLStorage.shared.clear()
                    } else {
                        self.syncMessage = response.result?.message ?? "Sync failed"
                    }
                case let .failure(error):
                    self.syncMessage = String(describing: error)
                }

                completion?()
            }
        }
    }
}
