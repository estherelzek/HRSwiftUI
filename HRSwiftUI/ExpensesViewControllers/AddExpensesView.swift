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
        VStack(alignment: .center, spacing: 15) {
            Text("Add Expenses")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundStyle(.border)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 6)
            
            ScrollView {
                VStack(spacing: 12) {
                    Label_TextCell(labelName: "Description")
                    Label_TextCell(labelName: "Category")
                    Label_TextCell(labelName: "Date")
                    Label_DoubleTextCell(labelName: "Total")
                    Label_LabelCellView(textContentOne: "800", textContentTwo: "EGP")
                    Label_TextCell(labelName: "Analytic Distribution")
                    Label_TextCell(labelName: "Included Taxes")
                    Label_UISegmentedControlCellView()
                    Label_TextCell(labelName: "Analytic Distribution")
                    Label_TextCell(labelName: "Notes")
                }
             //   .padding(.bottom, 12)
            }
            .scrollDismissesKeyboard(.interactively)
            HStack {
                Button("Save") {
                    // Switching this binding changes the app root to MainTabView.
                    //    isLoggedIn = true
                }
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .background(Color.border)
                .foregroundStyle(.white)
                .cornerRadius(12)
                .foregroundStyle(.border)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 5)
               // .padding(.top, 8)
                
                Button("Discard") {
                    // Switching this binding changes the app root to MainTabView.
                    //    isLoggedIn = true
                }
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .background(Color.gray.opacity(0.6))
                .foregroundStyle(.white)
                .cornerRadius(12)
              //  .padding(.top, 8)
                .foregroundStyle(.border)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 5)
            }
            .padding()
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

