//
//  Label_UISegmentedControlCellView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 10/05/2026.
//

import SwiftUI

struct Label_UISegmentedControlCellView: View {
    enum UserType: String, CaseIterable, Identifiable {
        case employee = "Employee"
        case company = "Company"

        var id: String { rawValue }
    }

    @State private var selectedType: UserType = .employee

    var body: some View {
        HStack(spacing: 12) {
            Label("Baid By", systemImage: "")
                .font(.headline)
                .foregroundStyle(.border)

            Picker("User Type", selection: $selectedType) {
                ForEach(UserType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
           
            .pickerStyle(.segmented)
            .labelsHidden()
          
        }
        .padding(.horizontal)
    }
}

#Preview {
    Label_UISegmentedControlCellView()
}
