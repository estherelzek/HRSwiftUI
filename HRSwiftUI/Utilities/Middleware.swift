import Foundation

final class Middleware {
    private static let delimiter = "|#|"

    var companyId: String
    var apiKey: String
    var baseUrl: String

    private init(companyId: String, apiKey: String, baseUrl: String) {
        self.companyId = companyId
        self.apiKey = apiKey
        self.baseUrl = baseUrl
    }

    static func initialize(_ encryptedInput: String) throws -> Middleware {
        let decrypted = try AESEncryptionUtils.decryptData(encryptedInput)
        let params = decrypted.components(separatedBy: delimiter)
        guard params.count == 3 else {
            throw NSError(domain: "Middleware", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid decrypted data format"])
        }

        return Middleware(companyId: params[0], apiKey: params[1], baseUrl: params[2])
    }

    func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(companyId, forKey: "companyIdKey")
        defaults.set(apiKey, forKey: "apiKeyKey")
        defaults.set(baseUrl, forKey: "baseURL")
    }
}
