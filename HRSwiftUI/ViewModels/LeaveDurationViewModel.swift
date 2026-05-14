import Foundation

final class LeaveDurationViewModel {
    func fetchLeaveDuration(
        token: String,
        leaveTypeId: Int,
        requestDateFrom: String,
        requestDateTo: String,
        requestDateFromPeriod: String,
        requestUnitHalf: Bool,
        requestHourFrom: String? = nil,
        requestHourTo: String? = nil,
        requestUnitHours: Bool,
        completion: @escaping (Result<LeaveDurationResult, APIError>) -> Void
    ) {
        let endpoint = API.leaveDuration(
            token: token,
            leaveTypeId: leaveTypeId,
            requestDateFrom: requestDateFrom,
            requestDateTo: requestDateTo,
            requestDateFromPeriod: requestDateFromPeriod,
            requestUnitHalf: requestUnitHalf,
            requestHourFrom: requestHourFrom,
            requestHourTo: requestHourTo,
            requestUnitHours: requestUnitHours
        )

        NetworkManager.shared.requestDecodable(endpoint, as: LeaveDurationResponse.self) { result in
            switch result {
            case let .success(response):
                if let payload = response.result {
                    completion(.success(payload))
                } else {
                    completion(.failure(.noData))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
