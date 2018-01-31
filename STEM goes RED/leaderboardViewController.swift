//
//  leaderboardViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 1/23/18.
//  Copyright © 2018 Michael Fulton Jr. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class leaderboardViewController: UIViewController {
    
    @IBOutlet weak var playerPointsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myPointsLabel: UILabel!
    let ref: DatabaseReference! = Database.database().reference()
    var players: [Player] = []
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserScore {
            [weak self]  score in
            
            print(score)
            guard let VC = self else {
                return
            }
            DispatchQueue.main.async {
                
                
                VC.myPointsLabel.isHidden = false
                VC.playerPointsLabel.isHidden = false
                VC.playerPointsLabel.text = "\(score)"
            }
        }
        getLeaderboardInfo(){
            block in
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLeaderboardInfo(completion:([Player]) -> ()){
        ref.child("Game").child("Leaderboard").queryLimited(toFirst: 15).observe(.value){
            [weak self] snapShot in
            guard let VC = self else {
                return
            }
            guard snapShot.exists() else {
                return
            }
            print(snapShot.value)
            let result = snapShot.value! as! [String: Int]
            print(result)
            var player = Player()
            var localUser = LocalUser()
            var temp: [Player] = []
            
            for user in result {
                localUser.userName = user.key
                player.userInfo = localUser
                player.score = user.value
                temp.append(player)
            }
            temp.sort {
                player, player2 in
                
                return player.score > player2.score
            }
            print(temp)
            VC.players = temp
            DispatchQueue.main.async {
                print("i reloaded")
                VC.tableView.reloadData()
            }
        }
    }
    
    func getUserScore(compeletion: @escaping (Int)->()){
        
        getUsername() {
            username in
            guard let userName = username else {
                return
            }
            self.ref.child("Game").child("Leaderboard").child(userName).observeSingleEvent(of: .value, with: {
                snapShot in
                guard snapShot.exists() else {
                    return
                }
                let score = snapShot.value! as! Int
                compeletion(score)
                
            })
        }
    }
    
    func getUsername(completion: @escaping (String?) -> ()){
        guard let user = Auth.auth().currentUser else {
            return
        }
        print("Display Name")
        print(user.displayName)
        completion(user.displayName)
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
