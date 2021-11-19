//
//  BiometricIDAuth.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 28.04.2021.
//

import UIKit
import LocalAuthentication

enum BiometricType {
  case none
  case touchID
  case faceID
}

extension StudentsVC {
    
    func biometricType() -> BiometricType {
        let context = LAContext()
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            fatalError()
        }
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        context.localizedFallbackTitle = "Please use your Passcode"
        let reason = "Please identify yourself"
        
        // Returns false if device owner authentication is not available
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            
            // Requests authentication from the user through biometrics or passcode
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [unowned self] success, evaluateError in
                DispatchQueue.main.async {
                    if success {
                        // Remove blur effect if user was authenticate.
                        view.removeBlurEffect()
                        
                    } else {
                        let message: String
                        
                        switch evaluateError {
                        case LAError.authenticationFailed?:
                            message = "There was a problem verifying your identity."
                        case LAError.userCancel?:
                            
                            message = "You will move to log in page for repeat log in process."
                            let ac = UIAlertController(title: "You pressed cancel ⚠️", message: message, preferredStyle: .alert)
                            
                            ac.addAction(UIAlertAction(title: "Authenticate me one more 🎭", style: .default, handler: { _ in
                                authenticateUser()
                            }))
                            
                            ac.addAction(UIAlertAction(title: "Go to login page 🔑", style: .destructive, handler: { _ in
                                present(loginVC, animated: true)
                                view.removeBlurEffect()
                            }))
                            
                            present(ac, animated: true)
                        case LAError.userFallback?:
                            message = "You pressed password."
                        case LAError.biometryNotAvailable?:
                            message = "Face ID/Touch ID is not available."
                        case LAError.biometryNotEnrolled?:
                            message = "Face ID/Touch ID is not set up."
                        case LAError.biometryLockout?:
                            message = "Face ID/Touch ID is locked."
                        default:
                            message = "Face ID/Touch ID may not be configured"
                        }
                        guard let error = evaluateError else {
                            return
                        }
                        print(error)
                    }
                }
            }
            // If user does non have identification enabled
        } else {
            guard let error = error else {
                return
            }
            print(error)
        }
    }
}
