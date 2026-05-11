//
//  ExpensesView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct Expenses: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let date: String
    let status: String
}

struct ExpensesView: View {
    @State private var showAddExpenses = false
    @State private var showReports = false

    let expenses: [Expenses] = [
        Expenses(name: "esther", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert  ", date: "12/3/2025", status: "submitted"),
        Expenses(name: "nora", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert", date: "12/3/2025", status: "submitted"),
        Expenses(name: "bola", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert ", date: "12/3/2025", status: "submitted"),
        Expenses(name: "esther", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert", date: "12/3/2025", status: "submitted"),
        Expenses(name: "nora", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert ", date: "12/3/2025", status: "submitted"),
        Expenses(name: "bola", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert", date: "12/3/2025", status: "submitted")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Text("Expenses List")
                .font(.largeTitle)
                .bold()
                .padding()

            ScrollView {
                VStack {
                    ForEach(expenses) { expense in
                        ExpensesCell(expense: expense)
                    }
                }
            }

            HStack {
                Button {
                    showAddExpenses = true
                } label: {
                    Text("New Expenses")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 8)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                Button {
                    showReports = true
                } label: {
                    Text("Reports")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 8)
                        .padding()
                        .background(Color.border)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
            }
        }
        .navigationDestination(isPresented: $showAddExpenses) {
            AddExpensesView()
        }
        .navigationDestination(isPresented: $showReports) {
            ReportsView()
        }
    }
}

#Preview {
    ExpensesView()
}
