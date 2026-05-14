import Foundation

extension UserDefaults {
    private enum Keys {
        static let dontShowProtectionScreen = "dontShowProtectionScreen"
        static let employeeToken = "employeeToken"
        static let baseURL = "baseURL"
        static let defaultURL = "defaultURL"
        static let apiKeyKey = "apiKeyKey"
        static let companyIdKey = "companyIdKey"
        static let companyLatitude = "companyLatitude"
        static let companyLongitude = "companyLongitude"
        static let allowedDistance = "allowedDistance"
        static let employeeName = "employeeName"
        static let employeeEmail = "employeeEmail"
        static let mobileToken = "mobileToken"
        static let companyBranches = "companyBranches"
        static let allowedBranchIDs = "allowedBranchIDs"
        static let companyName = "companyName"
    }

    var dontShowProtectionScreen: Bool {
        get { bool(forKey: Keys.dontShowProtectionScreen) }
        set { set(newValue, forKey: Keys.dontShowProtectionScreen) }
    }

    var employeeToken: String? {
        get { string(forKey: Keys.employeeToken) }
        set { set(newValue, forKey: Keys.employeeToken) }
    }

    var employeeName: String? {
        get { string(forKey: Keys.employeeName) }
        set { set(newValue, forKey: Keys.employeeName) }
    }

    var employeeEmail: String? {
        get { string(forKey: Keys.employeeEmail) }
        set { set(newValue, forKey: Keys.employeeEmail) }
    }

    var companyName: String? {
        get { string(forKey: Keys.companyName) }
        set { set(newValue, forKey: Keys.companyName) }
    }

    var baseURL: String? {
        get { string(forKey: Keys.baseURL) }
        set { setValue(newValue, forKey: Keys.baseURL) }
    }

    var defaultURL: String? {
        get { string(forKey: Keys.defaultURL) }
        set { setValue(newValue, forKey: Keys.defaultURL) }
    }

    var defaultApiKey: String {
        get { string(forKey: Keys.apiKeyKey) ?? "" }
        set { setValue(newValue, forKey: Keys.apiKeyKey) }
    }

    var defaultCompanyId: String {
        get { string(forKey: Keys.companyIdKey) ?? "Com0001" }
        set { setValue(newValue, forKey: Keys.companyIdKey) }
    }

    var companyLatitude: Double? {
        get { object(forKey: Keys.companyLatitude) as? Double }
        set { set(newValue, forKey: Keys.companyLatitude) }
    }

    var companyLongitude: Double? {
        get { object(forKey: Keys.companyLongitude) as? Double }
        set { set(newValue, forKey: Keys.companyLongitude) }
    }

    var allowedDistance: Double? {
        get { object(forKey: Keys.allowedDistance) as? Double }
        set { set(newValue, forKey: Keys.allowedDistance) }
    }

    var mobileToken: String? {
        get { string(forKey: Keys.mobileToken) }
        set { set(newValue, forKey: Keys.mobileToken) }
    }

    var companyBranches: [AllowedLocation] {
        get {
            guard let data = data(forKey: Keys.companyBranches),
                  let decoded = try? JSONDecoder().decode([AllowedLocation].self, from: data)
            else { return [] }
            return decoded
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                set(encoded, forKey: Keys.companyBranches)
            }
        }
    }

    var allowedBranchIDs: [Int] {
        get { array(forKey: Keys.allowedBranchIDs) as? [Int] ?? [] }
        set { set(newValue, forKey: Keys.allowedBranchIDs) }
    }
}
