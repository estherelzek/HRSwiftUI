import Combine
import Foundation

final class ExpensesViewModel: ObservableObject {
    @Published var analyticAccounts: [AnalyticAccount] = []
    @Published var taxes: [Tax] = []
    @Published var expenseCategories: [ExpenseCategory] = []
    @Published var currencies: [Currency] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var selectedAnalyticAccounts: [Int: Int] = [:]
    var selectedTaxIds: [Int] = []

    func fetchAnalyticAccounts(token: String, completion: @escaping (Result<[AnalyticAccount], APIError>) -> Void) {
        isLoading = true
        let endpoint = API.getAnalyticAccounts(token: token)
        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<AnalyticAccountsResult>.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(response):
                    self?.analyticAccounts = response.result.data
                    completion(.success(response.result.data))
                case let .failure(error):
                    self?.errorMessage = String(describing: error)
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchTaxes(token: String, completion: @escaping (Result<[Tax], APIError>) -> Void) {
        isLoading = true
        let endpoint = API.getTaxes(token: token)
        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<TaxesResult>.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(response):
                    self?.taxes = response.result.data
                    completion(.success(response.result.data))
                case let .failure(error):
                    self?.errorMessage = String(describing: error)
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchExpenseCategories(token: String, completion: @escaping (Result<[ExpenseCategory], APIError>) -> Void) {
        isLoading = true
        let endpoint = API.getExpenseCategories(token: token)
        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<ExpenseCategoriesResult>.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(response):
                    self?.expenseCategories = response.result.data
                    completion(.success(response.result.data))
                case let .failure(error):
                    self?.errorMessage = String(describing: error)
                    completion(.failure(error))
                }
            }
        }
    }

    func createExpense(
        token: String,
        name: String,
        productId: Int,
        totalAmount: Double,
        date: String,
        description: String,
        analyticDistribution: [String: Int],
        taxIds: [Int],
        paymentMode: String,
        attachments: [[String: String]] = [],
        completion: @escaping (Result<CreateExpenseResponseData, APIError>) -> Void
    ) {
        isLoading = true
        let endpoint = API.createExpense(
            token: token,
            name: name,
            productId: productId,
            totalAmount: totalAmount,
            date: date,
            description: description,
            analyticDistribution: analyticDistribution,
            taxIds: taxIds,
            paymentMode: paymentMode,
            attachments: attachments
        )

        NetworkManager.shared.requestDecodable(endpoint, as: CreateExpenseResponseNew.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(response):
                    if response.result.status == "error" {
                        completion(.failure(.requestFailed(response.result.message)))
                        return
                    }

                    guard let expenseID = response.result.expenseID else {
                        completion(.failure(.decodingError))
                        return
                    }

                    let mapped = CreateExpenseResponseData(
                        status: response.result.status,
                        message: response.result.message,
                        expenseID: expenseID,
                        name: response.result.name ?? "",
                        state: response.result.state ?? "",
                        totalAmount: response.result.totalAmount ?? 0,
                        currency: response.result.currency ?? "",
                        currencySymbol: response.result.currencySymbol ?? "",
                        date: response.result.date ?? "",
                        description: response.result.description ?? "",
                        employeeID: response.result.employeeID ?? 0,
                        employeeName: response.result.employeeName ?? "",
                        companyID: response.result.companyID ?? 0,
                        companyName: response.result.companyName ?? "",
                        product: response.result.product ?? ExpenseProduct(id: 0, name: "", category: "", categoryID: 0),
                        analyticDistribution: response.result.analyticDistribution ?? [:],
                        analyticAccounts: response.result.analyticAccounts ?? [],
                        taxes: response.result.taxes ?? [],
                        taxTotalPercentage: response.result.taxTotalPercentage ?? 0,
                        totalWithTax: response.result.totalWithTax ?? 0
                    )
                    completion(.success(mapped))

                case let .failure(error):
                    self?.errorMessage = String(describing: error)
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchCurrencies(token: String, completion: @escaping (Result<[Currency], APIError>) -> Void) {
        isLoading = true
        let endpoint = API.getCurrencies(token: token)
        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<CurrenciesResult>.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(response):
                    self?.currencies = response.result.data
                    completion(.success(response.result.data))
                case let .failure(error):
                    self?.errorMessage = String(describing: error)
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchEmployeeExpenses(token: String, completion: @escaping (Result<[EmployeeExpense], APIError>) -> Void) {
        isLoading = true
        let endpoint = API.getEmployeeExpenses(token: token)
        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<EmployeeExpensesResult>.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(response):
                    UserDefaults.standard.set(response.result.is17Version ?? false, forKey: "is_17_version")
                    completion(.success(response.result.data))
                case let .failure(error):
                    self?.errorMessage = String(describing: error)
                    completion(.failure(error))
                }
            }
        }
    }

    func submitExpense(token: String, expenseIds: [Int], name: String, completion: @escaping (Result<SubmitExpenseResponse, APIError>) -> Void) {
        isLoading = true
        let endpoint = API.submitExpense(token: token, expenseIds: expenseIds, name: name)
        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<SubmitExpenseResponse>.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(response):
                    if response.result.status == "error" {
                        completion(.failure(.requestFailed(response.result.message)))
                    } else {
                        completion(.success(response.result))
                    }
                case let .failure(error):
                    self?.errorMessage = String(describing: error)
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchExpenseReports(token: String, completion: @escaping (Result<[ExpenseReportSheet], APIError>) -> Void) {
        isLoading = true
        let endpoint = API.getExpenseReports(token: token)
        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<ExpenseReportsResult>.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(response):
                    completion(.success(response.result.data))
                case let .failure(error):
                    self?.errorMessage = String(describing: error)
                    completion(.failure(error))
                }
            }
        }
    }

    func deleteExpense(token: String, expenseIds: [Int], completion: @escaping (Result<DeleteExpenseResponse, APIError>) -> Void) {
        let endpoint = API.deleteExpense(token: token, expenseIds: expenseIds)
        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<DeleteExpenseResponse>.self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    response.result.status.lowercased() == "error"
                        ? completion(.failure(.requestFailed(response.result.message ?? "Delete failed")))
                        : completion(.success(response.result))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    func deleteReport(token: String, sheetIds: [Int], completion: @escaping (Result<DeleteReportResponse, APIError>) -> Void) {
        let endpoint = API.deleteReport(token: token, sheetIds: sheetIds)
        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<DeleteReportResponse>.self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    response.result.status.lowercased() == "error"
                        ? completion(.failure(.requestFailed(response.result.message ?? "Delete failed")))
                        : completion(.success(response.result))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    func updateExpense(
        token: String,
        expenseId: Int,
        name: String,
        productId: Int,
        totalAmount: Double,
        date: String,
        description: String,
        currencyId: Int,
        analyticDistribution: [String: Int],
        taxIds: [Int],
        paymentMode: String,
        attachments: [[String: String]] = [],
        deleteAttachmentIds: [Int] = [],
        completion: @escaping (Result<UpdateExpenseResponse, APIError>) -> Void
    ) {
        let endpoint = API.updateExpense(
            token: token,
            expenseId: expenseId,
            name: name,
            productId: productId,
            totalAmount: totalAmount,
            date: date,
            description: description,
            currencyId: currencyId,
            analyticDistribution: analyticDistribution,
            taxIds: taxIds,
            paymentMode: paymentMode,
            attachments: attachments,
            deleteAttachmentIds: deleteAttachmentIds
        )

        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<UpdateExpenseResponse>.self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    response.result.status.lowercased() == "error"
                        ? completion(.failure(.requestFailed(response.result.message ?? "Update failed")))
                        : completion(.success(response.result))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    func updateReport(
        token: String,
        sheetId: Int,
        name: String,
        expenseIds: [Int],
        removeExpenseIds: [Int] = [],
        completion: @escaping (Result<UpdateReportResponse, APIError>) -> Void
    ) {
        let endpoint = API.updateReport(token: token, sheetId: sheetId, name: name, expenseIds: expenseIds, removeExpenseIds: removeExpenseIds)
        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<UpdateReportResponse>.self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    response.result.status.lowercased() == "error"
                        ? completion(.failure(.requestFailed(response.result.message ?? "Update failed")))
                        : completion(.success(response.result))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    func sendExpense(token: String, expenseId: Int, completion: @escaping (Result<SendExpenseResult, APIError>) -> Void) {
        let endpoint = API.sendExpense(token: token, expenseId: expenseId)
        NetworkManager.shared.requestDecodable(endpoint, as: JsonRPCResponse<SendExpenseResult>.self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response): completion(.success(response.result))
                case let .failure(error): completion(.failure(error))
                }
            }
        }
    }
}
