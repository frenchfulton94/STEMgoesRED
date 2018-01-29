//
//  AppPageViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit
import FirebaseAuth

class AppPageViewController: UIPageViewController {
    lazy var initialControllers: [UIViewController] = {
        return [newViewController(id: "startUp"), newViewController(id: "login"), newViewController(id: "signUp"), newViewController(id: "usernameVC")]
    }()
    let defaults = UserDefaults.standard
    
    lazy var mainControllers: [UIViewController] = {
        return [newViewController(id: "TriviaCard"), newViewController(id: "iDiscoverCard")]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if defaults.bool(forKey: "newHome") {
            do {
                try Auth.auth().signOut()
            } catch {
                
            }
            guard let firstViewController = mainControllers.first else {
                return
            }
            dataSource = self
            setViewControllers([firstViewController], direction: .forward, animated: true){
                animationFinished in
                
            }
        } else {
            
            guard let firstViewController = initialControllers.first else {
                return
            }
            (firstViewController as! StartUpViewController).pageViewController = self
            setViewControllers([firstViewController], direction: .forward, animated: true){
                animationFinished in
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func newViewController(id: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id)
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
