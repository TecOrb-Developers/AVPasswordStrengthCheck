//
//  AVMeter.swift
//  PasswordStrengthCheck
//
//  Created by Tecorb Technologies on 15/11/22.
//

import Foundation
import UIKit

//PSMeterDelegate
public protocol AVMeterDelegate {
    func psMeter(_ psMeter: AVMeter, didChangeStrength passwordStrength: AVPasswordStrength)
    func psMeter(_ psMeter: AVMeter, didChangeStrength passwordStrength: AVPasswordValidation)
}

public protocol AVRotateTextIconsDelegate {
    func iconsStatusWithAVMeter(_ psMeter: AVMeter, didChangeStrength passwordStrength: AVPasswordStrength)
    func iconsRegexStatusWithAVMeter(_ psMeter: AVMeter, didChangeStrength passwordStrength: AVPasswordValidation)
}

/*
extension AVRotateTextIconsDelegate{
    func iconsRegexStatusWithAVMeter(_ psMeter: AVMeter, didChangeStrength passwordStrength: AVPasswordValidation){}
}
*/

@IBDesignable public class AVMeter: UIView {
    
    var iconCheckStatusdelegate: AVRotateTextIconsDelegate?

    // MARK: Public Attributes

    @IBInspectable public var titleText: String = "passwordStrength".localized {
        didSet {
            self.strengthTitleLabel.text = titleText
        }
    }

    @IBInspectable public var titleTextColor: UIColor = .black {
        didSet {
            self.strengthTitleLabel.textColor = titleTextColor
        }
    }

    public var statesDecorator: AVStrengthViewStatesDecorator! {
        didSet {
            if passwordManager == nil {
                passwordManager = EmptyPasswordManager(decorator: statesDecorator.emptyPasswordDecorator)
            } else {
                passwordManager.updateDecorator(statesDecorator: statesDecorator)
            }
            delegate?.psMeter(self, didChangeStrength: passwordManager.passwordStrength())
            updateView(passwordStrengthManager: passwordManager)
        }
    }

