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
    weak var viewController: SignUpUsernameViewController!
    
    private var valid: ValidationResponse = .None
    init(_ viewController: SignUpUsernameViewController) {
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
        
        viewController.signUp(UIButton())
        return true
        
    }
    
 
}
