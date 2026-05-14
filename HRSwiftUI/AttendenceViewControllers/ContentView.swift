//
//  ContentView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isCheckedIn = false
    @State private var checkInTime: Date?
    @State private var checkOutTime: Date?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Attendance")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.border)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 5)
            Image(systemName: "clock.badge.checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(.purble.opacity(0.8))
                .shadow(color: .black.opacity(0.3), radius: 2, x: 6, y: 6)

            Text("Track your daily attendance by checking in when you arrive and checking out when you leave.")
                .font(.body)
                .foregroundStyle(.border)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)

            if let checkIn = checkInTime {
                Text("Checked in at: \(checkIn.formatted(date: .omitted, time: .shortened))")
                    .font(.subheadline)
                    .foregroundStyle(.border)
            }

            if let checkOut = checkOutTime {
                Text("Checked out at: \(checkOut.formatted(date: .omitted, time: .shortened))")
                    .font(.subheadline)
                    .foregroundStyle(.red)
            }

            Button {
                if isCheckedIn {
                    checkOutTime = Date()
                } else {
                    checkInTime = Date()
                    checkOutTime = nil
                }
                isCheckedIn.toggle()
            } label: {
                Text(isCheckedIn ? "Check Out" : "Check In")
                    .font(.headline)
                    .foregroundStyle(.border)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isCheckedIn ? Color.red : Color.lightGreen)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 6, y: 5)
                    .cornerRadius(12)
                
            }
            .shadow(color: .black.opacity(0.3), radius: 2, x: 6, y: 5)
            .padding(.horizontal)
        }
        .padding()
    
    }
}

#Preview {
    ContentView()
}
