//
//  BasePasswordStrengthValue.swift
//  PasswordStrengthMeter
//
//  Created by Omar on 9/7/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

class PasswordManagerFactory {
    static func create(forPassword password: String, with decorator: AVStrengthViewStatesDecorator, using estimator: AVPasswordEstimator) -> AVBasePasswordManager {
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
    
    static func createPasswordValidation(forPassword password: String, with decorator: AVStrengthViewStatesDecorator, using estimator: AVPasswordEstimator) -> AVValidationPasswordManager {
        switch estimator.estimateValidatePassword(password) {
        case .atLeatEightCount:
            return AtLeatEightCountPasswordManager(decorator: decorator.atLeatEightCountPasswordDecorator)
        case .atLeastOneDigit:
            return AtLeastOneDigitPasswordManager(decorator: decorator.atLeastOneDigitPasswordDecorator)
        case .atLeastOneLetter:
            return AtLeastOneLetterPasswordManager(decorator: decorator.atLeastOneLetterPasswordDecorator)
        case .noWhiteSpace:
            return NoWhiteSpaceStrengthPasswordManager(decorator: decorator.noWhiteSpacePasswordDecorator)
        case .empty:
            return EmmptyPasswordManager(decorator: decorator.emptyPasswordDecorator)
        case .perfect:
            return PerfectStrengthPasswordManager(decorator: decorator.emptyPasswordDecorator)
        }
    }
    
    
}

/*
 //At least 8 characters
 if password.count < 8 {
     return false
 }

 //At least one digit
 if password.range(of: #"\d+"#, options: .regularExpression) == nil {
     return false
 }

 //At least one letter
 if password.range(of: #"\p{Alphabetic}+"#, options: .regularExpression) == nil {
     return false
 }

 //No whitespace charcters
 if password.range(of: #"\s+"#, options: .regularExpression) != nil {
     return false
 }
 */

//PasswordStrength
public enum AVPasswordStrength {
    case empty
    case veryWeak
    case weak
    case fair
    case strong
    case veryStrong
    case reasonable
}

public enum AVPasswordValidation {
    case empty
    case atLeatEightCount
    case atLeastOneDigit
    case atLeastOneLetter
    case noWhiteSpace
    case perfect
}

open class Navajo {
    /// Gets strength of a password.
    ///
    /// - parameter password: Password string to be calculated
    ///
    /// - returns: Level of strength in NJOPasswordStrength
    public static func strength(ofPassword password: String) -> AVPasswordStrength {
        return passwordStrength(forEntropy: entropy(of: password))
    }
    
    public static func strengthValidation(ofPassword password: String) -> AVPasswordValidation {
        return self.validatePassword(password)
    }

    /// Converts NJOPasswordStrength to localized string.
    ///
    /// - parameter strength: NJOPasswordStrength to be converted
    ///
    /// - returns: Localized string
    public static func localizedString(forStrength strength: AVPasswordStrength) -> String {
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

    private static func passwordStrength(forEntropy entropy: Float) -> AVPasswordStrength {
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
    
   private static func validatePassword(_ password: String) -> AVPasswordValidation {
        if password.count < 8 {
            return .atLeatEightCount
        } else if password.range(of: #"\d+"#, options: .regularExpression) == nil {
            return .atLeastOneDigit
        } else if password.range(of: #"\p{Alphabetic}+"#, options: .regularExpression) == nil {
            return .atLeastOneLetter
        } else if password.range(of: #"\s+"#, options: .regularExpression) != nil {
            return .noWhiteSpace
        } else {
            return .perfect
        }
    }
}
