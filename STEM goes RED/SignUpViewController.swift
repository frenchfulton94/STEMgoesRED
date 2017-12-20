//
//  SignUpViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var userImageButton: UIButton!
    @IBAction func changeImage(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let emailDelegate = EmailTextFieldDelegate()
        emailTextField.delegate = emailDelegate
        
        let usernameDelegate = UsernameTextFieldDelegate()
        usernameTextField.delegate = usernameDelegate
        
        let passwordDelegate = PasswordTextFieldDelegate()
        passwordTextField.delegate = passwordDelegate
        
        let retypePasswordDelegate = PasswordTextFieldDelegate()
        retypePasswordTextField.delegate = retypePasswordDelegate
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
