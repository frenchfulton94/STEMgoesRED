//
//  AboutViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var HeaderToolBar: UIToolbar!
    @IBOutlet weak var eventInformationLabel: UIBarButtonItem!
    @IBOutlet weak var aboutTableView: UITableView!
    
    @IBAction func pull(_ sender: UIPanGestureRecognizer) {
//        let parentView = super.view
//        let yPosition = sender.translation(in: parentView).y
//        
//       
//            view.frame.origin.y = yPosition
//        
//        print("yp: \(yPosition)")
//        print("yo: \(view.frame.origin.y)")
        
       // sender.setTranslation(CGPoint.zero, in: self.view)
        
    }
    typealias event = (String,String)
    var sections: [String] = ["About", "Schedule"]
    var schedule: [event] = []
    
    @IBAction func toggleView(_ sender: UIBarButtonItem) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
