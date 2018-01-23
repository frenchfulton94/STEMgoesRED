//
//  ContainerViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit
import Firebase

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var sectionLabel: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBAction func pull(_ sender: UIPanGestureRecognizer) {
        let yPosition = sender.translation(in: view).y
       
        if view.subviews.count > 3 {
             print(view.subviews)
            view.subviews[3].frame.origin.y = yPosition
        }
        sender.setTranslation(CGPoint.zero, in: view)
    }
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener {
            (auth, user) in
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pageController = storyboard.instantiateViewController(withIdentifier: "AppPageController") as! AppPageViewController
        
        addChildViewController(pageController)
        let pageControllerView = pageController.view!
        pageControllerView.frame.size.height = view.frame.height
        pageControllerView.frame.size.width = view.frame.width
        pageControllerView.frame.origin.x = 0
        pageControllerView.frame.origin.y = 0
        view.addSubview(pageControllerView)
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "newHome") {
            loadAbout()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAbout() {
        DispatchQueue.main.async {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let infoVC = storyboard.instantiateViewController(withIdentifier: "infoVC") as! AboutViewController
            let infoView = infoVC.view
            infoView!.frame = CGRect(x: 0, y: self.view.frame.height - 44, width: self.view.frame.width, height: self.view.frame.height - 44 )
            
            self.addChildViewController(infoVC)
            self.view.addSubview(infoView!)
            
        }
    }
    func removeAbout() {
        DispatchQueue.main.async {
        
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
