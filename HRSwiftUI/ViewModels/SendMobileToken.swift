import Foundation

final class SendMobileToken {
    func sendDeviceTokenToServer(_ deviceToken: String) {
        guard let employeeToken = UserDefaults.standard.employeeToken else { return }

        let endpoint = API.sendMobileToken(
            employeeToken: employeeToken,
            mobileToken: deviceToken,
            mobileType: "ios"
        )

        NetworkManager.shared.requestDecodable(endpoint, as: MobileTokenAPIResponse.self) { result in
            switch result {
            case let .success(response):
                if let data = response.result.data {
                    UserDefaults.standard.set(data.employeeID, forKey: "lastEmployeeID")
                    UserDefaults.standard.set(data.email, forKey: "lastEmployeeEmail")
                }
            case .failure:
                break
            }
        }
    }
}
