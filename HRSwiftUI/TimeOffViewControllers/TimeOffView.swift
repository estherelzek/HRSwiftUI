//
//  TimeOffView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct TimeOffView: View {
    @State private var selectedDate: Date = Date()
    @State private var showTimeOffPopUp = false

    var body: some View {
        ZStack {
            VStack {
                Text("Time Off")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TimeOffTypesCollection()

                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding(.horizontal)
                    .tint(.border)
                    .onChange(of: selectedDate) { _, _ in
                        showTimeOffPopUp = true
                    }
                Spacer()
                presentTypesOftimeOff()
                Spacer()
                ShapeOfTimeOff()
                Spacer()
            }

            if showTimeOffPopUp {
                TimeOffPopUp {
                    showTimeOffPopUp = false
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showTimeOffPopUp)
    }
}

#Preview {
    TimeOffView()
}
