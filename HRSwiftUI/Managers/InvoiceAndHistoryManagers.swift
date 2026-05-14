import Foundation

final class InvoiceManager {
    static let shared = InvoiceManager()

    private let ordersKey = "savedOrders"

    private(set) var orders: [Order] = []
    var isSubmitted = false
    var isEdited = false

    private init() {
        loadOrders()
    }

    func addProduct(_ product: LunchProduct, quantity: Int) {
        if let index = orders.firstIndex(where: { $0.productId == product.id }) {
            orders[index].quantity += quantity
            markEdited()
        } else {
            orders.append(
                Order(
                    productId: product.id,
                    name: product.name,
                    quantity: quantity,
                    price: product.price
                )
            )
            markEdited()
        }
        saveOrders()
    }

    func increaseQuantity(at index: Int) {
        guard orders.indices.contains(index) else { return }
        orders[index].quantity += 1
        markEdited()
        saveOrders()
    }

    func decreaseQuantity(at index: Int) {
        guard orders.indices.contains(index) else { return }
        orders[index].quantity -= 1
        if orders[index].quantity <= 0 {
            orders.remove(at: index)
        }
        markEdited()
        saveOrders()
    }

    func removeItem(at index: Int) {
        guard orders.indices.contains(index) else { return }
        orders.remove(at: index)
        markEdited()
        saveOrders()
    }

    func totalPrice() -> Double {
        orders.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    func clearInvoice() {
        orders.removeAll()
        isSubmitted = false
        isEdited = false
        saveOrders()
    }

    func markSubmitted() {
        isSubmitted = true
        isEdited = false
        orders = orders.map {
            var copy = $0
            copy.isSubmitted = true
            copy.isEdited = false
            return copy
        }
        saveOrders()
    }

    func markEdited() {
        guard isSubmitted else { return }
        isEdited = true
        orders = orders.map {
            var copy = $0
            copy.isEdited = true
            return copy
        }
    }

    func loadOrder(_ historyOrder: HistoryOrder) {
        orders = historyOrder.items
        isSubmitted = false
        isEdited = false
        saveOrders()
        NotificationCenter.default.post(name: .invoiceUpdated, object: nil)
    }

    private func saveOrders() {
        if let data = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(data, forKey: ordersKey)
            UserDefaults.standard.set(isSubmitted, forKey: "\(ordersKey)_submitted")
            UserDefaults.standard.set(isEdited, forKey: "\(ordersKey)_edited")
        }
    }

    private func loadOrders() {
        guard let data = UserDefaults.standard.data(forKey: ordersKey),
              let stored = try? JSONDecoder().decode([Order].self, from: data)
        else { return }

        orders = stored
        isSubmitted = UserDefaults.standard.bool(forKey: "\(ordersKey)_submitted")
        isEdited = UserDefaults.standard.bool(forKey: "\(ordersKey)_edited")
    }
}

final class HistoryManager {
    static let shared = HistoryManager()

    private let key = "saved_history_orders"
    private(set) var orders: [HistoryOrder] = []

    private init() {
        load()
    }

    func addOrder(_ items: [Order], total: Double) {
        let newOrder = HistoryOrder(id: UUID(), items: items, total: total, date: Date())
        orders.append(newOrder)
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let stored = try? JSONDecoder().decode([HistoryOrder].self, from: data)
        else { return }

        orders = stored
    }
}

final class FavoritesManager {
    static let shared = FavoritesManager()

    private let key = "savedFavorites"
    private(set) var favorites: [LunchProduct] = []

    private init() {
        loadFavorites()
    }

    func isFavorite(_ item: LunchProduct) -> Bool {
        favorites.contains(where: { $0.id == item.id })
    }

    func toggle(_ item: LunchProduct) {
        if let index = favorites.firstIndex(where: { $0.id == item.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(item)
        }
        saveFavorites()
    }

    func remove(_ item: LunchProduct) {
        favorites.removeAll(where: { $0.id == item.id })
        saveFavorites()
    }

    func clearFavorites() {
        favorites.removeAll()
        saveFavorites()
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let stored = try? JSONDecoder().decode([LunchProduct].self, from: data)
        else { return }

        favorites = stored
    }
}
