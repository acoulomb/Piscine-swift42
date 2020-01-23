//
//  FirstViewController.swift
//  day05
//
//  Created by Aubane COULOMBIER on 12/16/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit

let reusableCellIdentifier = "PlaceCell"

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var PlaceList: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PlaceList.dequeueReusableCell(withIdentifier: reusableCellIdentifier, for: indexPath) as! PlaceTableViewCell
        
        let data = Places[indexPath.row]
        cell.Name.text = data.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "unwindToMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let indexPath = PlaceList.indexPathForSelectedRow {
            let destination = segue.destination as! SecondViewController
            destination.selectedPlace = Places[indexPath.row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PlaceList.delegate = self
        self.PlaceList.dataSource = self
    }
}

