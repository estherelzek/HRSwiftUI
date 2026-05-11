//
//  ReportsView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 10/05/2026.
//

import SwiftUI

struct ReportsView: View {
    
    @State private var showAddExpenses = false
    @State private var searchText = ""

    let expenses: [Expenses] = [
        Expenses(name: "esther", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert  ", date: "12/3/2025", status: "submitted"),
        Expenses(name: "nora", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert", date: "12/3/2025", status: "submitted"),
        Expenses(name: "bola", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert ", date: "12/3/2025", status: "submitted"),
        Expenses(name: "esther", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert", date: "12/3/2025", status: "submitted"),
        Expenses(name: "nora", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert ", date: "12/3/2025", status: "submitted"),
        Expenses(name: "bola", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert", date: "12/3/2025", status: "submitted")
    ]

    private var filteredExpenses: [Expenses] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return expenses
        }
        return expenses.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("Reports List")
                .font(.largeTitle)
                .bold()
                .padding()

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search by report name", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            )
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.bottom, 8)

            ScrollView {
                VStack {
                    ForEach(expenses) { expense in
                        ExpensesCell(expense: expense)
                    }
                }
            }


            Button {
                showAddExpenses = true
            } label: {
                Text("Create New Report")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
                    .padding()
                    .background(Color.border)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .navigationDestination(isPresented: $showAddExpenses) {
            CreateReport()
        }
    }
}

#Preview {
    ReportsView()
}
