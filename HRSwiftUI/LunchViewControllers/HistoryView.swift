//
//  HistoryView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 13/05/2026.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        ZStack {
            VStack {
                Text("History")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                ScrollView {
                    VStack {
                        ForEach(0..<5) { index in
                            HistoryCell()
                            
                        }
                    }
                }
            }
            
            .padding(.horizontal, 16)
            .background(Color(red: 0.94, green: 0.94, blue: 0.98).opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
        }
        
        .frame(maxWidth: 400 ,maxHeight: .infinity)
        .padding(16)
    }
}

#Preview {
    HistoryView()
}

struct HistoryCell: View {
        var body: some View {
            HStack {
                VStack {
                    Text("Pizza")
                        .font(.headline)
                    Text("40$")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                }
                .frame(maxWidth: .infinity ,alignment: .leading)
                Button {
                //    showAddExpenses = true
                } label: {
                    Text("ReOrder")
                        .font(.headline)
                        .foregroundStyle(.white)
                    //    .frame(maxWidth: .infinity)
                        .frame(height: 8)
                        .padding()
                        .background(Color.border)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .background(Color(red: 0.94, green: 0.94, blue: 0.98).opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
        }
    }
