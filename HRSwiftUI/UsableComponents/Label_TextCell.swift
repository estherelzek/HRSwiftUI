//
//  SwiftUIView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 10/05/2026.
//

import SwiftUI

struct Label_TextCell: View {
    let labelName: String
    @State private var textValue: String = ""

    var body: some View {
        HStack(spacing: 12) {
            Text("\(labelName):")
                .font(.headline)
                .foregroundStyle(.border)
            TextField("Text Value", text: $textValue)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .frame(height: 44)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.border, lineWidth: 1.2)
                )
                .foregroundStyle(.border)
               .shadow(color: .border.opacity(0.3), radius: 2, x: 0, y: 3)
        }
        .padding(.horizontal)
    }
}

#Preview {
    Label_TextCell(labelName: "Company Code")
}

struct Label_DoubleTextCell: View {
    let labelName: String
    @State private var textValue: String = ""

    var body: some View {
        HStack(spacing: 12) {
            Text("\(labelName):")
                .font(.subheadline.weight(.medium))

            TextField("Text Value", text: $textValue)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .frame(height: 44)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.border, lineWidth: 1.2)
                )
            
            TextField("Text Value", text: $textValue)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .frame(height: 44)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.border, lineWidth: 1.2)
                )
        }
        .padding(.horizontal)
    }
}

#Preview {
    Label_DoubleTextCell(labelName: "Company Code")
}
