//
//  Card.swift
//  day01
//
//  Created by Aubane COULOMBIER on 11/15/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import Foundation

class Card: NSObject {
    var color: Color
    var value: Value
    
    init (color: Color, value: Value){
        self.color = color
        self.value = value
    }
    
    override var description: String {
        if (self.value.rawValue > 10) {
            return "(\(self.value), \(self.color.rawValue))"
        } else {
            return "(\(self.value.rawValue), \(self.color.rawValue))"
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let card = object as? Card {
            return (self.value == card.value) && (self.color == card.color)
        }
        return false
    }

}
