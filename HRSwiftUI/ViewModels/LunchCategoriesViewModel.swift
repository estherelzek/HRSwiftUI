import Foundation

final class LunchCategoriesViewModel {
    func fetchCategories(token: String, completion: @escaping (Result<[LunchCategory], APIError>) -> Void) {
        let endpoint = API.lunchCategories(token: token)
        NetworkManager.shared.requestDecodable(endpoint, as: LunchCategoriesResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if response.success {
                        completion(.success(response.categories))
                    } else {
                        completion(.failure(.requestFailed("Unable to fetch categories")))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
