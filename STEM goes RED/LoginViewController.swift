//
//  LoginViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    lazy var emailTextFieldDelegate: loginEmailTextFieldDelegate! = {
        return loginEmailTextFieldDelegate(self)
    }()
    lazy var passwordTextFieldDelegate: loginPasswordTextFieldDelegate! = {
        return loginPasswordTextFieldDelegate(self)
    }()
    
    var homeContext: Bool = false
    @IBAction func Back(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLabel()
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        print("login")
        resignFirstResponder()
        print("login")
        let credentials: Credentials = (usernameTextField.text!, passwordTextField.text!)
        loginWithCred(credentials: credentials) {
            [weak self] user in
            guard let VC = self else {
                return
            }
            
            VC.next()
//            var localUser = VC.createUser(user: user)
//
//            var player = VC.createPlayer(user: localUser)
//            VC.getUserName(userID: user.uid){
//                username in
//
//                localUser.userName = username
//                VC.addToLocalStorage(object: localUser, key: "userInfo")
//                player.userInfo = localUser
//                VC.getPlayerInfo(username: username, player: player ){
//
//                }
//
//            }
        }
    }
    
    var validationStatus: [String:ValidationResponse] = ["Username" : .None, "Password" : .None]
    let ref: DatabaseReference! = Database.database().reference()
    weak var pageViewController: AppPageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = emailTextFieldDelegate
        passwordTextField.delegate = passwordTextFieldDelegate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginWithCred(credentials: Credentials, completion: @escaping (User) -> ()){
        Auth.auth().signIn(withEmail:credentials.0 , password: credentials.1) {
            [weak self]   user, error in
            guard let VC = self else {
                return
            }
            
            guard let errorMessage = error else {
                completion(user!)
              
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
    
    func createUser(user: User) -> LocalUser {
        var localUser = LocalUser()
        localUser.email = user.email
        localUser.userID = user.uid
        return localUser
    }
    
    func createPlayer(user: LocalUser) -> Player {
        var player = Player()
        player.userInfo = user
        return player
    }
    
    func addToLocalStorage<T>(object: T, key: String) {
        let defaults = UserDefaults.standard
//        let data = NSKeyedArchiver.archiveRootObject(object, toFile: <#T##String#>)
//        defaults.setValue(<#T##value: Any?##Any?#>, forKeyPath: <#T##String#>)
    }
    
    func getUserName(userID: String, completion: @escaping (String)->()){
        ref.child("Users").child(userID).observeSingleEvent(of: .value) {
            (snapShot) -> () in
            
            guard snapShot.exists() else {
                return
            }
        
            completion((snapShot.value as! String))
            
        }
    }
    
    func getPlayerInfo(username: String, player: Player, completion: @escaping () -> ()){
        //        let defaults = UserDefaults.standard
        //        var localUser = defaults.object(forKey: "userInfo") as! LocalUser
        ref.child("Leaderboard").child(username).observeSingleEvent(of: .value) {
            [weak self] snapShot in
            defer {
                completion()
            }
            guard let VC = self else {
                
                return
            }
            guard snapShot.exists() else {
                return
            }

            let score = snapShot.value as! Int
            var temp = player
            temp.score = score

            VC.addToLocalStorage(object: player, key: "playerInfo")
            
            

        }
    }
    
    func next() {
        let viewController = pageViewController.mainControllers.first!
        UserDefaults.standard.set(true, forKey: "newHome")
        pageViewController.setViewControllers([viewController], direction: .forward, animated:true) {
              [weak self]  finished in
            
            guard let VC = self else {
                return
            }
             (VC.pageViewController.parent as! ContainerViewController).toggleWelcomeMessage(bool: true)
            if VC.homeContext {
                (viewController as! TriviaCardViewController).playGame()
                (VC.pageViewController.parent as! ContainerViewController).childViewControllers[1].viewDidLoad()
            } else {
                (VC.pageViewController.parent as! ContainerViewController).toggleAboutVC()
            }
        }
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
