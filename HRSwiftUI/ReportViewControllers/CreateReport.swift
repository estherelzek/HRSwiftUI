//
//  CreateReport.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 10/05/2026.
//

import SwiftUI

struct CreateReport: View {
    @State private var showAddReport = false
    @State private var textValue: String = ""
    let expenses: [Expenses] = [
        Expenses(name: "esther", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert  ", date: "12/3/2025", status: "submitted"),
        Expenses(name: "nora", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert", date: "12/3/2025", status: "submitted"),
        Expenses(name: "bola", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert ", date: "12/3/2025", status: "submitted"),
        Expenses(name: "esther", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert", date: "12/3/2025", status: "submitted"),
        Expenses(name: "nora", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert ", date: "12/3/2025", status: "submitted"),
        Expenses(name: "bola", description: "cghksvg sjhfcklshf ilshfs sfsttcgdegefg tert", date: "12/3/2025", status: "submitted")
    ]

    var body: some View {
        VStack(spacing : 20)  {
            Text("Create Report")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            TextField("Text Value", text: $textValue)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .frame(height: 44)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.border, lineWidth: 1.2)
                )
            Label_TextCell(labelName: "Employee Name")
            Label_UISegmentedControlCellView()
            Label_TextCell(labelName: "Company")
            VStack(spacing: 0) {
                ScrollView {
                    VStack {
                        ForEach(expenses) { expense in
                            ExpensesCell(expense: expense)
                        }
                    }
                }
            }
            HStack(spacing: 0) {
                Button {
                    showAddReport = true
                } label: {
                    Text("Save Report")
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
                Button {
                    showAddReport = true
                } label: {
                    Text("New Expense")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 10)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
        .navigationDestination(isPresented: $showAddReport) {
            AddExpensesView()
        }
        
        .padding()
    }
}

#Preview {
    CreateReport()
}
