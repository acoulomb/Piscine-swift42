//
//  Main.swift
//  day01
//
//  Created by Aubane COULOMBIER on 11/15/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import Foundation

let card1 = Card(color : Color.Spade, value : Value.King)
let card2 = Card(color : Color.Spade, value: Value.Two)
let card3 = Card(color : Color.Heart, value: Value.Queen)
let card4 = Card(color : Color.Heart, value: Value.Queen)

print("The cards")
print("Card 1 : \(card1)")
print("Card 2 : \(card2)")
print("Card 3 : \(card3)")
print("Card 4 : \(card4)", "\n")

print("Card 1 compared to Card 2")
print("isEqual: ", card1.isEqual(card2))
print("Overload '==' :", card1 == card2, "\n")

print("Card 2 compared to Card 3")
print("isEqual: ", card2.isEqual(card3))
print("Overload '==' :", card2 == card3, "\n")

print("Card 3 compared to Card 4")
print("isEqual: ", card3.isEqual(card4))
print("Overload '==' :", card3 == card4, "\n")
