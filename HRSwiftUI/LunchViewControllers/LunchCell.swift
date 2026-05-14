//
//  LunchCell.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 11/05/2026.
//

import SwiftUI

struct LunchCell: View {
    
    @State private var isFavorite = false

    var body: some View {
        HStack(spacing: 12) {
            Image("Image")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 6) {
                Text("Lunch Item")
                    .font(.headline)
                    .foregroundStyle(.border)
                    .lineLimit(1)
                    .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 1)

                Text("Description of the lunch item")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 10) {
                Button {
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .font(.title3)
                        .foregroundStyle(Color.gold)
                }
                .buttonStyle(.plain)
                
                Text("$30")
                    .font(.headline)
                    .foregroundStyle(.purble)

                
            }
        }
        .padding(12)
        .background(Color(red: 0.94, green: 0.94, blue: 0.98).opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

#Preview {
    LunchCell()
}
