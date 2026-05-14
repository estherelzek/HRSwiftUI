import Foundation

struct JsonRPCResponse<T: Codable>: Codable {
    let jsonrpc: String
    let id: Int?
    let result: T
}

struct AnalyticAccount: Codable, Identifiable {
    let id: Int
    let name: String
    let code: String
    let planID: Int
    let planName: String
    let companyID: Int?
    let companyName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case code
        case planID = "plan_id"
        case planName = "plan_name"
        case companyID = "company_id"
        case companyName = "company_name"
    }
}

struct AnalyticAccountsResult: Codable {
    let status: String
    let message: String
    let count: Int
    let data: [AnalyticAccount]
}

struct Tax: Codable, Identifiable {
    let id: Int
    let name: String
    let amount: Double
    let amountType: String
    let description: String
    let companyID: Int?
    let companyName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case amount
        case amountType = "amount_type"
        case description
        case companyID = "company_id"
        case companyName = "company_name"
    }
}

struct TaxesResult: Codable {
    let status: String
    let message: String
    let count: Int
    let data: [Tax]
}

struct ExpenseAttachment: Codable {
    let id: Int
    let name: String
    let mimetype: String
    let fileSize: Int?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case mimetype
        case fileSize = "file_size"
        case url
    }
}

struct TaxInfo: Codable {
    let id: Int
    let name: String
    let amount: Double
    let amountType: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case amount
        case amountType = "amount_type"
    }
}

struct EmployeeExpense: Codable, Identifiable {
    let id: Int
    let name: String
    let employee: String
    let employeeID: Int
    let company: String
    let companyID: Int
    let product: String
    let productID: Int
    let totalAmount: Double
    let currency: String
    let currencySymbol: String?
    let currencyPosition: String?
    let date: String
    let state: String
    let sheetID: Int?
    let sheetName: String?
    let description: String
    let taxAmount: Double
    let draftTotalAmount: String
    let taxTotalPercentage: Double?
    let totalWithTax: Double?
    let paymentMode: String?
    let taxes: [TaxInfo]?
    let analyticDistribution: [String: Double]?
    let attachments: [ExpenseAttachment]?
    let attachmentCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case employee
        case employeeID = "employee_id"
        case company
        case companyID = "company_id"
        case product
        case productID = "product_id"
        case totalAmount = "total_amount"
        case currency
        case currencySymbol = "currency_symbol"
        case currencyPosition = "currency_position"
        case date
        case state
        case sheetID = "sheet_id"
        case sheetName = "sheet_name"
        case description
        case taxAmount = "tax_amount"
        case draftTotalAmount = "draft_total_amount"
        case taxTotalPercentage = "tax_total_percentage"
        case totalWithTax = "total_with_tax"
        case paymentMode = "payment_mode"
        case taxes
        case analyticDistribution = "analytic_distribution"
        case attachments
        case attachmentCount = "attachment_count"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        employee = try container.decode(String.self, forKey: .employee)
        employeeID = try container.decode(Int.self, forKey: .employeeID)
        company = try container.decode(String.self, forKey: .company)
        companyID = try container.decode(Int.self, forKey: .companyID)
        product = try container.decode(String.self, forKey: .product)
        productID = try container.decode(Int.self, forKey: .productID)
        totalAmount = try container.decode(Double.self, forKey: .totalAmount)
        currency = try container.decode(String.self, forKey: .currency)
        currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
        currencyPosition = try container.decodeIfPresent(String.self, forKey: .currencyPosition)
        date = try container.decode(String.self, forKey: .date)
        state = try container.decode(String.self, forKey: .state)
        sheetID = try container.decodeIfPresent(Int.self, forKey: .sheetID)
        sheetName = try container.decodeIfPresent(String.self, forKey: .sheetName)
        description = try container.decode(String.self, forKey: .description)

        if let value = try? container.decode(Double.self, forKey: .taxAmount) {
            taxAmount = value
        } else if let value = try? container.decode(String.self, forKey: .taxAmount), let parsed = Double(value) {
            taxAmount = parsed
        } else {
            taxAmount = 0
        }

