//
//  TriviaGameViewController.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 1/23/18.
//  Copyright © 2018 Michael Fulton Jr. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TriviaGameViewController: UIViewController {
    
    
    @IBOutlet weak var questionTimeLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionChoicesTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!
    var current: Int = 0
    var localScore: Int = 0
    var correct: Int!
    var incorrect: Int!
    var username: String!
    var questionLength: Float!
    var questionTime: Int = 0
    var choices:[String?] = [nil, nil, nil, nil]
    var timer: Timer! = Timer()
    var triviaItems: [TriviaItem] = []
    let ref: DatabaseReference! = Database.database().reference()
    
    @IBAction func quit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGame {
            [weak self] in
            guard let VC = self else {
                return
            }
            VC.getTriviaItems {
                triviaitems in
                VC.triviaItems = triviaitems
                DispatchQueue.main.async {
                    print(triviaitems)
                    VC.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self?.runGame), userInfo: nil, repeats: true)
                    VC.updateQuestion()
                    VC.questionTimeLabel.text = "\(VC.questionLength!)s"
                    VC.playerScoreLabel.text = "\(VC.localScore)"
                    VC.questionChoicesTableView.reloadData()
                    VC.timer.fire()
                    
                }
            }
        }
    }
    
    @objc func runGame(){
        DispatchQueue.main.async {
            self.updateTime()
            if self.questionTime == 0 {
                self.timer.invalidate()
                let answer = self.triviaItems[self.current].answer
                self.displayMessage(answer: answer)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpGame(completion: @escaping ()->()){
        ref.child("Game").child("Information").observeSingleEvent(of: .value, with: {
            [weak self] snapshot in
            
            guard let VC = self else {
                return
            }
            
            guard snapshot.exists() else {
                return
            }
            let result = snapshot.value! as! [String: Any]
            print(result)
            VC.questionLength = result["QuestionLength"] as! Float
            VC.questionTime = result["QuestionLength"] as! Int
            VC.correct = result["Correct"] as! Int
            VC.incorrect = result["Incorrect"] as! Int
            
            VC.getOnlineScore {
                
                completion()
                
            }
        })
        
    }
    func updateQuestion(){
        if current < triviaItems.count {
            let triviaItem = triviaItems[current]
            questionLabel.text = triviaItem.question
            questionTime = Int(questionLength)
            updateChoices()
        } else {
            
        }
    }
    
    
    
    func getOnlineScore(completion: @escaping ()->()) {
        getUsername {
            [weak self] username in
            print(username)
            guard let VC = self else {
                return
            }
            VC.username = username
            VC.ref.child("Game").child("Leaderboard").child(username).observeSingleEvent(of: .value, with: {
                snapshot in
                
                guard snapshot.exists() else {
                    
                    completion()
                    return
                }
                
                VC.localScore = snapshot.value! as! Int
                completion()
            })
            
        }
        
    }
    
    func getUsername(completion: @escaping (String) -> ()){
        let uid = Auth.auth().currentUser!.uid
        ref.child("Users").child(uid).observeSingleEvent(of: .value, with: {[weak self] snapshot in
            
            guard let VC = self else {
                return
            }
            
            guard snapshot.exists() else {
                return
            }
            
            let username = snapshot.value! as! String
            completion(username)
        })
    }
    
    func updateScore(isCorrect: Bool){
        
        let value: Int! = isCorrect ? correct : incorrect
        if (localScore + value) >= 0 {
            localScore += value
        }
    }
    
    func updateTime() {
        questionTimeLabel.text = "\(questionTime)s"
        questionTime -= 1
        
        
    }
    
    func endGame(){
        
    }
    
    func saveScore(){
        ref.child("Game").child("Leaderboard").child(username).setValue(localScore)
        
    }
    func updateUI() {
        playerScoreLabel.text = "\(localScore)"
        questionChoicesTableView.reloadData()
    }
    
    
    
    func displayMessage(answer: String?){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        defer {
            let num = answer == nil ? 0.5 : 1.0
            let when = DispatchTime.now() + num // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true) {
                    let result = answer == nil ? true : false
                    self.updateScore(isCorrect: result)
                    
                    self.current += 1
                   
                    if self.current < self.triviaItems.count {
                        self.updateQuestion()
                         self.updateUI()
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runGame), userInfo: nil, repeats: true)
                        self.timer.fire()
                    } else {
                         self.updateUI()
                        alert.title = "Game Over"
                        alert.message = "You score is \(self.localScore)"
                        let goHome = UIAlertAction(title: "Leave Game", style: .default, handler: {action in
                               self.dismiss(animated: true, completion: self.saveScore)
                        })
                        alert.addAction(goHome)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        guard let real = answer else {
            alert.title = "CORRECT"
            present(alert, animated: true, completion: nil)
            return
        }
        
        alert.title = "INCORRECT"
        alert.message = "The correct answer is \(real)"
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func updateChoices(){
        choices = [nil, nil, nil, nil]
        var set:Set<Int> = Set([ 0, 1, 2, 3 ])
        var num = Int(arc4random_uniform(UInt32(set.count)))
        print(set.count)
        print(num)
        let category = triviaItems[current].category
        print(choices)
        choices[num] = triviaItems[current].answer!
        print(choices)
        set.remove(num)
        var temp:[String] = []
        let _ = triviaItems.filter{
            triviaItem in
            
            if triviaItem.category == category && temp.count < set.count {
                if triviaItem.answer != triviaItems[current].answer {
                    temp.append(triviaItem.answer)
                }
                return true
            }
            return false
        }
        var choiceNum: Int
        while set.count != 0 {
            choiceNum = Int(arc4random_uniform(UInt32(temp.count)))
            num =  Int(arc4random_uniform(UInt32(set.count)))
            
            
            num = 0
            
            print(choiceNum)
            print(num)
            
            print(temp)
            print(set)
            let choice = temp[choiceNum]
            temp.remove(at: choiceNum)
            
            let n = set.index(set.startIndex, offsetBy: num)
            let value = set[n]
            choices[value] = choice
            set.remove(value)
            
        }
    }
    
    func getTriviaItems(completion: @escaping ([TriviaItem])->()) {
        ref.child("Game").child("Questions").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            
            guard let VC = self else {
                return
            }
            
            guard snapshot.exists() else {
                return
            }
            var triviaItem = TriviaItem()
            let result = snapshot.value! as! Array<[String: String]>
            var temp:[TriviaItem] = []
            for item in result {
                triviaItem.question = item["Question"]
                triviaItem.answer = item["Answer"]
                triviaItem.category = item["Category"]
                temp.append(triviaItem)
            }
            completion(temp)
            
            
            
            
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
