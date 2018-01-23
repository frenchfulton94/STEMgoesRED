//
//  HomeViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TriviaCardViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBAction func Play(_ sender: UIButton) {
    }
    @IBAction func showLeaderboard(_ sender: UIButton) {
    }
    @IBAction func showRules(_ sender: UIButton) {
    }
    
    
    var facts: [Factoid]! = []
    var images: [UIImage]! = []
    var ref: DatabaseReference! = Database.database().reference().child("Factoids")
    var timer: Timer! = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Auth.auth().currentUser?.email)
        ref.observeSingleEvent(of: .value){
            snaphot in
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
    func initTimer(){
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.runSlideShow), userInfo: nil, repeats: true)
    }
//
    @objc func runSlideShow() {
        let num = arc4random_uniform(UInt32(facts.count))
        let image = images[Int(num)]
        let fact = facts[Int(num)]
        let crossFade = CABasicAnimation(keyPath: "contents")
        crossFade.duration = 1.0
        crossFade.fromValue = backgroundImageView.image?.cgImage
        crossFade.toValue = image.cgImage
        if backgroundImageView.layer.animationKeys() != nil {
            backgroundImageView.layer.removeAllAnimations()
        }
        backgroundImageView.layer.add(crossFade, forKey: "animateContents")
        backgroundImageView.image = image
        nameLabel.layer.add(crossFade, forKey: "animateContents")
        nameLabel.text = fact.person
        bioLabel.layer.add(crossFade, forKey:  "animateContents")
        bioLabel.text = fact.bio
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            
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
