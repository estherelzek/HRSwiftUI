//
//  AddExpensesView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 10/05/2026.
//

import SwiftUI

import SwiftUI
import UIKit

struct AddExpensesView: View {
    @State private var labelName: String = ""
    @State private var textFieldType: String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Add Expenses")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            ScrollView {
                VStack(spacing: 12) {
                    Label_TextCell(labelName: "Description")
                    Label_TextCell(labelName: "Category")
                    Label_TextCell(labelName: "Date")
                    Label_DoubleTextCell(labelName: "Total")
                    Label_LabelCellView()
                    Label_TextCell(labelName: "Analytic Distribution")
                    Label_TextCell(labelName: "Included Taxes")
                    Label_UISegmentedControlCellView()
                    Label_TextCell(labelName: "Analytic Distribution")
                    Label_TextCell(labelName: "Notes")
                }
                .padding(.bottom, 12)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#Preview {
    AddExpensesView()
}

