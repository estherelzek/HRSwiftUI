import Foundation

enum API: Endpoint {
    private static let fallbackURL = "https://default-url.com"

    static var defaultBaseURL: String {
        get {
            if let saved = UserDefaults.standard.string(forKey: "baseURL"), !saved.isEmpty {
                return saved.hasSuffix("/") ? String(saved.dropLast()) : saved
            }
            return fallbackURL
        }
        set {
            guard !newValue.isEmpty else { return }
            let sanitized = newValue.hasSuffix("/") ? String(newValue.dropLast()) : newValue
            UserDefaults.standard.set(sanitized, forKey: "baseURL")
        }
    }

    static func updateDefaultBaseURL(_ url: String) {
        defaultBaseURL = url
        print("API baseURL updated: \(defaultBaseURL)")
    }

    case validateCompany(apiKey: String, companyId: String, email: String, password: String)
    case employeeAttendance(action: String, token: String, lat: String? = nil, lng: String? = nil, actionTime: String? = nil)
    case requestTimeOff(token: String, action: String)
    case leaveDuration(token: String, leaveTypeId: Int, requestDateFrom: String, requestDateTo: String, requestDateFromPeriod: String, requestUnitHalf: Bool, requestHourFrom: String?, requestHourTo: String?, requestUnitHours: Bool)
    case submitTimeOffRequest(token: String, leaveTypeId: Int, action: String, requestDateFrom: String, requestDateTo: String, requestDateFromPeriod: String, requestUnitHalf: Bool, hourFrom: String?, hourTo: String?)
    case getEmployeeTimeOffs(token: String, action: String)
    case unlinkDraftAnnualLeaves(token: String, action: String, leaveId: Int)
    case getServerTime(token: String, action: String)
    case generateToken(employeeToken: String, companyId: String, apiKey: String)
    case offlineAttendance(token: String, attendanceLogs: [[String: Any]])
    case sendMobileToken(employeeToken: String, mobileToken: String, mobileType: String)

    case lunchProducts(token: String, locationId: Int?, categoryId: Int?, supplierId: Int?, search: String?)
    case lunchProductDetails(token: String, productId: Int)
    case lunchCategories(token: String)
    case lunchSuppliers(token: String, locationId: Int?)
    case lunchOrders(token: String, orders: [[String: Any]])

    case getAnalyticAccounts(token: String)
    case getTaxes(token: String)
    case getExpenseCategories(token: String)
    case createExpense(token: String, name: String, productId: Int, totalAmount: Double, date: String, description: String, analyticDistribution: [String: Int], taxIds: [Int], paymentMode: String, attachments: [[String: String]] = [])
    case getCurrencies(token: String)
    case getEmployeeExpenses(token: String)
    case submitExpense(token: String, expenseIds: [Int], name: String)
    case getExpenseReports(token: String)
    case deleteExpense(token: String, expenseIds: [Int])
    case deleteReport(token: String, sheetIds: [Int])
    case updateExpense(token: String, expenseId: Int, name: String, productId: Int, totalAmount: Double, date: String, description: String, currencyId: Int, analyticDistribution: [String: Int], taxIds: [Int], paymentMode: String, attachments: [[String: String]] = [], deleteAttachmentIds: [Int] = [])
    case updateReport(token: String, sheetId: Int, name: String, expenseIds: [Int], removeExpenseIds: [Int])
    case sendExpense(token: String, expenseId: Int)
    case checkLocationUpdates(token: String)

    var actionType: String? {
        switch self {
        case let .employeeAttendance(action, _, _, _, _):
            return action
        default:
            return nil
        }
    }

    var method: HTTPMethod { .post }

    var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    var baseURL: String { API.defaultBaseURL }

