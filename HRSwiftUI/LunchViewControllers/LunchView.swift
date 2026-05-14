//
//  LunchView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct LunchView: View {
    @State private var showAddOrderPopup = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Lunch")
                    .font(.largeTitle)
                    .bold()
                    .navigationTitle("")
                    .foregroundStyle(.border)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 6)
                LunchFirstSection()
                LunchSecondSection()

                ScrollView {
                    VStack {
                        ForEach(1..<10) { _ in
                            Button {
                                showAddOrderPopup = true
                            } label: {
                                LunchCell()
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(20)
                }
            }

            if showAddOrderPopup {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showAddOrderPopup = false
                    }

                ToAddOrderView(onClose: {
                    showAddOrderPopup = false
                })
                .frame(maxWidth: 420)
                .padding(.horizontal, 16)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showAddOrderPopup)
    }
}

#Preview {
    LunchView()
}

struct LunchFirstSection: View {
    
    @State private var showVendors = false
    @State private var showFavs = false
    @State private var showOrder = false
    @State private var showHistory = false
    @State private var searchText = ""
    
    var body: some View {
        HStack(spacing: 10){
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search by report name", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }
            .padding(.horizontal, 8)
            .frame(height: 44)
            .background(Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            )
            .cornerRadius(10)
            .padding(.horizontal , 4)
            .padding(.bottom, 8)
            //
            Button {
                showVendors = true
            } label: {
                Image(systemName: "fork.knife.circle")
                    .font(.title)
                    .foregroundStyle(.border)
            }
            .padding(.bottom, 8)
            Button {
                showFavs = true
            } label: {
                Image(systemName: "star.circle")
                    .font(.title)
                    .foregroundStyle(.border)
            }
            .padding(.bottom, 8)
        }
        .navigationDestination(isPresented: $showFavs) {
            FavView()
        }
        .navigationDestination(isPresented: $showVendors) {
            SuppliersView()
        }
    }
}

struct LunchSecondSection: View {
    @State private var showHistory = false
    @State private var showCurrentOrder = false
    @State private var selectedCategory = "All"

    private let categories = [
        "All", "Pizza", "Burger", "Pasta", "Salad", "Dessert", "Drinks"
    ]

    var body: some View {
        HStack(spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Text(category)
                                .font(.subheadline)
                                .fontWeight(selectedCategory == category ? .semibold : .regular)
                                .foregroundStyle(selectedCategory == category ? .black : .primary)
                                .padding(.horizontal, 12)
                                .frame(height: 32)
                                .background(
                                    selectedCategory == category
                                    ? Color.lightGreen
                                    : Color(.systemGray6)
                                )
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(height: 44)
         //   .background(Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.border.opacity(0.1), lineWidth: 0)
            )
            .cornerRadius(10)

            Button {
                showHistory = true
            } label: {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.title)
                    .foregroundStyle(.border)
            }

            Button {
                showCurrentOrder = true
            } label: {
                Image(systemName: "cart")
                    .font(.title)
                    .foregroundStyle(.border)
            }
        }
        .padding(.horizontal , 4)
        .padding(.bottom, 8)
        
        .navigationDestination(isPresented: $showHistory) {
            HistoryView()
        }
        .navigationDestination(isPresented: $showCurrentOrder) {
            MyOrderView()
        }
    }
}

