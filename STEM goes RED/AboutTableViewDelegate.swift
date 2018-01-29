//
//  AboutTableViewDelegate.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit

extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor(red: 82/255, green: 145/255, blue: 199/255, alpha: 1.0)
    }
}
