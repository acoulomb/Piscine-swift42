//
//  EventsController.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/15/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import UIKit

let eventCellReuseIdentifier = "EventCell"

class EventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventList: UITableView!
    
    @IBAction func unwindFromFilter(for unwindSegue: UIStoryboardSegue) {
        self.eventList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EventsSelected = indexPath.row
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.eventList.dequeueReusableCell(withIdentifier: eventCellReuseIdentifier) as! EventCell
        let eventData = FilteredEvents[indexPath.row]
        cell.name.text = eventData.name
        cell.date.text = eventData.startAt.description
        cell.type.text = eventData.kind
        var cursus: String = ""
        for cursusid in eventData.cursusId {
            if Cursus[cursusid] != nil {
                cursus += "\(Cursus[cursusid]!.name) "
            }
        }
        cell.cursus.text = cursus
        var campus: String = ""
        for campusid in eventData.campusId {
            if Campus[campusid] != nil {
                campus += "\(Campus[campusid]!.name) "
            }
        }
        cell.campus.text = campus
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventList.delegate = self
        self.eventList.dataSource = self
        FTController.RequestCampus() { (success, error) in
            if success == true {
                FTController.RequestEvent() { (success, err) in
                    if success {
                        self.eventList.reloadData()
                    } else {
                        let alertController = UIAlertController(title: "Alert", message: "Failed to load events", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }                
            } else {
                print(error)
                print("C'est la fin du monde!! LA fin du monde")
            }
        }
    }

}
