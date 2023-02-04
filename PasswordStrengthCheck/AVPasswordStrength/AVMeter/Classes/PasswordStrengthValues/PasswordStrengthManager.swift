//
//  VeryWeakStrengthValue.swift
//  PasswordStrengthMeter
//
//  Created by Omar on 9/7/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

class AVValidationPasswordManager: Equatable {

    static func == (lhs: AVValidationPasswordManager, rhs: AVValidationPasswordManager) -> Bool {
        return  lhs.passwordStrength() == rhs.passwordStrength()
    }

    var decorator: ViewDecoratorProtocol

    init(decorator: ViewDecoratorProtocol) {
        self.decorator = decorator
    }

    func valueTextColor() -> UIColor {
        return decorator.textColor
    }
    func progressTextColor() -> UIColor {
        return decorator.progressColor
    }
    func strengthTitle() -> String {
        return decorator.title
    }
    func strengthValue() -> Float {
        fatalError("Not Implemented")
    }
    func passwordStrength() -> AVPasswordValidation {
        fatalError("Not Implemented")
    }
    func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
    }
}

class AVBasePasswordManager: Equatable {

    static func == (lhs: AVBasePasswordManager, rhs: AVBasePasswordManager) -> Bool {
        return lhs.passwordStrength() == rhs.passwordStrength()
    }

    var decorator: ViewDecoratorProtocol
    init(decorator: ViewDecoratorProtocol) {
        self.decorator = decorator
    }

    func valueTextColor() -> UIColor {
        return decorator.textColor
    }
    func progressTextColor() -> UIColor {
        return decorator.progressColor
    }
    func strengthTitle() -> String {
        return decorator.title
    }
    func strengthValue() -> Float {
        fatalError("Not Implemented")
    }
    func passwordStrength() -> AVPasswordStrength {
        fatalError("Not Implemented")
    }

    func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
    }
}

//BasePasswordManager
class EmptyPasswordManager: AVBasePasswordManager {

    override func strengthValue() -> Float {
        return 0
    }

    override func passwordStrength() -> AVPasswordStrength {
        return .empty
    }
    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.emptyPasswordDecorator
    }
}

class VeryWeakStrengthPasswordManager: AVBasePasswordManager {

    override func strengthValue() -> Float {
        return 0.2
    }

    override func passwordStrength() -> AVPasswordStrength {
        return .veryWeak
    }
    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.veryWeakPasswordDecorator
    }
}

class WeakPasswordManager: AVBasePasswordManager {
    override func strengthValue() -> Float {
        return 0.4
    }

    override func passwordStrength() -> AVPasswordStrength {
        return .weak
    }
    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.weakPasswordDecorator
    }
}

class FairPasswordManager: AVBasePasswordManager {
    override func strengthValue() -> Float {
        return 0.6
    }

    override func passwordStrength() -> AVPasswordStrength {
        return .fair
    }
    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.fairPasswordDecorator
    }
}

class StrongPasswordManager: AVBasePasswordManager {
    override func strengthValue() -> Float {
        return 0.8
    }

    override func passwordStrength() -> AVPasswordStrength {
        return .strong
    }
    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.strongPasswordDecorator
    }
}

class VeryStrongStrengthPasswordManager: AVBasePasswordManager {
    override func strengthValue() -> Float {
        return 1.0
    }

    override func passwordStrength() -> AVPasswordStrength {
        return .veryStrong
    }
    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.veryStrongPasswordDecorator
    }
}

//************************* Password Validation For Regex *************************

class AtLeatEightCountPasswordManager: AVValidationPasswordManager {
    override func strengthValue() -> Float {
        return 0.6
    }
    override func passwordStrength() -> AVPasswordValidation {
        return .atLeatEightCount
    }
    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.atLeatEightCountPasswordDecorator
    }
}

class AtLeastOneDigitPasswordManager: AVValidationPasswordManager {
    override func strengthValue() -> Float {
        return 0.7
    }
    
    override func passwordStrength() -> AVPasswordValidation {
        return .atLeastOneDigit
    }
    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.atLeastOneDigitPasswordDecorator
    }
}

class AtLeastOneLetterPasswordManager: AVValidationPasswordManager {
    override func strengthValue() -> Float {
        return 0.6
    }
    
    override func passwordStrength() -> AVPasswordValidation {
        return .atLeastOneLetter
    }

    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.atLeastOneLetterPasswordDecorator
    }
}

class NoWhiteSpaceStrengthPasswordManager: AVValidationPasswordManager {

    override func strengthValue() -> Float {
        return 0.4
    }
    
    override func passwordStrength() -> AVPasswordValidation {
        return .noWhiteSpace
    }

    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.noWhiteSpacePasswordDecorator
    }
}

class PerfectStrengthPasswordManager: AVValidationPasswordManager {
    override func strengthValue() -> Float {
        return 1.0//0.8
    }
    
    override func passwordStrength() -> AVPasswordValidation {
        return .perfect
    }

    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.noWhiteSpacePasswordDecorator
    }
}

class EmmptyPasswordManager: AVValidationPasswordManager {

    override func strengthValue() -> Float {
        return 0.1
    }

    override func passwordStrength() -> AVPasswordValidation {
        return .empty
    }
    override func updateDecorator(statesDecorator: AVStrengthViewStatesDecorator) {
        decorator = statesDecorator.emptyPasswordDecorator
    }
}
