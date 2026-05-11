//
//  MoreView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI


struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: ExpensesView()) {
                    Label("Expenses", systemImage: "dollarsign.circle")
                }
                NavigationLink(destination: LunchView()) {
                    Label("Lunch", systemImage: "fork.knife.circle")
                }
                
                NavigationLink(destination: SettingView()) {
                    Label("Settings", systemImage: "gear")
                }
            }
            .navigationTitle("More")
        }
    }
}


#Preview {
    MoreView()
}
