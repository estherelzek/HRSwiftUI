import Foundation

final class LoginViewModel {
    var apiKey: String { UserDefaults.standard.defaultApiKey }
    var companyId: String { UserDefaults.standard.defaultCompanyId }

    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?

    func loginTyped(
        apiKey: String?,
        companyId: String?,
        email: String,
        password: String,
        completion: @escaping (Result<LoginResponse, APIError>) -> Void
    ) {
        let endpoint = API.validateCompany(
            apiKey: (apiKey?.isEmpty == false ? apiKey! : UserDefaults.standard.defaultApiKey),
            companyId: (companyId?.isEmpty == false ? companyId! : UserDefaults.standard.defaultCompanyId),
            email: email,
            password: password
        )
        NetworkManager.shared.requestDecodable(endpoint, as: LoginResponse.self, completion: completion)
    }

    func login(apiKey: String? = nil, companyId: String? = nil, email: String, password: String) {
        loginTyped(apiKey: apiKey, companyId: companyId, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case let .success(response):
                    guard let res = response.result else {
                        self.onLoginFailure?("Unknown error")
                        return
                    }

                    if res.status.lowercased() == "error" {
                        self.onLoginFailure?(res.message?.textValue ?? "Unknown error")
                        return
                    }

                    if let detail = res.message?.objectValue, detail.status.lowercased() == "error" {
                        self.onLoginFailure?(detail.message)
                        return
                    }

                    guard let detail = res.message?.objectValue else {
                        self.onLoginFailure?("Unknown error")
                        return
                    }

                    if let token = detail.employeeData?.employeeData.employeeToken {
                        UserDefaults.standard.employeeToken = token
                    }
                    if let name = detail.employeeData?.employeeData.name {
                        UserDefaults.standard.employeeName = name
                    }
                    if let email = detail.employeeData?.employeeData.email {
                        UserDefaults.standard.employeeEmail = email
                    }

                    if let url = res.companyURL {
                        let base = url.hasSuffix("/") ? String(url.dropLast()) : url
                        UserDefaults.standard.baseURL = base
                    }

                    if let companyName = res.companyName, !companyName.isEmpty {
                        UserDefaults.standard.companyName = companyName
                    } else if let firstCompanyName = detail.company?.first?.name, !firstCompanyName.isEmpty {
                        UserDefaults.standard.companyName = firstCompanyName
                    }

                    if let companies = detail.company {
                        let branches: [AllowedLocation] = companies.compactMap { comp in
                            guard let addr = comp.address,
                                  let id = addr.id,
                                  let lat = addr.latitude,
                                  let lng = addr.longitude,
                                  let allowed = addr.allowedDistance else { return nil }
                            return AllowedLocation(id: id, latitude: lat, longitude: lng, allowedDistance: allowed)
                        }
                        UserDefaults.standard.companyBranches = branches

                        if let allowedIDs = detail.employeeData?.employeeData.allowedLocationIDs {
                            UserDefaults.standard.allowedBranchIDs = allowedIDs
                        }
                    }

                    self.onLoginSuccess?()

                    if let fcmToken = UserDefaults.standard.mobileToken {
                        SendMobileToken().sendDeviceTokenToServer(fcmToken)
                    }

                case .failure:
                    self.onLoginFailure?("Weak network connection")
                }
            }
        }
    }
}
