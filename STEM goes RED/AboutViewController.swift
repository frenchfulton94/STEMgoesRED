//
//  AboutViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit
import FirebaseDatabase


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
    let ref: DatabaseReference! = Database.database().reference()
    var sections: [String] = ["About", "Schedule"]
    var schedule: [Event] = []
    var isViewable: Bool! = false
    var eventInfo: String!
    
    
    @IBAction func toggleView(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y =  self.isViewable ? self.parent!.view.frame.height - 44 : 47
                
            }, completion: nil)
            let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.aboutTableView.setContentOffset(CGPoint.zero, animated: false)
            
            self.isViewable = self.isViewable ? false : true
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 35;
        view.layer.masksToBounds = true;
        aboutTableView.rowHeight = UITableViewAutomaticDimension
        aboutTableView.estimatedRowHeight = 200.0
        getInfo()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getInfo() {
        ref.child("Information").queryOrdered(byChild: "Time").observe(.value, with: {
            snapshot in
            
            guard snapshot.exists() else {
                print(snapshot)
                return
            }
            print(snapshot)
            let result = snapshot.value! as! [String: Any]
            var temp: [Event] = []
            self.eventInfo = result["About"] as! String
            var event = Event()
            for eventBlock in result["Events"] as! [String: [String:String]] {
                event.title = eventBlock.key
                event.description = eventBlock.value["Summary"]
                event.time = eventBlock.value["Time"]
                event.date = Event.convertToDate(time: event.time)
                event.speaker = eventBlock.value["Speaker"]
                event.location = eventBlock.value["Location"]
                temp.append(event)
            }
            
            temp.sort {
                ev1, ev2 in
                return ev1.date.compare(ev2.date) == .orderedAscending
            }
            
            
            print(temp)
            self.schedule = temp
            DispatchQueue.main.async {
                self.aboutTableView.reloadData()
            }
            
            
            
            
        })
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
