import Foundation

struct AttendanceResponse: Decodable {
    let result: AttendanceResult?
}

struct AttendanceResult: Decodable {
    let status: String?
    let message: String?
    let errorCode: String?
    let attendanceStatus: String?
    let workedHours: Double?
    let checkInTime: String?
    let checkOutTime: String?
    let lastCheckIn: String?
    let lastCheckOut: String?
    let todayScheduledHours: Double?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case errorCode = "error_code"
        case attendanceStatus = "attendance_status"
        case workedHours = "worked_hours"
        case checkInTime = "check_in_time"
        case checkOutTime = "check_out_time"
        case lastCheckIn = "last_check_in"
        case lastCheckOut = "last_check_out"
        case todayScheduledHours = "today_scheduled_hours"
    }
}

struct OfflineAttendanceResponse: Codable {
    let jsonrpc: String
    let id: Int?
    let result: OfflineAttendanceResult?
}

struct OfflineAttendanceResult: Codable {
    let status: String
    let message: String
}

struct ServerTimeResponse: Codable {
    let jsonrpc: String?
    let id: String?
    let result: ServerTimeResult?
}

struct ServerTimeResult: Codable {
    let status: String
    let message: String
    let serverTime: String
    let timezone: String

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case serverTime = "server_time"
        case timezone
    }
}

struct TokenRenewalResponse: Codable {
    let jsonrpc: String
    let id: String?
    let result: TokenRenewalResult
}

struct TokenRenewalResult: Codable {
    let status: String
    let message: String
    let errorCode: String?
    let employeeID: Int?
    let email: String?
    let employeeName: String?
    let newToken: String?
    let creationDate: String?
    let expiryDate: String?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case errorCode = "error_code"
        case employeeID = "employee_id"
        case email
        case employeeName = "employee_name"
        case newToken = "new_token"
        case creationDate = "creation_date"
        case expiryDate = "expiry_date"
    }
}

struct MobileTokenResponse: Codable {
    let status: String
    let message: String
    let data: MobileTokenData?
}

struct MobileTokenData: Codable {
    let employeeID: Int
    let email: String
    let employeeName: String

    enum CodingKeys: String, CodingKey {
        case employeeID = "employee_id"
        case email
        case employeeName = "employee_name"
    }
}

struct MobileTokenAPIResponse: Codable {
    let jsonrpc: String?
    let id: Int?
    let result: MobileTokenResponse
}

struct UnlinkDraftLeaveResponse: Codable {
    let jsonrpc: String
    let id: String?
    let result: UnlinkResult
}

struct UnlinkResult: Codable {
    let status: String
    let message: String
    let leaveId: Int?
    let errorCode: String?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case leaveId = "leave_id"
        case errorCode = "error_code"
    }
}
