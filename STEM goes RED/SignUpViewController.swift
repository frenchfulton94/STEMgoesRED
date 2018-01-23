//
//  SignUpViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit
import FirebaseAuth

typealias Email = String
typealias Password = String
typealias Credentials = (Email,Password)

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var emailCheck: UIImageView!
    @IBOutlet weak var usernameCheck: UIImageView!
    @IBOutlet weak var passwordCheck: UIImageView!
    @IBOutlet weak var retypeCheck: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var BackButton: UIBarButtonItem!
    @IBAction func Back(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        guard preValidate() == .Valid else {
            
            return
        }
        signUp()
    }
    
    let valid = UIImage(named: "valid")
    let invalid = UIImage(named: "invalid")
    lazy var emailDelegate:SignUpEmailTextFieldDelegate = {
        return SignUpEmailTextFieldDelegate(self)
    }()
    lazy var usernameDelegate: SignUpUsernameTextFieldDelegate = {
        return SignUpUsernameTextFieldDelegate(self)
    }()
    lazy var passwordDelegate: SignUpPasswordTextFieldDelegate = {
        return SignUpPasswordTextFieldDelegate(self)
    }()
    lazy var retypePasswordDelegate: SignUpRetypePasswordTextFieldDelegate = {
        return SignUpRetypePasswordTextFieldDelegate(self)
    }()
    var pageViewController: AppPageViewController!
    var validationStatus: [String:ValidationResponse] = ["Email" : .None, "Username" : .None, "Password" : .None, "Retype" : .None]
    
    override func viewWillAppear(_ animated: Bool) {
        updateLabel()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = emailDelegate
        
        
        usernameTextField.delegate = usernameDelegate
        
        passwordTextField.delegate = passwordDelegate
        
        retypePasswordTextField.delegate = retypePasswordDelegate
        // Do any additional setup after loading the view.
        
    }
    
    
    func signUp() {
        let email: Email = emailTextField.text!
        let password: Password = passwordTextField.text!
        let credentials: Credentials = (email, password)
        var handler: ((UIAlertAction)->())?
        
        Auth.auth().createUser(withEmail: credentials.0  , password: credentials.1) { [weak self] (user, error) in
            // ...
            guard let VC = self else {
                return
            }
            
            guard let errorMessage = error else {
                print("success")
                
                let completion = {
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "newHome")
                    let viewController = VC.pageViewController.mainControllers.first! as! TriviaCardViewController
                    VC.pageViewController.dataSource = VC.pageViewController
                    weak var parent = VC.pageViewController.parent as? ContainerViewController
                    VC.pageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: {
                        _ in
                        guard let container = parent else {
                            return
                        }
                        
                        container.loadAbout()
                        
                    })
                }
                VC.signIn(credentials: credentials, completion: completion)
               
                
                return
            }
            
            VC.handleSignUpErrors(errorMessage: errorMessage)
        }
    }

    private func sendEmailVerification(credentials: Credentials) {
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            guard let errorMessage = error else {
                
                return
            }
            
            print(errorMessage)
        }
    }
    
    func signIn(credentials: Credentials, completion: (()->())?){
        
        Auth.auth().signIn(withEmail: credentials.0 , password: credentials.1) {
            [weak self] user, error in
            
            guard let VC = self else {
                
                return
            }
            guard let errorMessage = error else {
                completion?()
                return
            }
            let title = (errorMessage._userInfo!["error_name"] as! String).replacingOccurrences(of: "_", with: "").replacingOccurrences(of: "ERROR ", with: "")
            let message = errorMessage.localizedDescription
            var handler:((UIAlertAction)->()) = {
                _ in
                let viewController = VC.pageViewController.initialControllers[1] as! LoginViewController
                viewController.pageViewController = VC.pageViewController
                VC.pageViewController.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
                
            }
            VC.showErrorMessage(title: title, message: message, handler: handler)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleStatus(index: String){
        switch index {
        case "Email":
            if emailCheck.isHidden {
                emailCheck.isHidden = false
            }
            emailCheck.image = validationStatus["Email"] == ValidationResponse.Valid ? valid : invalid
        case "Username":
            usernameCheck.image = validationStatus["Username"] == ValidationResponse.Valid ? valid : invalid
        case "Password":
            passwordCheck.image = validationStatus["Password"] == ValidationResponse.Valid ? valid : invalid
        case "Retye":
            retypeCheck.image = validationStatus["Retype"] == ValidationResponse.Valid ? valid : invalid
        default:
            print()
        }
    }
    
    func validate() -> Bool {
        return Set(validationStatus.values) == Set([ValidationResponse.Valid])
    }
    
    func goBack(){
        pageViewController.setViewControllers([pageViewController.initialControllers.first!], direction: .reverse, animated: true, completion: nil)
    }
    
    func updateLabel(){
        (pageViewController.parent as! ContainerViewController).sectionLabel.text = "Sign Up"
    }
    
    private func showErrorMessage(title: String, message: String, handler: ((UIAlertAction) ->())?){
        let activity = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alert = UIAlertAction(title: "Okay", style: .default, handler: handler)
        activity.addAction(alert)
        present(activity, animated: true, completion: nil)
    }
    
    private func validateUserName(_ username: String) -> ValidationResponse {
        return .Valid
    }
    
    private func checkUsernameAvailability(_ username: String) -> ValidationResponse {
        return .Valid
    }
    
    func handleSignUpErrors(errorMessage: Error){
        let errorName = errorMessage._userInfo!["error_name"] as! String
        let title = errorName.replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "ERROR ", with: "")
        let message = errorMessage.localizedDescription
        var handler: ((UIAlertAction)->())?
        
        print(errorMessage)
        switch errorName {
        case "ERROR_NETWORK_ERROR":
            
            break
            
        case "ERROR_INTERNAL_ERROR":
            break
            
        case "ERROR_INVALID_EMAIL":
            handler = {
                _ in
                self.emailTextField.becomeFirstResponder()
            }
            break
        case "ERROR_EMAIL_ALREADY_IN_USE":
            handler = {
                _ in
                self.emailTextField.becomeFirstResponder()
            }
            break
        case "ERROR_WEAK_PASSWORD":
            handler = {
                _ in
                self.passwordTextField.text = ""
                self.passwordTextField.becomeFirstResponder()
            }
            
        default:
            break
        }
        
        showErrorMessage(title: title , message: message, handler: handler)
        
    }
    
    func preValidate() -> ValidationResponse {
        var handler: ((UIAlertAction)->())?
        
        guard emailTextField.text! != "" else {
            handler = {
                [weak self] _ in
                guard let VC = self else {
                    return
                }
                VC.emailTextField.becomeFirstResponder()
            }
            showErrorMessage(title: "FIELD IS EMPTY", message: "Email field cannot be empty.", handler: handler )
            
            return .Invalid
        }
        let username = usernameTextField.text!
        guard username != "" else {
            handler = {
                [weak self] _ in
                guard let VC = self else {
                    return
                }
                VC.usernameTextField.becomeFirstResponder()
            }
            showErrorMessage(title: "FIELD IS EMPTY", message: "Username field cannot be empty.", handler: handler )
            
            return .Invalid
        }
        
        guard validateUserName(username) == .Valid else {
            handler = {
                [weak self] _ in
                guard let VC = self else {
                    return
                }
                VC.usernameTextField.becomeFirstResponder()
            }
            let message = ""
            showErrorMessage(title: "USERNAME NOT VALID", message: message , handler: handler)
            return .Invalid
        }
        // check availibility of username
        guard checkUsernameAvailability(username) == .Valid else {
            
            handler = {
                [weak self] _ in
                guard let VC = self else {
                    return
                }
                VC.usernameTextField.becomeFirstResponder()
            }
            
            showErrorMessage(title: "USERNAME NOT AVAILABLE", message: "Someon already has the username \(username)", handler: handler)
            return .Exists
        }
        
        
        guard passwordTextField.text! != "" else {
            handler = {
                [weak self] _ in
                guard let VC = self else {
                    return
                }
                VC.passwordTextField.becomeFirstResponder()
            }
            showErrorMessage(title: "FIELD IS EMPTY", message: "Password field can't be empty.", handler: handler )
            
            return .Invalid
        }
        
        guard retypePasswordTextField.text! != "" else {
            handler = {
                [weak self] _ in
                guard let VC = self else {
                    return
                }
                VC.retypePasswordTextField.becomeFirstResponder()
            }
            showErrorMessage(title: "FIELD IS EMPTY", message: "Retype-Password field can't be empty.", handler: handler )
            
            return .Invalid
        }
        guard passwordTextField.text! == retypePasswordTextField.text! else {
            handler = {
                [weak self] _ in
                guard let VC = self else {
                    return
                }
                VC.retypePasswordTextField.text = ""
                VC.retypePasswordTextField.becomeFirstResponder()
            }
            showErrorMessage(title: "PASSWORD DOES NOT MATCH", message: "Retyped password does not match initial password", handler: handler )
            return .Invalid
        }
        
        return .Valid
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
