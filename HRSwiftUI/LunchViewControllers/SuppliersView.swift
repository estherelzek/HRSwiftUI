//
//  SuppliersView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 13/05/2026.
//

import SwiftUI

struct SuppliersView: View {
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Text("Suppliers")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(2)
                        Text("Select all")
                            .font(Font.body.bold())
                            .foregroundStyle(.border)
                    }
                    .padding(10)
                  }
            
               }
            ScrollView {
                VStack(alignment: .center) {
                    ForEach(0..<10) { index in
                        supplierCell()
                    }
                }
             }
            .padding()
            HStack {
                Button {
                //    showAddExpenses = true
                } label: {
                    Text("Apply")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 8)
                        .padding()
                        .background(Color.border)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                Button {
                   // showReports = true
                } label: {
                    Text("Discard")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 8)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
            }
        }
    }
}

#Preview {
    SuppliersView()
}

struct supplierCell: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.border)
                    Text("Supplier Name")
                        .font(.headline)
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.border)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(2)
                           
                        }
                        .padding(10)
                      }
                }
                
            }
            HStack {
                Image(systemName: "phone.connection")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.border)
                Text("01200789165")
                    .font(.headline)
                    .foregroundStyle(Color.green.opacity(0.8))
                    
            }
            HStack {
                Image(systemName: "location")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.border)
                Text("assiut el sadat bradge 2 home 2 gcgdgd gef")
                    .font(.title3)
                    .foregroundStyle(Color.secondary)
                    .lineLimit(2)
                    
            }
           
        }
        .padding(8)
        .background(Color(red: 0.94, green: 0.94, blue: 0.98).opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        .frame(maxWidth: .infinity, alignment: .center)
        
    }
    
}
