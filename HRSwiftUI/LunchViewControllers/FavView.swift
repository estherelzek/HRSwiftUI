//
//  FavView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 13/05/2026.
//

import SwiftUI

struct FavView: View {
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 40) {
                Text("Fav View")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                Button {
                    
                } label: {
                    Image(systemName: "trash.slash.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(30)
                  }
            
               }
            ScrollView {
                VStack(alignment: .center) {
                    ForEach(0..<10) { index in
                        FavCell()
                    }
                }
             }
          }
        }
    }

#Preview {
    FavView()
}

struct FavCell: View {
    var body: some View {
        HStack(spacing: 40) {
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
                
                Text("50$")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            VStack {
                Button {
                    
                }label: {
                    Image(systemName: "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundStyle(Color.gold)
                        .frame(width: 100, height: 50)
                       
                }
                .frame(width: 100, height: 50)
                
                Button {
                    
                } label: {
                    Text("Add to cart")
                        .frame(width: 100, height: 30)
                        .foregroundStyle(Color.white)
                        .bold(true)
                        .background(Color.border)
                        .cornerRadius(10)
                       
                }
            }
           
        }
        .padding(12)
        .background(Color(red: 0.94, green: 0.94, blue: 0.98).opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
