//
//  SignUpRetypePasswordTextFieldDelegate.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 1/18/18.
//  Copyright © 2018 Michael Fulton Jr. All rights reserved.
//

import Foundation
import UIKit

class SignUpRetypePasswordTextFieldDelegate: NSObject, UITextFieldDelegate {
   weak var viewController: SignUpViewController!
    init(_ viewController: SignUpViewController){
        self.viewController = viewController
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {


            guard let retypedPassword = textField.text else {
                return
            }
           
            guard let password = viewController.passwordTextField.text else {
                return
            }
            
            viewController.validationStatus["Retype"] = checkMatch(password, retypedPassword)
            viewController.toggleStatus(index: "Retype")

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if viewController.validate() {
                let email: Email = viewController.emailTextField.text!
                let password: Password = viewController.passwordTextField.text!
                viewController.resignFirstResponder()
                viewController.signIn(credentials:(email, password))
            }
            return true
    }
    
    func checkMatch(_ password: String,_ password2: String) -> ValidationResponse {
        return password == password2 ? ValidationResponse.Valid : ValidationResponse.Invalid
    }
}
