//
//  ValuesTextColors.swift
//  PasswordStrengthMeter
//
//  Created by Omar on 9/7/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit
//PStrengthViewStatesDecorator
public struct AVStrengthViewStatesDecorator {
    
    var emptyPasswordDecorator: StateDecorator!
    var veryWeakPasswordDecorator: StateDecorator!
    var weakPasswordDecorator: StateDecorator!
    var fairPasswordDecorator: StateDecorator!
    var strongPasswordDecorator: StateDecorator!
    var veryStrongPasswordDecorator: StateDecorator!
    
    var atLeatEightCountPasswordDecorator : StateDecorator!
    var atLeastOneDigitPasswordDecorator : StateDecorator!
    var atLeastOneLetterPasswordDecorator : StateDecorator!
    var noWhiteSpacePasswordDecorator : StateDecorator!
    
    
    static let veryWeakColor = #colorLiteral(red: 0.8705882353, green: 0.02745098039, blue: 0, alpha: 1)
    static let weakColor = #colorLiteral(red: 0.8666666667, green: 0.2196078431, blue: 0.003921568627, alpha: 1)
    static let fairColor = #colorLiteral(red: 0.9960784314, green: 0.7960784314, blue: 0, alpha: 1)
    static let strongColor = #colorLiteral(red: 0.1843137255, green: 0.9019607843, blue: 0.0431372549, alpha: 1)
    static let veryStrongColor = #colorLiteral(red: 0.1058823529, green: 0.5882352941, blue: 0.02352941176, alpha: 1)
    
    public init(
        emptyPasswordDecorator: StateDecorator,
        veryWeakPasswordDecorator: StateDecorator,
        weakPasswordDecorator: StateDecorator,
        fairPasswordDecorator: StateDecorator,
        strongPasswordDecorator: StateDecorator,
        veryStrongPasswordDecorator: StateDecorator,atLeatEightCountPasswordDecorator:StateDecorator, atLeastOneDigitPasswordDecorator: StateDecorator, atLeastOneLetterPasswordDecorator:StateDecorator,
        noWhiteSpacePasswordDecorator: StateDecorator) {
            self.emptyPasswordDecorator = emptyPasswordDecorator
            self.veryWeakPasswordDecorator = veryWeakPasswordDecorator
            self.weakPasswordDecorator = weakPasswordDecorator
            self.fairPasswordDecorator = fairPasswordDecorator
            self.strongPasswordDecorator = strongPasswordDecorator
            self.veryStrongPasswordDecorator = veryStrongPasswordDecorator
            
            
            self.atLeatEightCountPasswordDecorator = atLeatEightCountPasswordDecorator
            self.atLeastOneDigitPasswordDecorator = atLeastOneDigitPasswordDecorator
            self.atLeastOneLetterPasswordDecorator = atLeastOneLetterPasswordDecorator
            self.noWhiteSpacePasswordDecorator = noWhiteSpacePasswordDecorator
        }
    
    public static func defaultValues() -> AVStrengthViewStatesDecorator {
        return AVStrengthViewStatesDecorator(
            emptyPasswordDecorator: StateDecorator(text: "--", textColor: .gray, progressColor: .gray),
            veryWeakPasswordDecorator: StateDecorator(text: "veryWeak".localized, textColor: veryWeakColor, progressColor: veryWeakColor),
            weakPasswordDecorator: StateDecorator(text: "weak".localized, textColor: weakColor, progressColor: weakColor),
            fairPasswordDecorator: StateDecorator(text: "fair".localized, textColor: fairColor, progressColor: fairColor),
            strongPasswordDecorator: StateDecorator(text: "strong".localized, textColor: strongColor, progressColor: strongColor),
            veryStrongPasswordDecorator: StateDecorator(text: "veryStrong".localized, textColor: veryStrongColor, progressColor: veryStrongColor),
            
            
            atLeatEightCountPasswordDecorator: StateDecorator(text: "At Least 8 Count", textColor: veryWeakColor, progressColor: veryWeakColor),
            atLeastOneDigitPasswordDecorator: StateDecorator(text: "At Least one digit", textColor: veryWeakColor, progressColor: veryWeakColor),
            atLeastOneLetterPasswordDecorator: StateDecorator(text: "At Least one Letter", textColor: veryWeakColor, progressColor: veryWeakColor),
            noWhiteSpacePasswordDecorator: StateDecorator(text: "no white space", textColor: veryWeakColor, progressColor: veryWeakColor)
        )
    }
    
}

public struct StateDecorator: ViewDecoratorProtocol {
    var title: String!
    var textColor: UIColor!
    var progressColor: UIColor!

    public init(
        text: String,
        textColor: UIColor,
        progressColor: UIColor) {
        self.title = text
        self.textColor = textColor
        self.progressColor = progressColor
    }
}

protocol ViewDecoratorProtocol {
    var title: String! {get set}
    var textColor: UIColor! {get set}
    var progressColor: UIColor! {get set}
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.init(for: AVMeter.self), value: "", comment: "")
    }
}
