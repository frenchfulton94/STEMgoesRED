//
//  SignUpUsernameViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 1/23/18.
//  Copyright © 2018 Michael Fulton Jr. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUpUsernameViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameCheck: UIImageView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
       // goBack()
    }
    @IBAction func signUp(_ sender: UIButton) {
        preValidate {
            [weak self] in
            guard let VC = self else {
                return
            }
            VC.signIn(with: VC.credentials){
                user in
                VC.addToFirebase(user.uid)
                let localUser = VC.createUser(user)
                //VC.addUserInfoToDevice(user: localUser)
                VC.next()
            }
        }
    }
    let ref: DatabaseReference! = Database.database().reference()
    var credentials: Credentials!
    var pageViewController: AppPageViewController!
    var homeContext: Bool = false
    lazy var usernameDelegate:SignUpUsernameTextFieldDelegate = { return SignUpUsernameTextFieldDelegate(self)}()
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = usernameDelegate
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack(){
        let viewController = pageViewController.initialControllers[1] as! SignUpViewController
        viewController.pageViewController = pageViewController
        pageViewController.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
    }
    
    func signIn(with credentials: Credentials, completion: ((User)->())?){
        
        Auth.auth().signIn(withEmail: credentials.0 , password: credentials.1) {
            [weak self] user, error in
            
            guard let VC = self else {
                
                return
            }
            guard let errorMessage = error else {
                
                completion?(user!)
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
    
    func preValidate(completion: @escaping ()->()){
        var handler:((UIAlertAction) -> ())
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
            
            return
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
            return
        }
        checkUsernameAvailability(username) {
            [weak self] response in
            
            guard let VC = self else {
                return
            }
            
            guard response == .Valid else {
                var handler:((UIAlertAction) -> ()) = {
                    _ in
                  
                    VC.usernameTextField.becomeFirstResponder()
                }
                
                VC.showErrorMessage(title: "USERNAME NOT AVAILABLE", message: "Someone already has the username \(username)", handler: handler)
                return
            }
            
            completion()
            
        }
        
    }
    func validateUserName(_ username: String) -> ValidationResponse {
        return .Valid
    }
    private func checkUsernameAvailability(_ username: String, completion: @escaping (ValidationResponse)->()){
        
        ref.child("Users").queryEqual(toValue: usernameTextField.text!).queryOrderedByValue().observeSingleEvent(of: .value){
            snaphot in
            let result = snaphot.exists() ? ValidationResponse.Invalid : ValidationResponse.Valid
            completion(result)
        }
        
        
    }
    
    
    private func showErrorMessage(title: String, message: String, handler: ((UIAlertAction) ->())?){
        let activity = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alert = UIAlertAction(title: "Okay", style: .default, handler: handler)
        activity.addAction(alert)
        present(activity, animated: true, completion: nil)
    }
    
    private func sendEmailVerification(credentials: Credentials) {
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            guard let errorMessage = error else {
                
                return
            }
            
            print(errorMessage)
        }
    }
    
    func addToFirebase(_ userID: String){
        ref.child("Users").child(userID).setValue(usernameTextField.text)
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = usernameTextField.text
        changeRequest?.commitChanges(completion: nil)
        
    }
    
    func next(){
   
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "newHome")
            let viewController = pageViewController.mainControllers.first! as! TriviaCardViewController
            pageViewController.dataSource = pageViewController
            weak var parent = pageViewController.parent as? ContainerViewController
            pageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: {
                _ in
                guard let container = parent else {
                    return
                }
                 container.toggleWelcomeMessage(bool: true)
                if self.homeContext {
                    (viewController as! TriviaCardViewController).playGame()
                } else {
                   container.toggleAboutVC()
                  
                }
                
            })
        
    }
    
    func createUser(_ user: User) -> LocalUser {
        var localUser = LocalUser()
        localUser.email = user.email!
        localUser.userID = user.uid
        localUser.userName = usernameTextField.text!
        return localUser
    }
    
    func addUserInfoToDevice(user: LocalUser) {
        let defaults = UserDefaults.standard
        defaults.setValue(user, forKey: "userInfo")
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
