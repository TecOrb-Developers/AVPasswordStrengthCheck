//
//  ViewController.swift
//  PasswordStrengthCheck
//
//  Created by Tecorb Technologies on 15/11/22.
//

import UIKit

class ViewController: UIViewController {
    
  //  @IBOutlet weak var txtForStrength: TextFieldWithPadding!
    @IBOutlet weak var psMeter: AVMeter!
    
    @IBOutlet weak var txtForStrength: TextFieldWithPadding!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func PasswordChange(_ sender: UITextField) {
        let password = sender as? UITextField
        psMeter.updateStrengthIndication(password: password?.text ?? "")
    }
    
}


class TextFieldWithPadding: UITextField {
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
