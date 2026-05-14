import Foundation

struct LunchProduct: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let price: Double
    let currency: String?
    let currencySymbol: String?
    let categoryId: Int
    let categoryName: String
    let supplierId: Int
    let supplierName: String
    let imageBase64: String?
    let categoryImageUrl: String?
    let isNew: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case currency
        case currencySymbol = "currency_symbol"
        case categoryId = "category_id"
        case categoryName = "category_name"
        case supplierId = "supplier_id"
        case supplierName = "supplier_name"
        case imageBase64 = "image_base64"
        case categoryImageUrl = "category_image_url"
        case isNew = "is_new"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        price = try container.decode(Double.self, forKey: .price)
        currency = try container.decodeIfPresent(String.self, forKey: .currency)
        currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
        categoryId = try container.decode(Int.self, forKey: .categoryId)
        categoryName = try container.decode(String.self, forKey: .categoryName)
        supplierId = try container.decode(Int.self, forKey: .supplierId)
        supplierName = try container.decode(String.self, forKey: .supplierName)
        categoryImageUrl = try container.decodeIfPresent(String.self, forKey: .categoryImageUrl)
        isNew = try container.decode(Bool.self, forKey: .isNew)

        if let encoded = try? container.decode(String.self, forKey: .imageBase64) {
            imageBase64 = encoded
        } else {
            imageBase64 = nil
        }
    }
}

struct LunchProductsResult: Codable {
    let products: [LunchProduct]
    let count: Int
}

struct LunchProductsResponse: Decodable {
    let success: Bool
    let products: [LunchProduct]
    let count: Int
}

struct LunchCategory: Decodable, Identifiable {
    let id: Int
    let name: String
    let productCount: Int
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case productCount = "product_count"
        case imageURL = "image_url"
    }
}

struct LunchCategoriesResponse: Decodable {
    let success: Bool
    let categories: [LunchCategory]
    let count: Int
}

struct LunchSupplier: Decodable, Identifiable {
    let id: Int
    let name: String
    let email: String?
    let phone: String?
    let address: String?
    let city: String?
    let zipCode: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
        case address
        case city
        case zipCode = "zip_code"
    }
}

struct LunchSuppliersResponse: Decodable {
    let success: Bool
    let suppliers: [LunchSupplier]
    let count: Int
}

struct LunchOrderItem: Codable {
    let productID: Int
    let quantity: Int
    let totalPrice: Double

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case quantity
        case totalPrice = "total_price"
    }
}

struct LunchOrderResponse: Codable {
    let success: Bool
    let message: String
    let errorCode: String?

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case errorCode = "error_code"
    }
}

struct Order: Codable, Identifiable {
    let id = UUID()
    var productId: Int
    var name: String
    var quantity: Int
    var price: Double
    var isSubmitted: Bool = false
    var isEdited: Bool = false
}

struct HistoryOrder: Codable, Identifiable {
    let id: UUID
    let items: [Order]
    let total: Double
    let date: Date

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()

    var dateString: String {
        Self.formatter.string(from: date)
    }
}

struct HistorySection {
    let date: String
    let orders: [HistoryOrder]
}
