//
//  TimeOffPopUp.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 06/05/2026.
//

import SwiftUI

struct TimeOffPopUp: View {
    @State private var isHalfDay = false
    var onClose: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 25) {
                HStack {
                    Text("Time Off Request")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button {
                        onClose?()
                    } label: {
                        Image(systemName: "x.circle.fill")

                    }
                    .font(.headline)
                    .foregroundStyle(.border)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Time Off Type")
                        .foregroundStyle(.border)
                        .font(Font.title2.bold())
                    Button {
                        // Open leave type picker
                    } label: {
                        HStack {
                            Text("Select Leave Type")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 14)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("borderColor"), lineWidth: 1.5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        HStack(spacing: 10) {
                            Button {
                                isHalfDay.toggle()
                            } label: {
                                Image(systemName: isHalfDay ? "checkmark.square.fill" : "square")
                                    .foregroundStyle(.border)
                                    .font(.title3)
                            }
                            .buttonStyle(.plain)
                            
                            Text("Half Day")
                        }
                        Spacer()
                        HStack(spacing: 10) {
                            Button {
                                // Toggle full day
                            } label: {
                                Image(systemName: "square")
                                    .foregroundStyle(.border)
                                    .font(.title3)
                            }
                            .buttonStyle(.plain)
                            
                            Text("Full Day")
                            
                            
                        }
                        
                    }
                    Text("Date")
                        .foregroundStyle(.border)
                        .font(Font.title2.bold())
                    HStack(spacing: 6) {
                        ForEach(["Start Date", "End Date", "Morning"], id: \.self) { label in
                            HStack(spacing: 2) {
                                Text(label)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                Image(systemName: "chevron.down")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 8)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("borderColor"), lineWidth: 1.5)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    //
                    Text("Clock")
                        .foregroundStyle(.border)
                        .font(Font.title2.bold())
                    HStack(spacing: 6) {
                        ForEach(["From", "To"], id: \.self) { label in
                            HStack(spacing: 2) {
                                Text(label)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                Image(systemName: "chevron.down")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 8)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("borderColor"), lineWidth: 1.5)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    HStack(spacing: 12){
                        Text("Duration")
                            .foregroundStyle(.border)
                                .font(Font.title2.bold())
                        Spacer()
                        Text("1.5 Days")
                            .font(.title3)
                    }
                    Text("Description")
                        .foregroundStyle(.border)
                        .font(Font.title2.bold())
                    TextField("Add description (optional)", text: .constant(""))
                    .padding()
                        .background(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("borderColor"), lineWidth: 1.5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
            }
        }
    
}

#Preview {
    TimeOffPopUp()
}
