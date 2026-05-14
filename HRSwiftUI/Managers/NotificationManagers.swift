import Foundation
import UserNotifications
import UIKit

final class NotificationStore {
    static let shared = NotificationStore()

    private let key = "saved_notifications"
    private let lastSeenCountKey = "last_seen_notification_count"

    private init() {}

    func save(_ notification: NotificationModel) {
        var all = load()
        all.append(notification)
        if let data = try? JSONEncoder().encode(all) {
            UserDefaults.standard.set(data, forKey: key)
        }
        updateBadgeCount()
    }

    func load() -> [NotificationModel] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? JSONDecoder().decode([NotificationModel].self, from: data)
        else { return [] }

        return items
    }

    func count() -> Int { load().count }

    func unreadCount() -> Int {
        let total = count()
        let lastSeen = UserDefaults.standard.integer(forKey: lastSeenCountKey)
        return max(total - lastSeen, 0)
    }

    func updateBadgeCount() {
        let badge = unreadCount()
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = badge
        }
    }

    func clearBadge() {
        UserDefaults.standard.set(count(), forKey: lastSeenCountKey)
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

final class NotificationManager {
    static let shared = NotificationManager()

    private let checkoutReminderTestMinutes: Double? = nil

    private init() {}

    func scheduleCheckoutReminder(checkInTime: String, requiredHours: Double) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["checkout_reminder"])

        let utcFormatter = DateFormatter()
        utcFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        utcFormatter.timeZone = TimeZone(identifier: "UTC")

        let localFormatter = DateFormatter()
        localFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        localFormatter.timeZone = .current

        let parsedCheckInDate = utcFormatter.date(from: checkInTime) ?? localFormatter.date(from: checkInTime)
        let baseDate = parsedCheckInDate ?? Date()

        let interval: TimeInterval
        if let testMinutes = checkoutReminderTestMinutes {
            interval = testMinutes * 60
        } else {
            interval = requiredHours * 3600
        }

        var checkoutTime = baseDate.addingTimeInterval(interval)

        if let testMinutes = checkoutReminderTestMinutes, checkoutTime <= Date() {
            checkoutTime = Date().addingTimeInterval(testMinutes * 60)
        }

        guard checkoutTime > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Time to Check Out"
        content.body = "You've completed your working hours. Don't forget to check out!"
        content.sound = .default
        content.badge = NSNumber(value: NotificationStore.shared.count() + 1)

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: checkoutTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: "checkout_reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func cancelCheckoutReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["checkout_reminder"])
    }
}
