//
//  Main.swift
//  day01
//
//  Created by Aubane COULOMBIER on 11/15/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import Foundation

var values : [Value] = Value.allValues
var colors : [Color] = Color.allColors

for value in values {
    print ("\(value) equals \(value.rawValue)")
}

for color in colors {
    print ("\(color) equals \(color.rawValue)")
}
