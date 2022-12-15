//
//  BasePasswordStrengthValue.swift
//  PasswordStrengthMeter
//
//  Created by Omar on 9/7/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

class PasswordManagerFactory {

    static func create(forPassword password: String, with decorator: PStrengthViewStatesDecorator, using estimator: PasswordEstimator) -> BasePasswordManager {
        switch estimator.estimatePassword(password) {
        case .empty:
            return EmptyPasswordManager(decorator: decorator.emptyPasswordDecorator)
        case .veryWeak:
            return VeryWeakStrengthPasswordManager(decorator: decorator.veryWeakPasswordDecorator)
        case .weak:
            return WeakPasswordManager(decorator: decorator.weakPasswordDecorator)
        case .fair:
            return FairPasswordManager(decorator: decorator.fairPasswordDecorator)
        case .strong:
            return StrongPasswordManager(decorator: decorator.strongPasswordDecorator)
        case .veryStrong:
            return VeryStrongStrengthPasswordManager(decorator: decorator.veryStrongPasswordDecorator)
        case .reasonable:
            return FairPasswordManager(decorator: decorator.fairPasswordDecorator)
        }
    }
}

public enum PasswordStrength {
    case empty
    case veryWeak
    case weak
    case fair
    case strong
    case veryStrong
    case reasonable
}

open class Navajo {
    /// Gets strength of a password.
    ///
    /// - parameter password: Password string to be calculated
    ///
    /// - returns: Level of strength in NJOPasswordStrength
    public static func strength(ofPassword password: String) -> PasswordStrength {
        return passwordStrength(forEntropy: entropy(of: password))
    }

    /// Converts NJOPasswordStrength to localized string.
    ///
    /// - parameter strength: NJOPasswordStrength to be converted
    ///
    /// - returns: Localized string
    public static func localizedString(forStrength strength: PasswordStrength) -> String {
        switch strength {
        case .veryWeak:
            return NSLocalizedString("NAVAJO_VERY_WEAK", tableName: nil, bundle: Bundle.main, value: "Very Weak", comment: "Navajo - Very weak")
        case .weak:
            return NSLocalizedString("NAVAJO_WEAK", tableName: nil, bundle: Bundle.main, value: "Weak", comment: "Navajo - Weak")
        case .reasonable:
            return NSLocalizedString("NAVAJO_REASONABLE", tableName: nil, bundle: Bundle.main, value: "Reasonable", comment: "Navajo - Reasonable")
        case .strong:
            return NSLocalizedString("NAVAJO_STRONG", tableName: nil, bundle: Bundle.main, value: "Strong", comment: "Navajo - Strong")
        case .veryStrong:
            return NSLocalizedString("NAVAJO_VERY_STRONG", tableName: nil, bundle: Bundle.main, value: "Very Strong", comment: "Navajo - Very Strong")
        case .empty:
            return NSLocalizedString("NAVAJO_EMPTY", tableName: nil, bundle: Bundle.main, value: "Empty", comment: "Navajo - Empty")
        case .fair:
            return NSLocalizedString("NAVAJO_FAIR", tableName: nil, bundle: Bundle.main, value: "Fair", comment: "Navajo - Empty")
        }
    }

    private static func entropy(of string: String) -> Float {
        guard string.count > 0 else {
            return 0
        }
        
        var includesLowercaseCharacter = false,
            includesUppercaseCharacter = false,
            includesDecimalDigitCharacter = false,
            includesPunctuationCharacter = false,
            includesSymbolCharacter = false,
            includesWhitespaceCharacter = false,
            includesNonBaseCharacter = false
        var sizeOfCharacterSet: Float = 0
        string.enumerateSubstrings(in: string.startIndex ..< string.endIndex, options: .byComposedCharacterSequences) { subString, _, _, _ in
            guard let unicodeScalars = subString?.first?.unicodeScalars.first else {
                return
            }

            if !includesLowercaseCharacter && CharacterSet.lowercaseLetters.contains(unicodeScalars) {
                includesLowercaseCharacter = true
                sizeOfCharacterSet += 26
            }

            if !includesUppercaseCharacter && CharacterSet.uppercaseLetters.contains(unicodeScalars) {
                includesUppercaseCharacter = true
                sizeOfCharacterSet += 26
            }

            if !includesDecimalDigitCharacter && CharacterSet.decimalDigits.contains(unicodeScalars) {
                includesDecimalDigitCharacter = true
                sizeOfCharacterSet += 10
            }

            if !includesSymbolCharacter && CharacterSet.symbols.contains(unicodeScalars) {
                includesSymbolCharacter = true
                sizeOfCharacterSet += 10
            }

            if !includesPunctuationCharacter && CharacterSet.punctuationCharacters.contains(unicodeScalars) {
                includesPunctuationCharacter = true
                sizeOfCharacterSet += 20
            }

            if !includesWhitespaceCharacter && CharacterSet.whitespacesAndNewlines.contains(unicodeScalars) {
                includesWhitespaceCharacter = true
                sizeOfCharacterSet += 1
            }

            if !includesNonBaseCharacter && CharacterSet.nonBaseCharacters.contains(unicodeScalars) {
                includesNonBaseCharacter = true
                sizeOfCharacterSet += 32 + 128
            }
        }
        return log2f(sizeOfCharacterSet) * Float(string.count)
    }

    private static func passwordStrength(forEntropy entropy: Float) -> PasswordStrength {
        if entropy < 28 {
            return .veryWeak
        } else if entropy < 36 {
            return .weak
        } else if entropy < 60 {
            return .reasonable
        } else if entropy < 128 {
            return .strong
        } else if entropy == 0 {
            return .empty
        } else if entropy < 128 {
            return .fair
        } else {
            return .veryStrong
        }
    }
}
