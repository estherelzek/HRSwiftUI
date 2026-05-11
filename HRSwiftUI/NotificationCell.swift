//
//  NotificationCell.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct NotificationCell: View {
    let notification: Notification
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "bell.badge")
                    .tint(.border)
                Text("You have a new notification")
                    .foregroundStyle(.border)
                    .bold()
                Spacer()
                Text(notification.date)
                    .font(.subheadline)
                    .foregroundStyle(.purble)
                
            }
            .padding(.bottom, 5)
            Text("Your time off request has been approved.Your time off request has been approved")
                .foregroundStyle(.secondary)
                .padding(5)
                
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(red: 0.94, green: 0.94, blue: 0.98))
        .cornerRadius(10)
        .padding(.horizontal)
        
    }
}

#Preview {
    NotificationCell(notification: Notification(title: "hello", message: "helloz", date: "Helloss"))
}
