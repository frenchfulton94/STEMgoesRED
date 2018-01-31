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
       playGame()
    }
    @IBAction func showLeaderboard(_ sender: UIButton) {
        let viewController = getViewController(with: "leaderboardVC") as! leaderboardViewController
        present(viewController, animated: true, completion: nil)
    }
    @IBAction func showRules(_ sender: UIButton) {
        presentRules()
    }
    
    
    var facts: [Factoid]! = []
    var images: [UIImage]! = []
    var ref: DatabaseReference! = Database.database().reference()
    var timer: Timer! = Timer()
    var rules: String!
    var appPageViewController: AppPageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRules()
      
        
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
    
    func getViewController(with key:String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: key)
        
    }
    
    func playGame() {
        guard let _ = Auth.auth().currentUser else {
            let vc = appPageViewController.initialControllers.first as! StartUpViewController
            vc.pageViewController = appPageViewController
            vc.homeContext = true
            DispatchQueue.main.async {
                self.appPageViewController.setViewControllers([vc], direction: .reverse, animated: true, completion: nil)
                (self.appPageViewController.parent as! ContainerViewController).toggleWelcomeMessage(bool: false)
            }
            
            return
        }
        let viewController = getViewController(with: "triviaGameVC") as! TriviaGameViewController
        present(viewController, animated: true, completion: nil)
    }
    
    func presentRules() {
        let alert = UIAlertController(title: "How to Play", message: rules, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func getRules(){
        ref.child("Game").child("Rules").observeSingleEvent(of: .value, with: {
            snapshot in
            
            guard snapshot.exists() else {
                return
            }
            let temp = (snapshot.value! as! String).split(separator: ":")
            var new: String = ""
            for rule in temp {
                new.append(rule + "\n\n")
            }
            self.rules = new
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
