import Combine
import Foundation

final class GenerateTokenViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var tokenResponse: TokenRenewalResult?

    func generateNewToken(
        employeeToken: String,
        companyId: String,
        apiKey: String,
        completion: (() -> Void)? = nil
    ) {
        isLoading = true
        errorMessage = nil

        let endpoint = API.generateToken(employeeToken: employeeToken, companyId: companyId, apiKey: apiKey)
        NetworkManager.shared.requestDecodable(endpoint, as: TokenRenewalResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false

                switch result {
                case let .success(response):
                    if response.result.status.lowercased() == "success" {
                        self.tokenResponse = response.result
                        UserDefaults.standard.set(response.result.newToken, forKey: "employeeToken")
                    } else {
                        self.errorMessage = response.result.message
                    }
                case let .failure(error):
                    self.errorMessage = String(describing: error)
                }

                completion?()
            }
        }
    }
}
