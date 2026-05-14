import Foundation
import LocalAuthentication

final class FingerPrintHandlingManager {
    func authenticate(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to proceed"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    completion(success, authError?.localizedDescription)
                }
            }
        } else {
            completion(false, "Biometric authentication not available.")
        }
    }
}
