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
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.lightGreen)
                    .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 1)

                Text("You have a new notification")
                    .foregroundStyle(.border)
                    .bold()
                Spacer()
                Text(notification.date)
                    .font(.subheadline)
                    .foregroundStyle(.purble)
                    .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 1)
                
            }
            .padding(.bottom, 5)
            Text("Your time off request has been approved.Your time off request has been approved")
                .foregroundStyle(.secondary)
                .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 1)
            
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
