//
//  UsernameTextFieldDelegate.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import Foundation
import UIKit


class SignUpUsernameTextFieldDelegate: NSObject, UITextFieldDelegate {
    weak var viewController: SignUpViewController!
    
    private var valid: ValidationResponse = .None
    init(_ viewController: SignUpViewController) {
        self.viewController = viewController
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//        guard let username = textField.text else {
//            return
//        }
//        
//        viewController.validationStatus["Username"] = validate(username)
//        viewController.toggleStatus(index: "Username")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        viewController.passwordTextField.becomeFirstResponder()
        return true
        
    }
    
    private func validate(_ username:String) -> ValidationResponse{
        
        return ValidationResponse.Valid
    }
    
}
