import Foundation

extension Date {
    func toAPIDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }

    func toDurationAPIDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }

    func toRequestAPIDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }

    static func parseDate(_ text: String) -> Date? {
        let formats = ["MMM d, yyyy", "d MMM yyyy", "dd/MM/yyyy", "MM-dd-yyyy", "dd-MM-yyyy"]
        for format in formats {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "en_US_POSIX")
            if let date = formatter.date(from: text) {
                return date
            }
        }
        return nil
    }
}

extension String {
    func toLocalDateString() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.timeZone = TimeZone(identifier: "UTC")

        guard let date = inputFormatter.date(from: self) else { return nil }

        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.locale = Locale(identifier: "en_US")
        outputFormatter.dateFormat = "dd MMM yyyy - hh:mm a"

        return outputFormatter.string(from: date)
    }

    func formattedHour(using leaveDay: String) -> String {
        let components = split(separator: ".")
        let hour = Int(components.first ?? "0") ?? 0
        let minuteValue: Int
        if components.count > 1, let decimal = Double("0.\(components[1])") {
            minuteValue = Int(decimal * 60)
        } else {
            minuteValue = 0
        }

        var dateComponents = DateComponents()
        dateComponents.year = Int(leaveDay.prefix(4))
        dateComponents.month = Int(leaveDay.dropFirst(5).prefix(2))
        dateComponents.day = Int(leaveDay.suffix(2))
        dateComponents.hour = hour
        dateComponents.minute = minuteValue

        guard let date = Calendar.current.date(from: dateComponents) else { return self }

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
