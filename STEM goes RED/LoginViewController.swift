//
//  LoginViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
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
    
    @IBAction func login(_ sender: UIButton) {
        let credentials: Credentials = (usernameTextField.text!, passwordTextField.text!)
        loginWithCred(credentials: credentials)
    }
    
    var validationStatus: [String:ValidationResponse] = ["Username" : .None, "Password" : .None]
    weak var pageViewController: AppPageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginWithCred(credentials: Credentials){
        Auth.auth().signIn(withEmail:credentials.0 , password: credentials.1) {
         [weak self]   user, error in
            guard let VC = self else {
                return
            }
            
            guard let errorMessage = error else {
                
                let viewController = VC.pageViewController.mainControllers.first!
                UserDefaults.standard.set(true, forKey: "newHome")
                VC.pageViewController.setViewControllers([viewController], direction: .forward, animated:true , completion: nil)
                return
            }
          VC.handleError(error: errorMessage)
            
            
        }
        
    }
    
    func goBack(){
        pageViewController.setViewControllers([pageViewController.initialControllers.first!], direction: .reverse, animated: true, completion: nil)
    }
    
    func updateLabel(){
        (pageViewController.parent as! ContainerViewController).sectionLabel.text = "Login"
    }
    
    func handleError(error: Error){
        let title = (error._userInfo!["error_name"] as! String).replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "ERROR ", with: "")
        let message = error.localizedDescription
        
        let activity = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alert = UIAlertAction(title: "Okay", style: .default){
          [weak self]  _ in
            guard let VC = self else {
                return
            }
        }
        
        activity.addAction(alert)
        present(activity, animated: true, completion: nil)
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
