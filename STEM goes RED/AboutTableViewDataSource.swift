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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell") as! AboutTableViewCell
                
                
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationTableViewCell
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! AgendaTableViewCell
        }
        return cell
        
    }
}