        if let value = try? container.decode(String.self, forKey: .draftTotalAmount) {
            draftTotalAmount = value
        } else if let value = try? container.decode(Double.self, forKey: .draftTotalAmount) {
            draftTotalAmount = String(format: "%.2f", value)
        } else if let value = try? container.decode(Int.self, forKey: .draftTotalAmount) {
            draftTotalAmount = String(value)
        } else {
            draftTotalAmount = ""
        }

        taxTotalPercentage = try container.decodeIfPresent(Double.self, forKey: .taxTotalPercentage)
        totalWithTax = try container.decodeIfPresent(Double.self, forKey: .totalWithTax)
        paymentMode = try container.decodeIfPresent(String.self, forKey: .paymentMode)
        taxes = try container.decodeIfPresent([TaxInfo].self, forKey: .taxes)
        analyticDistribution = try container.decodeIfPresent([String: Double].self, forKey: .analyticDistribution)
        attachments = try container.decodeIfPresent([ExpenseAttachment].self, forKey: .attachments)
        attachmentCount = try container.decodeIfPresent(Int.self, forKey: .attachmentCount)
    }
}

struct EmployeeExpensesResult: Codable {
    let status: String
    let message: String
    let count: Int
    let is17Version: Bool?
    let data: [EmployeeExpense]

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case count
        case is17Version = "is_17_version"
        case data
    }
}

struct SubmitExpenseResponse: Codable {
    let status: String
    let message: String
    let sheetID: Int?
    let state: String?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case sheetID = "sheet_id"
        case state
    }
}

struct ExpenseCategory: Codable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let categoryID: Int
    let description: String
    let defaultCode: String
    let uom: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case categoryID = "category_id"
        case description
        case defaultCode = "default_code"
        case uom
    }
}

struct ExpenseCategoriesResult: Codable {
    let status: String
    let message: String
    let count: Int
    let data: [ExpenseCategory]
}

struct ExpenseProduct: Codable {
    let id: Int
    let name: String
    let category: String
    let categoryID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case categoryID = "category_id"
    }
}

struct AnalyticAccountInfo: Codable {
    let id: Int
    let name: String
    let code: String
    let percentage: Int
}

struct CreateExpenseResponseData: Codable {
    let status: String
    let message: String
    let expenseID: Int
    let name: String
    let state: String
    let totalAmount: Double
    let currency: String
    let currencySymbol: String
    let date: String
    let description: String
    let employeeID: Int
    let employeeName: String
    let companyID: Int
    let companyName: String
    let product: ExpenseProduct
    let analyticDistribution: [String: Int]
    let analyticAccounts: [AnalyticAccountInfo]
    let taxes: [TaxInfo]
    let taxTotalPercentage: Double
    let totalWithTax: Double

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case expenseID = "expense_id"
        case name
        case state
        case totalAmount = "total_amount"
        case currency
        case currencySymbol = "currency_symbol"
        case date
        case description
        case employeeID = "employee_id"
        case employeeName = "employee_name"
        case companyID = "company_id"
        case companyName = "company_name"
        case product
        case analyticDistribution = "analytic_distribution"
        case analyticAccounts = "analytic_accounts"
        case taxes
        case taxTotalPercentage = "tax_total_percentage"
        case totalWithTax = "total_with_tax"
    }
}

typealias CreateExpenseResponse = JsonRPCResponse<CreateExpenseResponseData>

struct CreateExpenseResultData: Codable {
    let status: String
    let message: String
    let expenseID: Int?
    let name: String?
    let state: String?
    let totalAmount: Double?
    let currency: String?
    let currencySymbol: String?
    let date: String?
    let description: String?
    let employeeID: Int?
    let employeeName: String?
    let companyID: Int?
    let companyName: String?
    let product: ExpenseProduct?
    let analyticDistribution: [String: Int]?
    let analyticAccounts: [AnalyticAccountInfo]?
    let taxes: [TaxInfo]?
    let taxTotalPercentage: Double?
    let totalWithTax: Double?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case expenseID = "expense_id"
        case name
        case state
        case totalAmount = "total_amount"
        case currency
        case currencySymbol = "currency_symbol"
        case date
        case description
        case employeeID = "employee_id"
        case employeeName = "employee_name"
        case companyID = "company_id"
        case companyName = "company_name"
        case product
        case analyticDistribution = "analytic_distribution"
        case analyticAccounts = "analytic_accounts"
        case taxes
        case taxTotalPercentage = "tax_total_percentage"
        case totalWithTax = "total_with_tax"
    }
}

