//
//  AboutTableViewDataSource.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit

extension AboutViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : schedule.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "About" : "Schedule"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell") as! AboutTableViewCell
        
                cell.descriptionLabel.text = eventInfo
                return cell
                
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationTableViewCell
                    cell.setUpMap()
                 return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! AgendaTableViewCell
            let event = schedule[indexPath.row]
            cell.timeLabel.text = event.time
            cell.titleLabel.text = event.title
            let condition = (indexPath.row % 2) != 0
            let blue = UIColor(red: 82/255, green: 145/255, blue: 199/255, alpha: 1.0)
            cell.backgroundColor =  condition ? blue : UIColor.white
            let textColor = condition ? UIColor.white : blue
            cell.timeLabel.textColor = textColor
            cell.titleLabel.textColor = textColor
            
             return cell
        }
        
    }
}
