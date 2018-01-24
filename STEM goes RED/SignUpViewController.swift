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
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var emailCheck: UIImageView!
    @IBOutlet weak var passwordCheck: UIImageView!
    @IBOutlet weak var retypeCheck: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var BackButton: UIBarButtonItem!
    @IBAction func Back(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        resignFirstResponder()
        guard preValidate() == .Valid else {
            
            return
        }
        signup(){
            [weak self] in
            guard let VC = self else {
                return
            }
            VC.next()
        }
    }
    
    let valid = UIImage(named: "valid")
    let invalid = UIImage(named: "invalid")
    lazy var emailDelegate:SignUpEmailTextFieldDelegate = {
        return SignUpEmailTextFieldDelegate(self)
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
        
        passwordTextField.delegate = passwordDelegate
        
        retypePasswordTextField.delegate = retypePasswordDelegate
        
       
        // Do any additional setup after loading the view.
        
    }
    
    
    func next() {
        let viewController = pageViewController.initialControllers[3] as! SignUpUsernameViewController
        viewController.credentials = createCredentials()
        viewController.pageViewController = pageViewController
        pageViewController.setViewControllers([viewController], direction: .forward
            , animated: true, completion: nil)
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
    func signup(completion: @escaping ()->()){
        
        Auth.auth().createUser(withEmail: emailTextField.text!  , password: passwordTextField.text!) { [weak self] (user, error) in
            // ...
            guard let VC = self else {
                return
            }
            
            guard let errorMessage = error else {
                print("success")
                completion()
                
                return
            }
            
            VC.handleSignUpErrors(errorMessage: errorMessage)
        }
        
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
    
    func createCredentials() -> Credentials {
        return (emailTextField.text!, passwordTextField.text!)
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
