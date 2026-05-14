import CoreLocation
import Foundation

final class AttendanceViewModel {
    private let locationService = LocationService()

    var onShowAlert: ((String, @escaping () -> Void) -> Void)?
    var onSuccess: ((AttendanceResponse) -> Void)?
    var onError: ((String) -> Void)?
    var onLocationError: ((String) -> Void)?
    var onLocationPermissionDenied: (() -> Void)?

    init() {
        locationService.onPermissionDenied = { [weak self] in
            self?.onLocationPermissionDenied?()
        }
    }

    func checkIn(
        token: String,
        lat: String,
        lng: String,
        actionTime: String,
        completion: @escaping (Result<AttendanceResponse, APIError>) -> Void
    ) {
        let endpoint = API.employeeAttendance(action: "check_in", token: token, lat: lat, lng: lng, actionTime: actionTime)
        NetworkManager.shared.requestDecodable(endpoint, as: AttendanceResponse.self, completion: completion)
    }

    func checkOut(
        token: String,
        lat: String,
        lng: String,
        actionTime: String,
        completion: @escaping (Result<AttendanceResponse, APIError>) -> Void
    ) {
        let endpoint = API.employeeAttendance(action: "check_out", token: token, lat: lat, lng: lng, actionTime: actionTime)
        NetworkManager.shared.requestDecodable(endpoint, as: AttendanceResponse.self, completion: completion)
    }

    func status(token: String, completion: @escaping (Result<AttendanceResponse, APIError>) -> Void) {
        let endpoint = API.employeeAttendance(action: "status", token: token, lat: nil, lng: nil, actionTime: nil)
        NetworkManager.shared.requestDecodable(endpoint, as: AttendanceResponse.self, completion: completion)
    }

    func getServerTime(token: String, completion: @escaping (Result<ServerTimeResponse, APIError>) -> Void) {
        let endpoint = API.getServerTime(token: token, action: "server_time")
        NetworkManager.shared.requestDecodable(endpoint, as: ServerTimeResponse.self, completion: completion)
    }

    func performCheckInOut(isCheckedIn: Bool, workedHours: Double?, completion: @escaping () -> Void) {
        let token = UserDefaults.standard.employeeToken ?? ""
        let action = isCheckedIn ? "check_in" : "check_out"

        proceedAttendanceAction(action, token: token) { _ in
            DispatchQueue.main.async { completion() }
        }
    }

    private func proceedAttendanceAction(_ action: String, token: String, completion: @escaping (Bool) -> Void) {
        locationService.requestLocation { [weak self] coordinate in
            guard let self else {
                completion(false)
                return
            }

            guard let userCoordinate = coordinate else {
                self.onLocationError?("Unable to determine location.")
                completion(false)
                return
            }

            self.getServerTime(token: token) { result in
                switch result {
                case let .success(response):
                    let actionTime = response.result?.serverTime ?? self.getFallbackActionTime()
                    self.performAttendanceAction(
                        action: action,
                        token: token,
                        lat: "\(userCoordinate.latitude)",
                        lng: "\(userCoordinate.longitude)",
                        time: actionTime,
                        completion: completion
                    )
                case .failure:
                    self.performAttendanceAction(
                        action: action,
                        token: token,
                        lat: "\(userCoordinate.latitude)",
                        lng: "\(userCoordinate.longitude)",
                        time: self.getFallbackActionTime(),
                        completion: completion
                    )
                }
            }
        }
    }

    private func performAttendanceAction(
        action: String,
        token: String,
        lat: String,
        lng: String,
        time: String,
        completion: @escaping (Bool) -> Void
    ) {
        if action == "check_in" {
            checkIn(token: token, lat: lat, lng: lng, actionTime: time) { self.handleResult($0, completion: completion) }
        } else {
            checkOut(token: token, lat: lat, lng: lng, actionTime: time) { self.handleResult($0, completion: completion) }
        }
    }

    private func handleResult(_ result: Result<AttendanceResponse, APIError>, completion: @escaping (Bool) -> Void) {
        switch result {
        case let .success(response):
            if response.result?.status == "success" {
                onSuccess?(response)
                completion(true)
            } else {
                onError?(response.result?.message ?? "Attendance request failed")
                completion(false)
            }
        case let .failure(error):
            onError?(String(describing: error))
            completion(false)
        }
    }

    private func getFallbackActionTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: Date())
    }
}