    @IBInspectable public var barBackgroundColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
        didSet {
            strengthProgressBar.barBackgroundColor = barBackgroundColor
        }
    }

    public var font: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            strengthTitleLabel.font = font
            strengthValueLabel.font = font
        }
    }

    public var passwordEstimator: AVPasswordEstimator!

    // MARK: Views
    lazy var parentStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Measurements.VERTICAL_ITEMS_SPACING
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var strengthProgressBar: AVProgressBar = {
        var progressBar = AVProgressBar()
        progressBar.barFillColor = .red
        progressBar.progress = 0.0
        progressBar.displayLabel = false
        progressBar.barBorderColor = .clear
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.heightAnchor.constraint(equalToConstant: Measurements.PROGRESS_BAR_HEIGHT).isActive = true
        return progressBar
    }()

    lazy var labelsStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = Measurements.HORIZONTAL_ITEMS_SPACING
        return stackView
    }()

    lazy var strengthTitleLabel: UILabel = {
        var label = UILabel()
        label.font = font
        label.textColor = titleTextColor
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    lazy var strengthValueLabel: UILabel = {
        var label = UILabel()
        label.font = font
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    // MARK: Variables
    private var passwordManager: AVBasePasswordManager!
    private var passwordValidationManager: AVValidationPasswordManager!

    public var delegate: AVMeterDelegate? {
        didSet {
            delegate?.psMeter(self, didChangeStrength: passwordManager?.passwordStrength() ?? .empty)
        }
    }
    public var passwordStrength: AVPasswordStrength? {
        return passwordManager?.passwordStrength()
    }

    // MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        setupConstraint()
        setInitialDecoratorAndPasswordEstimator()
    }

    private func setupConstraint() {
        labelsStackView.addArrangedSubview(strengthTitleLabel)
        labelsStackView.addArrangedSubview(strengthValueLabel)
        parentStackView.addArrangedSubview(strengthProgressBar)
        parentStackView.addArrangedSubview(labelsStackView)
        addSubview(parentStackView)
        parentStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        parentStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        parentStackView.topAnchor.constraint(equalTo: topAnchor, constant: Measurements.VERTICAL_SPACING).isActive = true
        parentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Measurements.VERTICAL_SPACING).isActive = true
    }

    private func setInitialDecoratorAndPasswordEstimator() {
        statesDecorator = AVStrengthViewStatesDecorator.defaultValues()
        passwordEstimator = DefaultPasswordEstimator()
    }

    public func updateStrengthIndication(password: String) {
        if let previousPasswordManager = passwordManager {
            let currentPasswordManager = PasswordManagerFactory.create(forPassword: password, with: statesDecorator, using: passwordEstimator)
            self.passwordManager = currentPasswordManager
            if currentPasswordManager != previousPasswordManager {
                delegate?.psMeter(self, didChangeStrength: currentPasswordManager.passwordStrength())
            }
            self.updateView(passwordStrengthManager: currentPasswordManager)
            self.iconCheckStatusdelegate?.iconsStatusWithAVMeter(self, didChangeStrength: currentPasswordManager.passwordStrength())
            print("11 \(currentPasswordManager.decorator)")
        } else {
            passwordManager = PasswordManagerFactory.create(forPassword: password, with: statesDecorator, using: passwordEstimator)
            delegate?.psMeter(self, didChangeStrength: passwordManager.passwordStrength())
            updateView(passwordStrengthManager: self.passwordManager)
            print("22")
        }
    }
    
    public func updateValidationStrengthIndication(password: String) {
        if let previousPasswordManager = passwordValidationManager {
            let currentPasswordManager = PasswordManagerFactory.createPasswordValidation(forPassword: password, with: statesDecorator, using: passwordEstimator)
            self.passwordValidationManager = currentPasswordManager
            if currentPasswordManager != previousPasswordManager {
                self.delegate?.psMeter(self, didChangeStrength: currentPasswordManager.passwordStrength())
            }
            self.updateValidationView(passwordStrengthManager: currentPasswordManager)
            self.iconCheckStatusdelegate?.iconsRegexStatusWithAVMeter(self, didChangeStrength: currentPasswordManager.passwordStrength())
            print(currentPasswordManager.passwordStrength())
            print("11 \(currentPasswordManager.decorator)")
        } else {
            self.passwordValidationManager = PasswordManagerFactory.createPasswordValidation(forPassword: password, with: statesDecorator, using: passwordEstimator)
            self.delegate?.psMeter(self, didChangeStrength: passwordManager.passwordStrength())
            self.iconCheckStatusdelegate?.iconsRegexStatusWithAVMeter(self, didChangeStrength: passwordValidationManager.passwordStrength())
            self.updateValidationView(passwordStrengthManager: self.passwordValidationManager)
            print("22")
        }
    }

    private func updateView(passwordStrengthManager: AVBasePasswordManager) {
        strengthProgressBar.animateTo(progress: CGFloat(passwordStrengthManager.strengthValue()))
        strengthValueLabel.text = passwordStrengthManager.strengthTitle()
        UIView.animate(withDuration: 0.2) {
            self.strengthProgressBar.barFillColor = passwordStrengthManager.progressTextColor()
        }
        strengthValueLabel.textColor = passwordStrengthManager.valueTextColor()
    }
    
    private func updateValidationView(passwordStrengthManager: AVValidationPasswordManager) {
        strengthProgressBar.animateTo(progress: CGFloat(passwordStrengthManager.strengthValue()))
        strengthValueLabel.text = passwordStrengthManager.strengthTitle()
        UIView.animate(withDuration: 0.2) {
            self.strengthProgressBar.barFillColor = passwordStrengthManager.progressTextColor()
        }
        strengthValueLabel.textColor = passwordStrengthManager.valueTextColor()
    }
}