    var path: String {
        switch self {
        case .validateCompany:
            return "/api/validate_company"
        case .employeeAttendance:
            return "/api/employee_attendance"
        case .requestTimeOff:
            return "/api/request_time_off"
        case .leaveDuration:
            return "/api/leave/duration"
        case .submitTimeOffRequest:
            return "/api/request_time_off"
        case .getEmployeeTimeOffs:
            return "/api/employee_time_off"
        case .unlinkDraftAnnualLeaves:
            return "/api/request_time_off"
        case .getServerTime:
            return "/api/employee_attendance"
        case .generateToken:
            return "/api/employee/renew_token"
        case .offlineAttendance:
            return "/api/offline_attendance"
        case .sendMobileToken:
            return "/api/mobile_token"
        case .lunchProducts:
            return "/api/lunch/products"
        case .lunchProductDetails(_, let productId):
            return "/api/lunch/product/\(productId)"
        case .lunchCategories:
            return "/api/lunch/categories"
        case .lunchSuppliers:
            return "/api/lunch/suppliers"
        case .lunchOrders:
            return "/api/lunch/orders"
        case .getAnalyticAccounts:
            return "/api/expenses/analytic_accounts"
        case .getTaxes:
            return "/api/expenses/taxes"
        case .getExpenseCategories:
            return "/api/expenses/categories"
        case .createExpense:
            return "/api/expenses/create"
        case .getCurrencies:
            return "/api/expenses/currencies"
        case .getEmployeeExpenses:
            return "/api/expenses/get"
        case .submitExpense:
            return "/api/expenses/submit"
        case .getExpenseReports:
            return "/api/expenses/report"
        case .deleteExpense:
            return "/api/expenses/delete"
        case .deleteReport:
            return "/api/expenses/delete_report"
        case .updateExpense:
            return "/api/expenses/edit"
        case .updateReport:
            return "/api/expenses/edit_report"
        case .sendExpense:
            return "/api/expenses/send"
        case .checkLocationUpdates:
            return "/api/check_location_updates"
        }
    }

