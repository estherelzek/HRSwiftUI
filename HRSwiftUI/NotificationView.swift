//
//  NotificationView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct Notification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let date: String
}


struct NotificationView: View {
    let notifications: [Notification] = [
        Notification(title: "New Time Off Request", message: "Your time off request has been approved.", date: "2024-06-01"),
        Notification(title: "Expense Report Submitted", message: "Your expense report has been submitted for review.", date: "2024-06-02"),
        Notification(title: "Company Announcement", message: "Don't forget the all-hands meeting tomorrow at 10 AM.", date: "2024-06-03"),
        Notification(title: "New Project Deadline", message: "The deadline for the new project presentation is now 5 PM.", date: "2024-06-04"),
    ]

    var body: some View {
        
        if notifications.isEmpty {
            VStack {
                Image(systemName: "bell.slash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.gray)
                Text("No Notifications")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        } else {
         
            ScrollView {
                Text("Notifications")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .foregroundStyle(.border)
                VStack(spacing: 10) {
                    ForEach(notifications) { notification in
                       NotificationCell(notification: notification)
                        
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationView()
}
