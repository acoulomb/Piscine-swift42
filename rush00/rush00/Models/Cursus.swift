//
//  Cursus.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/15/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import Foundation


struct CursusModel {
    var id: Int
    var name: String
}

var Cursus: [Int: CursusModel] = [:]
var FilterCursusIndex: Int = -1
var FilterCampusIndex: Int = -1
var FilterKindIndex: Int = -1
