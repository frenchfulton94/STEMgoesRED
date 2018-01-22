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
        
        Auth.auth().createUser(withEmail: email  , password: password) { [weak self] (user, error) in
            // ...
            
            guard let errorMessage = error else {
                print("success")
                
                return
            }
            
           
            print(errorMessage)
            print(errorMessage._userInfo)
            
//            if let errCode = AuthErrorCode(rawValue: error!.l) {
//                print(errCode)
////                switch errCode {
////                case .ErrorCodeInvalidEmail:
////                    print("invalid email")
////                case .ErrorCodeEmailAlreadyInUse:
////                    print("in use")
////                default:
////                    print("Create User Error: \(error!)")
////                }
//            }
            
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
    
    func signIn(credentials: Credentials){
        
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
