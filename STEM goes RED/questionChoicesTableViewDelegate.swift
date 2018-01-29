//
//  questionChoicesTableViewDelegate.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 1/23/18.
//  Copyright © 2018 Michael Fulton Jr. All rights reserved.
//

import Foundation
import UIKit

extension TriviaGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TriviaGameTableViewCell
        let userAnswer = cell.choiceLabel.text!
        print(userAnswer)
        print(cell)
        print(cell.viewController)
        
        let vc = cell.viewController!
        let answer = vc.triviaItems[vc.current].answer
       
        
        let real: String? = userAnswer == answer ? nil : answer
        timer.invalidate()
        displayMessage(answer: real)
       
    }
}
