import Foundation

final class LunchProductsViewModel {
    func fetchProducts(
        token: String,
        categoryId: Int? = nil,
        locationId: Int? = nil,
        supplierId: Int? = nil,
        search: String? = nil,
        completion: @escaping (Result<[LunchProduct], Error>) -> Void
    ) {
        let endpoint = API.lunchProducts(
            token: token,
            locationId: locationId,
            categoryId: categoryId,
            supplierId: supplierId,
            search: search
        )

        NetworkManager.shared.requestDecodable(endpoint, as: LunchProductsResult.self) { result in
            switch result {
            case let .success(response): completion(.success(response.products))
            case let .failure(error): completion(.failure(error))
            }
        }
    }
}
