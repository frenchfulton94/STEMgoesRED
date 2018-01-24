//
//  EmailTextFieldDelegate.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignUpEmailTextFieldDelegate:NSObject, UITextFieldDelegate {
    weak var viewController: SignUpViewController!
    let valid = UIImage(named: "valid")
    let invalid = UIImage(named: "invalid")
    init(_ viewController: SignUpViewController) {
        self.viewController = viewController
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard let email = textField.text else {
//            return
//        }
//
//        let result: ValidationResponse = validate(email)
//        viewController.validationStatus["Email"] = result
//        viewController.toggleStatus(index: "Email")

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        viewController.passwordTextField.becomeFirstResponder()
        
        return true
    }
    
    func validate(_ email: String?) -> ValidationResponse {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email) ? ValidationResponse.Valid : ValidationResponse.Invalid
    }
    
}
