//
//  presentTypesOftimeOff.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct TimeOffCategory: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

struct presentTypesOftimeOff: View {
    let categories: [TimeOffCategory] = [
        TimeOffCategory(name: "Annual Leave", color: .blue),
        TimeOffCategory(name: "Sick Leave", color: .red),
        TimeOffCategory(name: "Remote Work", color: .green),
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 12) {
                ForEach(categories) { category in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(category.color)
                            .frame(width: 20, height: 20)

                        Text(category.name)
                            .font(.body)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    presentTypesOftimeOff()
}
