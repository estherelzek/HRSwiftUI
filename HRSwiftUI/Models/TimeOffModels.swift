import Foundation

struct TimeOffResponse: Decodable {
    let result: TimeOffResult?
}

struct TimeOffResult: Decodable {
    let status: String
    let leaveTypes: [LeaveType]

    enum CodingKeys: String, CodingKey {
        case status
        case leaveTypes = "leave_types"
    }
}

struct LeaveType: Decodable {
    let id: Int?
    let name: String?
    let requestUnit: String?
    let requiresAllocation: String?
    let remainingBalance: Double?
    let color: String?
    let originalBalance: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case requestUnit = "request_unit"
        case requiresAllocation = "requires_allocation"
        case remainingBalance = "remaining_balance"
        case color
        case originalBalance = "original_balance"
    }
}

struct TimeOffRequestResponse: Decodable {
    let jsonrpc: String?
    let id: String?
    let result: TimeOffRequestResult?
}

struct TimeOffRequestResult: Decodable {
    let status: String?
    let leaveId: Int?
    let message: String?
    let leaveType: String?
    let duration: Duration?
    let allocation: Allocation?
    let errorCode: String?

    enum CodingKeys: String, CodingKey {
        case status
        case leaveId = "leave_id"
        case message
        case leaveType = "leave_type"
        case duration
        case allocation
        case errorCode = "error_code"
    }
}

struct Duration: Decodable {
    let value: Double?
    let unit: String?
}

struct Allocation: Decodable {
    let allocated: Double?
    let used: Double?
    let remaining: Double?
    let unit: String?
}

struct LeaveDurationResponse: Decodable {
    let jsonrpc: String?
    let id: String?
    let result: LeaveDurationResult?
}

struct LeaveDurationResult: Decodable {
    let success: Bool?
    let data: LeaveDurationData?
    let status: String?
    let message: String?
    let errorCode: String?

    enum CodingKeys: String, CodingKey {
        case success
        case data
        case status
        case message
        case errorCode = "error_code"
    }
}

struct LeaveDurationData: Decodable {
    let leaveTypeUnit: String?
    let requestDateFrom: String?
    let requestDateTo: String?
    let dateFrom: String?
    let dateTo: String?
    let checkCasualLeave: Bool?
    let casualDaysCount: Double?
    let remainingCasualDays: Double?
    let casualLeaveWarning: Bool?
    let days: Double?
    let hours: Double?

    enum CodingKeys: String, CodingKey {
        case leaveTypeUnit = "leave_type_unit"
        case requestDateFrom = "request_date_from"
        case requestDateTo = "request_date_to"
        case dateFrom = "date_from"
        case dateTo = "date_to"
        case checkCasualLeave = "check_casual_leave"
        case casualDaysCount = "casual_days_count"
        case remainingCasualDays = "remaining_casual_days"
        case casualLeaveWarning = "casual_leave_warning"
        case days
        case hours
    }
}

struct HolidayResponse: Decodable {
    let jsonrpc: String?
    let id: String?
    let result: HolidayResult?
}

struct HolidayResult: Decodable {
    let status: String?
    let workingDays: [String: String]?
    let weeklyOffs: [String: String]?
    let publicHolidays: [PublicHoliday]?

    enum CodingKeys: String, CodingKey {
        case status
        case workingDays = "working_days"
        case weeklyOffs = "weekly_offs"
        case publicHolidays = "public_holidays"
    }
}

struct PublicHoliday: Decodable {
    let name: String
    let startDate: String
    let endDate: String
    let duration: Int

    enum CodingKeys: String, CodingKey {
        case name
        case startDate = "start_date"
        case endDate = "end_date"
        case duration
    }
}

struct EmployeeTimeOffResponse: Codable {
    let jsonrpc: String
    let id: String?
    let result: EmployeeTimeOffResult
}

struct EmployeeTimeOffResult: Codable {
    let status: String
    let records: EmployeeTimeOffRecords
}

struct EmployeeTimeOffRecords: Codable {
    let dailyRecords: [DailyRecord]
    let hourlyRecords: [HourlyRecord]

    enum CodingKeys: String, CodingKey {
        case dailyRecords = "daily_records"
        case hourlyRecords = "hourly_records"
    }
}

struct DailyRecord: Codable {
    let leaveID: Int
    let leaveType: String
    let startDate: String
    let endDate: String
    let state: String
    let durationDays: Double
    var color: String?

    enum CodingKeys: String, CodingKey {
        case leaveID = "leave_id"
        case leaveType = "leave_type"
        case startDate = "start_date"
        case endDate = "end_date"
        case state
        case durationDays = "duration_days"
        case color
    }
}

struct HourlyRecord: Codable {
    let leaveID: Int
    let leaveType: String
    let state: String
    let leaveDay: String
    let requestHourFrom: String?
    let requestHourTo: String?
    let durationHours: Double
    var color: String?

    enum CodingKeys: String, CodingKey {
        case leaveID = "leave_id"
        case leaveType = "leave_type"
        case state
        case leaveDay = "leave_day"
        case requestHourFrom = "request_hour_from"
        case requestHourTo = "request_hour_to"
        case durationHours = "duration_hours"
        case color
    }
}
