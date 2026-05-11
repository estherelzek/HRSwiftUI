//
//  FingerAuthentication.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 03/05/2026.
//

import SwiftUI
import LocalAuthentication

struct FingerAuthentication: View {
    @State private var isTouchIDAvailable = false
    @State private var message = "Use your fingerprint to unlock the app quickly and securely."
    
    var onSuccess: (() -> Void)? = nil
    var onUsePIN: (() -> Void)? = nil
    var onSkip: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 50)
            
            Image(systemName: "touchid")
                .font(.system(size: 56))
                .foregroundStyle(Color(red: 75/255, green: 100/255, blue: 74/255))
            
            Text("Enable Fingerprint")
                .font(.title2.weight(.semibold))
            
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
            
            VStack(spacing: 12) {
                Button {
                    authenticateWithTouchID()
                } label: {
                    Text(isTouchIDAvailable ? "Use Touch ID" : "Touch ID Not Available")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(isTouchIDAvailable ? Color.green : Color.gray.opacity(0.4))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(!isTouchIDAvailable)
                
               
                Button("Skip for Now") {
                    onSkip?()
                }
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear(perform: checkTouchIDAvailability)
    }
    
    private func checkTouchIDAvailability() {
        let context = LAContext()
        var error: NSError?
        
        let canUseBiometrics = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        isTouchIDAvailable = canUseBiometrics && context.biometryType == .touchID
        
        if !isTouchIDAvailable {
            message = "Fingerprint unlock is not available on this iPhone. You can continue with PIN."
        }
    }
    
    private func authenticateWithTouchID() {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error),
              context.biometryType == .touchID else {
            message = "Touch is ID unavailable. Please use PIN."
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock HR app with Touch ID") { success, _ in
            DispatchQueue.main.async {
                if success {
                    onSuccess?()
                } else {
                    message = "Authentication failed. Try again or use PIN."
                }
            }
        }
    }
}

#Preview {
    FingerAuthentication()
}
