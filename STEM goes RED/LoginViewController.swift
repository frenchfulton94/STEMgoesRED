//
//  LoginViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBAction func Back(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLabel()
    }
    var validationStatus: [String:ValidationResponse] = ["Username" : .None, "Password" : .None]
    weak var pageViewController: AppPageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let usernameDelegate = UsernameTextFieldDelegate(self, with: .Login)
//        usernameTextField.delegate = usernameDelegate
//        
//        let passwordDelegate = PasswordTextFieldDelegate(self)
//        passwordTextField.delegate = passwordDelegate

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(){
        
    }
    
    func goBack(){
        pageViewController.setViewControllers([pageViewController.initialControllers.first!], direction: .reverse, animated: true, completion: nil)
    }
    
    func updateLabel(){
        (pageViewController.parent as! ContainerViewController).sectionLabel.text = "Login"
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
