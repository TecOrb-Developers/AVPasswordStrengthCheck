//
//  PasswordEstimator.swift
//  PasswordStrengthMeter
//
//  Created by Omar on 9/15/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import Foundation
//import Navajo_Swift

//PasswordEstimator
public protocol AVPasswordEstimator {
    func estimatePassword(_ password: String) -> AVPasswordStrength
    func estimateValidatePassword(_ password: String) -> AVPasswordValidation
}

struct DefaultPasswordEstimator: AVPasswordEstimator {
    
    func estimatePassword(_ password: String) -> AVPasswordStrength {
        if password.isEmpty {
            return .empty
        } else {
            let strength = Navajo.strength(ofPassword: password)
            switch strength {
            case .veryWeak:
                return .veryWeak
            case .weak:
                return .weak
            case .reasonable:
                return .fair
            case .strong:
                return .strong
            case .veryStrong:
                return .veryStrong
            case .empty:
                return .empty
            case .fair:
                return .fair
            }
        }
    }
    
    func estimateValidatePassword(_ password: String) -> AVPasswordValidation {
        if password.isEmpty {
            return .empty
        } else {
            let strength = Navajo.strengthValidation(ofPassword: password)
            switch strength {
            case .empty:
                return .empty
            case .atLeatEightCount:
                return .atLeatEightCount
            case .atLeastOneDigit:
                return .atLeastOneDigit
            case .atLeastOneLetter:
                return .atLeastOneLetter
            case .noWhiteSpace:
                return .noWhiteSpace
            case .perfect:
                return .perfect
            }
        }
    }

}
