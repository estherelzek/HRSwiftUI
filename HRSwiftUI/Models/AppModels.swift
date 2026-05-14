import Foundation

struct LocationUpdateResponse: Decodable {
    let result: LocationUpdateResult?
}

struct LocationUpdateResult: Decodable {
    let status: String
    let changed: Bool
    let companyLocations: [Company]?
    let allowedLocationsIds: [Int]?

    enum CodingKeys: String, CodingKey {
        case status
        case changed
        case companyLocations = "company_locations"
        case allowedLocationsIds = "allowed_locations_ids"
    }
}

struct NotificationModel: Identifiable, Codable {
    let id: String
    let title: String
    let message: String
    let date: Date
}

struct SettingItem {
    let titleKey: String
    let iconName: String?
    let isDropdownVisible: Bool
    let isDarkModeRow: Bool
}

struct StateType {
    let title: String
    let key: String
}

struct PendingAttendanceAction: Codable, Equatable {
    let action: String
    let workedHours: Double?
    let timestamp: Date
}