typealias CreateExpenseResponseNew = JsonRPCResponse<CreateExpenseResultData>

struct Currency: Codable {
    let id: Int
    let name: String
    let symbol: String
    let currencyCode: String
    let rate: Double
    let conversionRate: Double
    let isCompanyCurrency: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case currencyCode = "currency_code"
        case rate
        case conversionRate = "conversion_rate"
        case isCompanyCurrency = "is_company_currency"
    }
}

struct CurrenciesResult: Codable {
    let status: String
    let message: String
    let count: Int
    let data: [Currency]
}

struct ExpenseReportsResult: Codable {
    let status: String
    let data: [ExpenseReportSheet]
}

struct ExpenseReportSheet: Codable {
    let sheetID: Int
    let name: String
    let employee: String
    let state: String
    let totalAmount: Double
    let paymentModeLabel: String?
    let expenses: [ExpenseReportExpense]

    enum CodingKeys: String, CodingKey {
        case sheetID = "sheet_id"
        case name
        case employee
        case state
        case totalAmount = "total_amount"
        case paymentModeLabel = "payment_mode_label"
        case expenses
    }
}

struct ExpenseReportExpense: Codable {
    let id: Int
    let name: String
    let amount: Double
    let date: String
    let paymentMode: String?
    let paymentModeLabel: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case amount
        case date
        case paymentMode = "payment_mode"
        case paymentModeLabel = "payment_mode_label"
    }
}

struct ReportListItem {
    let sheetID: Int
    let sheetName: String
    let employee: String
    let state: String
    let totalAmount: Double
    let expense: ExpenseReportExpense
}

struct DeleteFailureItem: Codable {
    let id: Int
    let reason: String
}

struct DeletedItem: Codable {
    let id: Int
    let name: String?
}

enum DeletedIDs: Codable {
    case ids([Int])
    case objects([DeletedItem])
    case none

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let ids = try? container.decode([Int].self) {
            self = .ids(ids)
            return
        }
        if let objects = try? container.decode([DeletedItem].self) {
            self = .objects(objects)
            return
        }
        self = .none
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .ids(ids):
            try container.encode(ids)
        case let .objects(objects):
            try container.encode(objects)
        case .none:
            try container.encode([Int]())
        }
    }

    var idList: [Int] {
        switch self {
        case let .ids(ids):
            return ids
        case let .objects(objects):
            return objects.map { $0.id }
        case .none:
            return []
        }
    }
}

struct DeleteExpenseResponse: Codable {
    let status: String
    let message: String?
    let deleted: DeletedIDs?
    let failed: [DeleteFailureItem]?
}

struct DeleteReportResponse: Codable {
    let status: String
    let message: String?
    let deleted: DeletedIDs?
    let failed: [DeleteFailureItem]?
}

struct UpdateExpenseResponse: Codable {
    let status: String
    let message: String?
    let expenseID: Int?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case expenseID = "expense_id"
    }
}

struct UpdateReportResponse: Codable {
    let status: String
    let message: String?
    let sheetID: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case sheetID = "sheet_id"
        case name
    }
}

struct SendExpenseItem: Codable {
    let id: Int
    let name: String
    let state: String
    let totalAmount: Double
    let currency: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case state
        case totalAmount = "total_amount"
        case currency
    }
}

struct SendExpenseFailedItem: Codable {
    let id: Int
    let name: String
    let reason: String
}

struct SendExpenseResult: Codable {
    let status: String
    let message: String
    let submitted: [SendExpenseItem]?
    let failed: [SendExpenseFailedItem]?
    let submittedCount: Int?
    let failedCount: Int?
    let errorCode: String?
    let httpStatus: Int?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case submitted
        case failed
        case submittedCount = "submitted_count"
        case failedCount = "failed_count"
        case errorCode = "error_code"
        case httpStatus = "http_status"
    }
}