    var body: Data? {
        switch self {
        case let .validateCompany(apiKey, companyId, email, password):
            return json([
                "api_key": apiKey,
                "company_id": companyId,
                "email": email,
                "password": password
            ])

        case let .employeeAttendance(action, token, lat, lng, actionTime):
            var payload: [String: Any] = [
                "action": action,
                "employee_token": token
            ]
            if let actionTime { payload["action_time"] = actionTime }
            if let lat, let lng {
                payload["lat"] = lat
                payload["lng"] = lng
            }
            return json(payload)

        case let .requestTimeOff(token, action):
            return json(["employee_token": token, "action": action])

        case let .leaveDuration(token, leaveTypeId, requestDateFrom, requestDateTo, requestDateFromPeriod, requestUnitHalf, requestHourFrom, requestHourTo, requestUnitHours):
            var payload: [String: Any] = [
                "employee_token": token,
                "leave_type_id": leaveTypeId,
                "request_date_from": requestDateFrom,
                "request_date_to": requestDateTo,
                "request_date_from_period": requestDateFromPeriod,
                "request_unit_half": requestUnitHalf,
                "request_unit_hours": requestUnitHours
            ]
            if let requestHourFrom { payload["request_hour_from"] = requestHourFrom }
            if let requestHourTo { payload["request_hour_to"] = requestHourTo }
            return json(payload)

        case let .submitTimeOffRequest(token, leaveTypeId, action, requestDateFrom, requestDateTo, requestDateFromPeriod, requestUnitHalf, hourFrom, hourTo):
            var payload: [String: Any] = [
                "employee_token": token,
                "leave_type_id": leaveTypeId,
                "action": action,
                "request_date_from": requestDateFrom,
                "request_date_to": requestDateTo,
                "request_date_from_period": requestDateFromPeriod,
                "request_unit_half": requestUnitHalf
            ]
            if let hourFrom, !hourFrom.isEmpty { payload["request_hour_from"] = hourFrom }
            if let hourTo, !hourTo.isEmpty { payload["request_hour_to"] = hourTo }
            return json(payload)

        case let .getEmployeeTimeOffs(token, action):
            return json(["employee_token": token, "action": action])

        case let .unlinkDraftAnnualLeaves(token, action, leaveId):
            return json(["employee_token": token, "action": action, "leave_id": leaveId])

        case let .getServerTime(token, action):
            return json(["employee_token": token, "action": action])

        case let .generateToken(employeeToken, companyId, apiKey):
            return json([
                "employee_token": employeeToken,
                "company_id": companyId,
                "api_key": apiKey
            ])

        case let .offlineAttendance(token, attendanceLogs):
            return json([
                "jsonrpc": "2.0",
                "method": "call",
                "params": [
                    "employee_token": token,
                    "attendance_logs": attendanceLogs
                ],
                "id": 0
            ])

        case let .sendMobileToken(employeeToken, mobileToken, mobileType):
            return json([
                "employee_token": employeeToken,
                "mobile_token": mobileToken,
                "mobile_type": mobileType
            ])

        case let .lunchProducts(token, locationId, categoryId, supplierId, search):
            var payload: [String: Any] = ["token": token]
            if let locationId { payload["location_id"] = locationId }
            if let categoryId { payload["category_id"] = categoryId }
            if let supplierId { payload["supplier_id"] = supplierId }
            if let search, !search.isEmpty { payload["search"] = search }
            return json(payload)

        case let .lunchProductDetails(token, _):
            return json(["token": token])

        case let .lunchCategories(token):
            return json(["token": token])

        case let .lunchSuppliers(token, locationId):
            var payload: [String: Any] = ["token": token]
            if let locationId { payload["location_id"] = locationId }
            return json(payload)

        case let .lunchOrders(token, orders):
            return json(["token": token, "orders": orders])

        case let .getAnalyticAccounts(token), let .getTaxes(token), let .getExpenseCategories(token), let .getCurrencies(token), let .getEmployeeExpenses(token), let .getExpenseReports(token):
            return json([
                "jsonrpc": "2.0",
                "params": ["token": token]
            ])

        case let .createExpense(token, name, productId, totalAmount, date, description, analyticDistribution, taxIds, paymentMode, attachments):
            var params: [String: Any] = [
                "token": token,
                "name": name,
                "product_id": productId,
                "total_amount": totalAmount,
                "date": date,
                "description": description,
                "analytic_distribution": analyticDistribution,
                "tax_ids": taxIds,
                "payment_mode": paymentMode
            ]
            if !attachments.isEmpty { params["attachments"] = attachments }
            return json(["jsonrpc": "2.0", "params": params])

        case let .submitExpense(token, expenseIds, name):
            return json([
                "jsonrpc": "2.0",
                "params": [
                    "token": token,
                    "expense_ids": expenseIds,
                    "name": name
                ]
            ])

        case let .deleteExpense(token, expenseIds):
            let expenseValue: Any = expenseIds.count == 1 ? expenseIds[0] : expenseIds
            return json([
                "jsonrpc": "2.0",
                "method": "call",
                "params": [
                    "expense_id": expenseValue,
                    "token": token
                ]
            ])

        case let .deleteReport(token, sheetIds):
            let sheetValue: Any = sheetIds.count == 1 ? sheetIds[0] : sheetIds
            return json([
                "jsonrpc": "2.0",
                "method": "call",
                "params": [
                    "sheet_id": sheetValue,
                    "token": token
                ]
            ])

        case let .updateExpense(token, expenseId, name, productId, totalAmount, date, description, currencyId, analyticDistribution, taxIds, paymentMode, attachments, deleteAttachmentIds):
            var params: [String: Any] = [
                "token": token,
                "expense_id": expenseId,
                "name": name,
                "product_id": productId,
                "total_amount": totalAmount,
                "date": date,
                "description": description,
                "currency_id": currencyId,
                "analytic_distribution": analyticDistribution,
                "tax_ids": taxIds,
                "payment_mode": paymentMode
            ]
            if !attachments.isEmpty { params["attachments"] = attachments }
            if !deleteAttachmentIds.isEmpty { params["delete_attachment_ids"] = deleteAttachmentIds }
            return json(["jsonrpc": "2.0", "method": "call", "params": params])

        case let .updateReport(token, sheetId, name, expenseIds, removeExpenseIds):
            return json([
                "jsonrpc": "2.0",
                "method": "call",
                "params": [
                    "token": token,
                    "sheet_id": sheetId,
                    "name": name,
                    "expense_ids": expenseIds,
                    "remove_expense_ids": removeExpenseIds
                ]
            ])

        case let .sendExpense(token, expenseId):
            return json([
                "jsonrpc": "2.0",
                "params": [
                    "token": token,
                    "expense_id": expenseId
                ]
            ])

        case let .checkLocationUpdates(token):
            return json([
                "jsonrpc": "2.0",
                "params": [
                    "employee_token": token
                ]
            ])
        }
    }

    private func json(_ dictionary: [String: Any]) -> Data? {
        try? JSONSerialization.data(withJSONObject: dictionary, options: [])
    }
}
