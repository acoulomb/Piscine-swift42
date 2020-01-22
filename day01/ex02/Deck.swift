//
//  Deck.swift
//  day01
//
//  Created by Aubane COULOMBIER on 11/19/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import Foundation

class Deck: NSObject {
    static let allSpades: [Card] = Value.allValues.map {Card(color:Color.Spade, value:$0)}
    static let allDiamonds: [Card] = Value.allValues.map {Card(color:Color.Diamond, value:$0)}
    static let allHearts: [Card] = Value.allValues.map {Card(color:Color.Heart, value:$0)}
    static let allClubs: [Card] = Value.allValues.map {Card(color:Color.Club, value:$0)}

    static let allCards: [Card] = allSpades + allDiamonds + allHearts + allClubs
}
