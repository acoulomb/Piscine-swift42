//
//  DeathTableViewController.swift
//  day02
//
//  Created by Aubane COULOMBIER on 12/4/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit

class DeathTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
}

class DeathTableViewController: UITableViewController {
    
    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return List.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Death note"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeathCell", for: indexPath) as! DeathTableViewCell
        
        let data = List[indexPath.row]
        cell.nameLabel?.text = data.name
        cell.descLabel?.text = data.description
        cell.dateLabel?.text = data.date
        return cell
    }
}
