//
//  StartUpViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit

class StartUpViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    weak var pageViewController: AppPageViewController!
    var homeContext: Bool! = false

    @IBAction func login(_ sender: UIButton) {
        weak var viewController = pageViewController.initialControllers[1] as? LoginViewController
        guard let vc = viewController else {
            return
        }
        vc.pageViewController = pageViewController
        vc.homeContext = homeContext
        pageViewController.setViewControllers([vc], direction: .forward, animated: true) {
            animationFinished in
            
        }
    
    }
    override func viewWillAppear(_ animated: Bool) {
        updateLabel()
    }
    @IBAction func signUp(_ sender: UIButton) {
            weak var viewController = pageViewController.initialControllers[2] as? SignUpViewController
        guard let vc = viewController else {
            return
        }
       vc.pageViewController = pageViewController
        vc.homeContext = homeContext

        
        pageViewController.setViewControllers([vc], direction: .forward, animated: true) {
            animationFinished in
           
        }
    }
    @IBAction func skip(_ sender: UIButton) {
           weak var viewController = pageViewController.mainControllers.first! as? TriviaCardViewController
        guard let VC = viewController else {
            return
        }
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "newHome")
        pageViewController.dataSource = pageViewController
        weak var parent = pageViewController.parent as? ContainerViewController
        VC.appPageViewController = pageViewController
        pageViewController.setViewControllers([VC], direction: .forward, animated: true){ _ in
            guard let container = parent else {
                return
            }
            container.toggleWelcomeMessage(bool: true)
          container.toggleAboutVC()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = UserDefaults.standard.bool(forKey: "newHome") ? "Cancel" : "Skip"
        skipButton.setTitle(title, for: .normal)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateLabel(){
        (pageViewController.parent as! ContainerViewController).sectionLabel.text = "WELCOME"
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
