//
//  ViewController.swift
//  PasswordStrengthCheck
//
//  Created by Tecorb Technologies on 15/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rotateIcon: AVFadeImageView!
    
    
  //  @IBOutlet weak var txtForStrength: TextFieldWithPadding!
    @IBOutlet weak var psMeter: AVMeter!
    
    @IBOutlet weak var txtForStrength: StrengthCheckTextField!
    
    let animationDuration: TimeInterval = 0.25
    let switchingInterval: TimeInterval = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rotateIcon.image = UIImage(named: "8")
        // Do any additional setup after loading the view.
    }


    @IBAction func PasswordChange(_ sender: UITextField) {
        let password = sender as? UITextField
        psMeter.iconCheckStatusdelegate = self
        psMeter.updateStrengthIndication(password: password?.text ?? "")
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

/*
 case empty
 case veryWeak
 case weak
 case fair
 case strong
 case veryStrong
 case reasonable
 */

extension ViewController:AVRotateTextIconsDelegate{
    func iconsStatusWithAVMeter(_ psMeter: AVMeter, didChangeStrength passwordStrength: PasswordStrength) {
        print(psMeter)
        print(passwordStrength)
        
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
        
        /*
        if passwordStrength == .strong{
          //  var angle =  0.0
           // angle =  Double.pi / 2
            let i = UIImage(named: "2")//?.fixOrientation()//?.rotate(radians: .pi)
            self.rotateIcon.image = i
           /* UIView.animate(withDuration: 2.0, animations: {
               self.rotateIcon.transform = self.rotateIcon.transform.rotated(by: CGFloat(angle))
            })
            */
        } else {
//            var angle =  0.0
//            angle =  Double.pi
            let i = UIImage(named: "1")//?.rotate(radians: .pi)
            self.rotateIcon.image = i
          /*  UIView.animate(withDuration: 2.0, animations: {
               self.rotateIcon.transform = self.rotateIcon.transform.rotated(by: CGFloat(angle))
            })
            */
        }
        */
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
