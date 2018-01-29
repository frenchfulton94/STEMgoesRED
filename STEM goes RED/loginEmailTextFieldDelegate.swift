//
//  loginEmailTextFieldDelegate.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 1/24/18.
//  Copyright © 2018 Michael Fulton Jr. All rights reserved.
//

import Foundation
import UIKit

class loginEmailTextFieldDelegate: NSObject, UITextFieldDelegate {
    weak var viewController: LoginViewController!
    init(_ viewController: LoginViewController){
        self.viewController = viewController
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewController.passwordTextField.becomeFirstResponder()
        return true
    }
    
    
}
