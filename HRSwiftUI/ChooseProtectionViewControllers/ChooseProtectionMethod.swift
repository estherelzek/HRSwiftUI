//
//  ChooseProtectionMethod.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 30/04/2026.
//

import SwiftUI
import LocalAuthentication

struct ChooseProtectionMethod: View {
    @State private var selectedMethod: ProtectionMethod? = nil
    @State private var showPinEntry = false
    @State private var showFaceSetup = false
    @State private var showFingerprintSetup = false
    @State private var pin = ""
    @State private var biometricError = ""
    @State private var showError = false
    @Binding var hasSelectedProtection: Bool

    enum ProtectionMethod {
        case faceID, fingerprint, pin, none
    }

    var body: some View {
        VStack(spacing: 32) {

            // MARK: - Header
            VStack(spacing: 8) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(Color(.border))

                Text("App Protection")
                    .font(.title.bold())

                Text("Choose how you want to secure your app every time you open it.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 40)

            // MARK: - Options
            VStack(spacing: 16) {
                ProtectionOptionCard(
                    icon: "faceid",
                    title: "Face ID",
                    description: "Unlock using your face",
                    isSelected: selectedMethod == .faceID
                ) {
                    selectedMethod = .faceID
                    showFaceSetup = true
                }

                ProtectionOptionCard(
                    icon: "touchid",
                    title: "Fingerprint",
                    description: "Unlock using your fingerprint",
                    isSelected: selectedMethod == .fingerprint
                ) {
                    selectedMethod = .fingerprint
                    showFingerprintSetup = true
                }

                ProtectionOptionCard(
                    icon: "lock.fill",
                    title: "PIN Code",
                    description: "Set a 4-digit PIN to unlock",
                    isSelected: selectedMethod == .pin
                ) {
                    selectedMethod = .pin
                    showPinEntry = true
                }
            }
            .padding(.horizontal)

            Spacer()

            // MARK: - No Protection Button
            Button {
                selectedMethod = .none
                hasSelectedProtection = true
            } label: {
                Text("No Protection")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .underline()
            }
            .padding(.bottom, 40)
        }
        // MARK: - PIN Sheet
        .sheet(isPresented: $showPinEntry) {
            PinEntryView(pin: $pin, onDone: {
                showPinEntry = false
                hasSelectedProtection = true
            })
        }
        .fullScreenCover(isPresented: $showFaceSetup, onDismiss: {
            if !hasSelectedProtection { selectedMethod = nil }
        }) {
            FaceAuthentication(onSuccess: {
                showFaceSetup = false
                hasSelectedProtection = true
            })
        }
        .fullScreenCover(isPresented: $showFingerprintSetup, onDismiss: {
            if !hasSelectedProtection { selectedMethod = nil }
        }) {
            FingerAuthentication(
                onSuccess: {
                    showFingerprintSetup = false
                    hasSelectedProtection = true
                },
                onUsePIN: {
                    showFingerprintSetup = false
                    selectedMethod = .pin
                    showPinEntry = true
                },
                onSkip: {
                    showFingerprintSetup = false
                    hasSelectedProtection = true
                }
            )
        }
        // MARK: - Error Alert
        .alert("Biometric Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(biometricError)
        }
    }

    // MARK: - Biometric Auth
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to set protection") { success, authError in
                DispatchQueue.main.async {
                    if success {
                        hasSelectedProtection = true
                    } else {
                        biometricError = authError?.localizedDescription ?? "Authentication failed."
                        showError = true
                        selectedMethod = nil
                    }
                }
            }
        } else {
            biometricError = error?.localizedDescription ?? "Biometrics not available on this device."
            showError = true
            selectedMethod = nil
        }
    }
}

// MARK: - Option Card
struct ProtectionOptionCard: View {
    let icon: String
    let title: String
    let description: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundStyle(isSelected ? .white : Color(.border))
                    .frame(width: 52, height: 52)
                    .background(isSelected ? Color(red: 75/255, green: 100/255, blue: 74/255) : Color(red: 75/255, green: 100/255, blue: 74/255).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.border)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color(red: 75/255, green: 100/255, blue: 74/255) : .secondary)
                    .font(.title3)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color(red: 75/255, green: 100/255, blue: 74/255) : Color(.systemGray5), lineWidth: isSelected ? 2 : 1)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
            )
        }
    }
}

// MARK: - PIN Entry View
struct PinEntryView: View {
    @Binding var pin: String
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Text("Set Your PIN")
                .font(.title2.bold())
                .padding(.top, 40)

            Text("Enter a 4-digit PIN to secure your app")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // PIN Dots
            HStack(spacing: 20) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < pin.count
                              ? Color(red: 75/255, green: 100/255, blue: 74/255)
                              : Color(.systemGray5))
                        .frame(width: 20, height: 20)
                }
            }

            // Number Pad
            VStack(spacing: 16) {
                ForEach([[1,2,3],[4,5,6],[7,8,9]], id: \.self) { row in
                    HStack(spacing: 24) {
                        ForEach(row, id: \.self) { num in
                            PinButton(label: "\(num)") {
                                if pin.count < 4 { pin += "\(num)" }
                            }
                        }
                    }
                }
                HStack(spacing: 24) {
                    PinButton(label: "⌫") {
                        if !pin.isEmpty { pin.removeLast() }
                    }
                    PinButton(label: "0") {
                        if pin.count < 4 { pin += "0" }
                    }
                    PinButton(label: "✓", isConfirm: true) {
                        if pin.count == 4 { onDone() }
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}

// MARK: - PIN Button
struct PinButton: View {
    let label: String
    var isConfirm: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.title2.bold())
                .frame(width: 72, height: 72)
                .background(isConfirm
                            ? Color(red: 75/255, green: 100/255, blue: 74/255)
                            : Color(.systemGray6))
                .foregroundStyle(isConfirm ? .white : .primary)
                .clipShape(Circle())
        }
    }
}

#Preview {
    ChooseProtectionMethod(hasSelectedProtection: .constant(false))
}
