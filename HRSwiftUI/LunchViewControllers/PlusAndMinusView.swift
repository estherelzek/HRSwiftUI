//
//  PlusAndMinusView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 13/05/2026.
//

import SwiftUI

struct PlusAndMinusView: View {
    @State private var quantity: Int = 1
    var body: some View {
        HStack(spacing: 8) {
            Button {
                quantity = max(1, quantity - 1)
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .bold))
                    .frame(width: 30, height: 30)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)

            Text("\(quantity)")
                .font(.headline)
                .frame(minWidth: 28)

            Button {
                quantity += 1
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .frame(width: 30, height: 30)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    PlusAndMinusView()
}
