//
//  DetailEventController.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/15/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import UIKit

func isRegisteredToEvent() -> (Bool, NSDictionary?) {
    for dict in RegisteredEvent {
        let id = dict.value(forKey: "event_id") as? Int ?? -1
        if id == FilteredEvents[EventsSelected].id {
            return (true, dict)
        }
    }
    return (false, nil)
}

class DetailEventController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var localisation: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var participants: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var btnToggleRegister: UIButton!
    
    var idToTransmit: Int = -1
    var isRequesting: Bool = false
    
    @IBAction func toggleRegister(_ sender: Any) {
        if idToTransmit == -1 || self.isRequesting == true || FilteredEvents[EventsSelected].nbr_subscribers == FilteredEvents[EventsSelected].max_people  {
            return
        }
        isRequesting = true
        if idToTransmit == FilteredEvents[EventsSelected].id {
            FTController.RequestUserRegisteredEvent(self.idToTransmit) { (success, error, dict) in
                if success == true {
                    self.idToTransmit = dict?.value(forKey: "id") as? Int ?? -1
                    self.btnToggleRegister.setTitle("Unregister", for: .normal)
                } else {
                    print("ERROR")
                    print(error)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isRequesting = false
                }
            }
        } else {
            FTController.RequestUserUnregisteredEvent(idToTransmit) { (success, error) in
                if success == true {
                    self.idToTransmit = FilteredEvents[EventsSelected].id
                    self.btnToggleRegister.setTitle("Register", for: .normal)
                    self.isRequesting = false
                } else {
                    print("ERROR")
                    print(error)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isRequesting = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FilteredEvents[EventsSelected].id)
        
        self.name.text = "Event : " + FilteredEvents[EventsSelected].name
        self.localisation.text = "Location : " + FilteredEvents[EventsSelected].location
        self.type.text = "Type : " + FilteredEvents[EventsSelected].kind
        self.start.text = "Start : " + FilteredEvents[EventsSelected].startAt.description
        self.end.text = "End : " + FilteredEvents[EventsSelected].endAt.description
        self.duration.text = "Duration : \(String(FilteredEvents[EventsSelected].duration.day ?? 0)) day(s) \(String(FilteredEvents[EventsSelected].duration.hour ?? 0)) hour(s) \(String(FilteredEvents[EventsSelected].duration.minute ?? 0)) minute(s)"
        self.participants.text = String(format: "Participants : %d / %d", FilteredEvents[EventsSelected].nbr_subscribers, FilteredEvents[EventsSelected].max_people)
        self.desc.text = "Description : \n" + FilteredEvents[EventsSelected].desc
        self.isRequesting = true
        FTController.RequestUserRegisteredEvent() { (success, error) in
            let (isRegistered, dict) = isRegisteredToEvent()
            if isRegistered == true {
                self.idToTransmit = dict?.value(forKey: "id") as? Int ?? -1
                self.btnToggleRegister.setTitle("Unregister", for: .normal)
            } else {
                if FilteredEvents[EventsSelected].nbr_subscribers == FilteredEvents[EventsSelected].max_people {
                    self.btnToggleRegister.isHidden = true
                } else {
                    self.idToTransmit = FilteredEvents[EventsSelected].id
                    self.btnToggleRegister.setTitle("Register", for: .normal)
                }
            }
            self.isRequesting = false
        }
    }
}
