import Foundation

final class EmployeeTimeOffViewModel {
    func fetchEmployeeTimeOffs(
        token: String,
        completion: @escaping (Result<EmployeeTimeOffResult, APIError>) -> Void
    ) {
        let endpoint = API.getEmployeeTimeOffs(token: token, action: "time_off_status")
        NetworkManager.shared.requestDecodable(endpoint, as: EmployeeTimeOffResponse.self) { result in
            switch result {
            case let .success(response):
                completion(.success(response.result))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
