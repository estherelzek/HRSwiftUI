import Foundation
import Network

final class NetworkListener {
    static let shared = NetworkListener()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkListener")

    var onConnected: (() -> Void)?
    private(set) var isConnected = false

    private init() {}

    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }

            if path.status == .satisfied {
                if !self.isConnected {
                    self.isConnected = true
                    self.onConnected?()
                    NotificationCenter.default.post(name: .networkReachable, object: nil)
                }
            } else if self.isConnected {
                self.isConnected = false
                NotificationCenter.default.post(name: .networkLost, object: nil)
            }
        }
        monitor.start(queue: queue)
    }
}
