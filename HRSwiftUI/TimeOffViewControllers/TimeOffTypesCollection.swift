//
//  TimeOffTypesCollection.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct TimeOffType: Identifiable {
    let id = UUID()
    let type: String
    let used: Int
    let total: Int
    let validTo: String
}

struct TimeOffTypeCell: View {
    let timeOff: TimeOffType

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(timeOff.type)
                .font(.headline)
                .foregroundStyle(.border)
            HStack(){
                Image(systemName: "clock")
                    .foregroundStyle(.purble)
                Text("\(timeOff.used) / \(timeOff.total)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.purble)
              

            }
           
            Text("Valid to: \(timeOff.validTo)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: 160)
        .background(Color(red: 0.94, green: 0.94, blue: 0.98))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct TimeOffTypesCollection: View {
    let timeOffTypes: [TimeOffType]

    init(timeOffTypes: [TimeOffType] = [
        TimeOffType(type: "Annual Leave", used: 15, total: 21, validTo: "31/12/2026"),
        TimeOffType(type: "Sick Leave", used: 3, total: 10, validTo: "31/12/2026"),
        TimeOffType(type: "Remote Work", used: 5, total: 12, validTo: "30/06/2026")
    ]) {
        self.timeOffTypes = timeOffTypes
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(timeOffTypes) { item in
                    TimeOffTypeCell(timeOff: item)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    TimeOffTypesCollection()
}
