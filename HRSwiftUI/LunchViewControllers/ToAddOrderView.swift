//
//  ToAddOrderView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 11/05/2026.
//

import SwiftUI

struct ToAddOrderView: View {
    var onClose: () -> Void = {}
    @State private var note = ""
    @State private var quantity = 1

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("Image")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Item Name")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        Text("$100")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer(minLength: 8)

                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.plain)
                }

                TextField("Write your note", text: $note)
                    .textInputAutocapitalization(.sentences)
                    .autocorrectionDisabled(false)
                    .padding(.horizontal, 12)
                    .frame(height: 38)
                    .background(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                HStack(spacing: 10) {
                    PlusAndMinusView()

                    Button {
                        // add item action
                    } label: {
                        Text("Add")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(Color.border)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        .padding()
    }
}

#Preview {
    ToAddOrderView()
}
