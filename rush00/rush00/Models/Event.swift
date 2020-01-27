//
//  Event.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/14/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import Foundation


struct EventModel {
    var id: Int
    var name: String
    var desc: String
    var nbr_subscribers: Int
    var kind: String
    var max_people: Int
    var location: String
    var duration: DateComponents
    var startAt: Date
    var endAt: Date
    var campusId: [Int]
    var cursusId: [Int]
}
var RegisteredEvent: [NSDictionary] = []
var Events: [EventModel] = []
var FilteredEvents: [EventModel] = []

var Kinds: [String] = []
var EventsSelected:Int = -1
func updateFilteredEvent() {
    FilteredEvents = []
    if FilterKindIndex != -1 {
        print("Filter kind by \(Kinds[FilterKindIndex])")
    }
    if FilterCampusIndex != -1 {
        print("Filter Campus by id: \(FilterCampusIndex)")
    }
    if FilterCursusIndex != -1 {
        print("Filter Cursus by id: \(FilterCursusIndex)")
    }
    for e in Events {
        if FilterKindIndex != -1 && e.kind != Kinds[FilterKindIndex]{
            continue
        }
        if FilterCampusIndex != -1 && e.campusId.contains(FilterCampusIndex) == false {
            continue
        }
        if FilterCursusIndex != -1 && e.cursusId.contains(FilterCursusIndex) == false {
            continue
        }
        FilteredEvents.append(e)
    }
}
