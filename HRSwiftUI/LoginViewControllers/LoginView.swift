//
//  LoginView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 30/04/2026.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var isLoggedIn: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 50) {
                    Spacer(minLength: 20)
                    
                    Image("signIn")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 180, maxHeight: 180)
                        .padding(.top, 12)
                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 6)
                    
                    VStack(spacing: 14) {
                        TextField("Enter Your Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .padding(.horizontal, 14)
                            .frame(height: 50)
                            .background(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.lightGreen, lineWidth: 2)
                            )
                            .cornerRadius(12)
                        
                        SecureField("Enter Your Password", text: $password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding(.horizontal, 14)
                            .frame(height: 50)
                            .background(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.lightGreen, lineWidth: 2)
                            )
                            .cornerRadius(12)
                        
                        Button("LogIn") {
                            // Switching this binding changes the app root to MainTabView.
                            isLoggedIn = true
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.border)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .padding(.top, 8)
                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 6)
                    }
                    .frame(maxWidth: 360)
                    
                    Spacer(minLength: 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
