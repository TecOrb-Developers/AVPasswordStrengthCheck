//
//  ViewController.swift
//  PasswordStrengthCheck
//
//  Created by Tecorb Technologies on 15/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rotateIcon: AVFadeImageView!
    @IBOutlet weak var strengthLabel: UILabel!
  //  @IBOutlet weak var txtForStrength: TextFieldWithPadding!
    @IBOutlet weak var psMeter: AVMeter!
    @IBOutlet weak var txtForStrength: StrengthCheckTextField!
    @IBOutlet weak var passwordValidationText: StrengthCheckTextField!
    @IBOutlet weak var avMeter: AVMeter!
    @IBOutlet weak var IconForCheckValidation: AVFadeImageView!
    @IBOutlet weak var validationStatus: UILabel!
    
    
    @IBOutlet weak var btnForLayerAnimation: UIButton!
    
    
    let animationDuration: TimeInterval = 0.25
    let switchingInterval: TimeInterval = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rotateIcon.image = UIImage(named: "8")
        self.IconForCheckValidation.image = UIImage(named: "8")
        self.psMeter.strengthValueLabel.isHidden = true
        self.avMeter.strengthValueLabel.isHidden = true
        self.strengthLabel.text = psMeter.strengthValueLabel.text
        self.validationStatus.text = avMeter.strengthValueLabel.text
        //self.animation()
    }

    @IBAction func PasswordChange(_ sender: UITextField) {
        let password = sender as? UITextField
        psMeter.iconCheckStatusdelegate = self
        self.strengthLabel.text = psMeter.strengthValueLabel.text
        psMeter.updateStrengthIndication(password: password?.text ?? "")
    }
    
    @IBAction func didEndEditingOfCheckValidation(_ sender: StrengthCheckTextField) {
        let password = sender as? UITextField
        print(password?.text)
        avMeter.iconCheckStatusdelegate = self
        self.validationStatus.text = self.avMeter.strengthValueLabel.text
        avMeter.updateValidationStrengthIndication(password: password?.text ?? "")
        print(self.avMeter.strengthValueLabel.text)
    }
    
    @IBAction func actionOnAnimation(_ sender: Any) {
        self.animation()
    }
}

//TextFieldWithPadding
class StrengthCheckTextField: UITextField {
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 20,
        bottom: 10,
        right: 20
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

extension ViewController:AVRotateTextIconsDelegate {
    func iconsStatusWithAVMeter(_ psMeter: AVMeter, didChangeStrength passwordStrength: AVPasswordStrength) {
            if passwordStrength == .empty {
                self.rotateIcon.image = UIImage(named: "8")
            } else if passwordStrength == .veryWeak{
                self.rotateIcon.image = UIImage(named: "7")
            } else if passwordStrength == .weak {
                self.rotateIcon.image = UIImage(named: "3")
            } else if passwordStrength == .fair{
                self.rotateIcon.image = UIImage(named: "6")
            } else if passwordStrength == .strong{
                self.rotateIcon.image = UIImage(named: "11")
            } else if passwordStrength == .veryStrong{
                self.rotateIcon.image = UIImage(named: "10")
            } else if passwordStrength == .reasonable {
                self.rotateIcon.image = UIImage(named: "11")
            }
    }
    
    func iconsRegexStatusWithAVMeter(_ psMeter: AVMeter, didChangeStrength passwordStrength: AVPasswordValidation){
         if passwordStrength == .empty{
            self.IconForCheckValidation.image = UIImage(named: "7")
        } else if passwordStrength == .atLeatEightCount {
            self.IconForCheckValidation.image = UIImage(named: "3")
        } else if passwordStrength == .atLeastOneDigit{
            self.IconForCheckValidation.image = UIImage(named: "6")
        } else if passwordStrength == .atLeastOneLetter{
            self.IconForCheckValidation.image = UIImage(named: "11")
        } else if passwordStrength == .noWhiteSpace{
            self.IconForCheckValidation.image = UIImage(named: "10")
        } else if passwordStrength == .perfect {
            self.IconForCheckValidation.image = UIImage(named: "11")
        }
    }
 }

 extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return rotatedImage ?? self
        }
        return self
    }
}

 extension UIImage {
        func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

class AVFadeImageView: UIImageView
{
    @IBInspectable
    var fadeDuration: Double = 0.900
    override var image: UIImage?
    {
        get {
            return super.image
        }
        set(newImage)
        {
            if let img = newImage
            {
                CATransaction.begin()
                CATransaction.setAnimationDuration(self.fadeDuration)
                let transition = CATransition()
                transition.type = CATransitionType.fade
                super.layer.add(transition, forKey: kCATransition)
                super.image = img
                CATransaction.commit()
            }
            else {
                super.image = nil
            }
        }
    }
}

extension ViewController{
    func animation() {
       CATransaction.begin()
       let layer : CAShapeLayer = CAShapeLayer()
       layer.strokeColor = UIColor.black.cgColor
       layer.lineWidth = 3.0
       layer.fillColor = UIColor.clear.cgColor
       let path : UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.btnForLayerAnimation.frame.width, height: self.btnForLayerAnimation.frame.height), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5.0, height: 0.0))
       layer.path = path.cgPath
       let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
       animation.fromValue = 0.0
       animation.toValue = 1.0
       animation.duration = 14.0
       CATransaction.setCompletionBlock{ [weak self] in
          // self?.animation()
       }
       layer.add(animation, forKey: "myStroke")
       CATransaction.commit()
       self.btnForLayerAnimation.layer.addSublayer(layer)
   }
}
