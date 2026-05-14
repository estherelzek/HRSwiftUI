//
//  MyOrderView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 13/05/2026.
//

import SwiftUI

struct MyOrderView: View {
    private let orderItems: [MyOrderItem] = [
        .init(name: "Pizza", note: "Extra cheese", price: 30),
        .init(name: "Burger", note: "No onions", price: 22),
        .init(name: "Pasta", note: "White sauce", price: 18)
    ]

    private var totalPrice: Int {
        orderItems.reduce(0) { $0 + $1.price }
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("My Order")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(orderItems) { item in
                            MyOrderCellView(item: item)
                        }
                    }
                }

                Label_LabelCellView(
                    textContentOne: "Items: \(orderItems.count)",
                    textContentTwo: "Total: $\(totalPrice)"
                )
                .font(.headline)
                .foregroundStyle(.border)
                .frame(maxWidth: .infinity, alignment: .center)

                Button("Order") {
                    // Place order action.
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.border)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(20)
            .background(Color(red: 0.94, green: 0.94, blue: 0.98).opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
            )
            .frame(maxWidth: 400)
            .padding(16)
        }
    }
}

private struct MyOrderItem: Identifiable {
    let id = UUID()
    let name: String
    let note: String
    let price: Int
}

private struct MyOrderCellView: View {
    let item: MyOrderItem

    var body: some View {
        HStack(spacing: 12) {
            PlusAndMinusView()

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(.border)

                Text(item.note)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Text("$\(item.price)")
                .font(.headline)
                .foregroundStyle(.purble)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.14), lineWidth: 1)
        )
    }
}

#Preview {
    MyOrderView()
}
