//
//  Main.swift
//  day01
//
//  Created by Aubane COULOMBIER on 11/15/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import Foundation

var myDeck = Deck(mix: false)

print(myDeck, "\n")

for i in 0...10 {
    if let draw = myDeck.draw() as Card? {
        print ("Draw \(i)", draw)
    }
    else {
        print("No more cards\n")
        break
    }
}

print("\nAll outs :")
print(myDeck.outs, "\n")

print("Remaining deck :")
print(myDeck.cards, "\n")

myDeck.fold(c: myDeck.outs[7])
print ("Discard 7")

for x in 0...3 {
    myDeck.fold(c: myDeck.outs[0])
    print ("Discard \(x)")
}

print("\nAll outs :")
print(myDeck.outs, "\n")

print("All discards :")
print(myDeck.discards, "\n")

