import Foundation

struct LoginResponse: Decodable {
    let jsonrpc: String?
    let id: String?
    let result: LoginResult?
}

struct LoginResult: Decodable {
    let status: String
    let message: LoginMessageUnion?
    let companyName: String?
    let licenseExpiryDate: String?
    let companyURL: String?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case companyName = "company_name"
        case licenseExpiryDate = "license_expiry_date"
        case companyURL = "company_url"
    }
}

enum LoginMessageUnion: Decodable {
    case text(String)
    case object(LoginMessage)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let text = try? container.decode(String.self) {
            self = .text(text)
        } else {
            self = .object(try container.decode(LoginMessage.self))
        }
    }

    var textValue: String? {
        if case let .text(value) = self { return value }
        return nil
    }

    var objectValue: LoginMessage? {
        if case let .object(value) = self { return value }
        return nil
    }
}

struct LoginMessage: Decodable {
    let status: String
    let message: String
    let employeeData: EmployeeDataWrapper?
    let company: [Company]?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case employeeData = "employee_data"
        case company
    }
}

struct EmployeeDataWrapper: Decodable {
    let success: Bool
    let employeeData: EmployeeData

    enum CodingKeys: String, CodingKey {
        case success
        case employeeData = "employee_data"
    }
}

struct EmployeeData: Codable {
    let id: Int
    let name: String
    let email: String
    let department: String?
    let allowedLocationIDs: [Int]
    let jobTitle: String?
    let isActive: Bool
    let employeeToken: String
    let tokenExpiry: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case department
        case allowedLocationIDs = "allowed_locations_ids"
        case jobTitle = "job_title"
        case isActive = "is_active"
        case employeeToken = "employee_token"
        case tokenExpiry = "token_expiry"
    }
}

struct Company: Decodable {
    let name: String?
    let address: Address?
}

struct Address: Decodable {
    let id: Int?
    let street: String?
    let city: String?
    let zip: String?
    let country: String?
    let latitude: Double?
    let longitude: Double?
    let allowedDistance: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case street
        case city
        case zip
        case country
        case latitude
        case longitude
        case allowedDistance = "allowed_distance"
    }
}

struct AllowedLocation: Codable {
    let id: Int
    let latitude: Double
    let longitude: Double
    let allowedDistance: Double
}
