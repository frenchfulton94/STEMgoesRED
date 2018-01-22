//
//  PasswordTextFieldDelegate.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import Foundation
import UIKit

class SignUpPasswordTextFieldDelegate: NSObject, UITextFieldDelegate {
    weak var viewController: SignUpViewController!
    init(_ viewController: SignUpViewController){
        self.viewController = viewController
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
//        guard let password = textField.text else {
//            return
//        }
//        
//        viewController.validationStatus["Password"] = validate(password)
//        
//        viewController.toggleStatus(index: "Password")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            viewController.retypePasswordTextField.becomeFirstResponder()
            return true
    }
    private func validate(_ password: String) -> ValidationResponse {
        // Regular expression for handling password validation
        return ValidationResponse.Invalid
    }
    

}
