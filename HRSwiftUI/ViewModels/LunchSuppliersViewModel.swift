import Foundation

final class LunchSuppliersViewModel {
    func fetchLunchSuppliers(
        token: String,
        locationId: Int? = nil,
        completion: @escaping (Result<[LunchSupplier], APIError>) -> Void
    ) {
        let endpoint = API.lunchSuppliers(token: token, locationId: locationId)
        NetworkManager.shared.requestDecodable(endpoint, as: LunchSuppliersResponse.self) { result in
            switch result {
            case let .success(response):
                if response.success {
                    completion(.success(response.suppliers))
                } else {
                    completion(.failure(.requestFailed("Unable to fetch suppliers")))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
