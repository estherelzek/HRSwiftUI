//
//  ExpensesCell.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct ExpensesCell: View {
    let expense: Expenses
    @State private var isSelected: Bool = false

    var body: some View {
        
        HStack(spacing: 12) {
            
            VStack(alignment: .leading, spacing: 5) {
                Text(expense.name)
                    .font(.headline)
                    .foregroundStyle(.border)
                Text(expense.description)
                    .foregroundStyle(.gray)
                Text(expense.status)
                    .foregroundStyle(.purble)
            }

            Spacer()
            Button {
                isSelected.toggle()
            } label: {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .green : .border)
                    .font(.title2)
            }
            .buttonStyle(.plain)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(isSelected ? Color.green.opacity(0.08) : Color(red: 0.94, green: 0.94, blue: 0.98))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    ExpensesCell(expense: Expenses(name: "esther", description: "some description", date: "12/3/2025", status: "submitted"))
}
