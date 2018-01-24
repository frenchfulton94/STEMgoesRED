//
//  leadboardTableViewDelegate.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 1/23/18.
//  Copyright © 2018 Michael Fulton Jr. All rights reserved.
//

import Foundation
import UIKit

extension leaderboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "boardCell", for: indexPath) as! leaderboardTableViewCell
        let player = players[indexPath.row]
        cell.rankLabel.text = "\(indexPath.row + 1)"
        cell.usernameLabel.text = player.userInfo.userName
        cell.scoreLabel.text = "\(player.score)"
        let condition = (indexPath.row % 2) != 0
        let blue = UIColor(red: 82, green: 145, blue: 199, alpha: 1)
        cell.backgroundColor =  condition ? blue : UIColor.white
        let textColor = condition ? UIColor.white : blue
        cell.rankLabel.textColor = textColor
        cell.usernameLabel.textColor = textColor
        cell.scoreLabel.textColor = textColor
        return cell
    }
}
