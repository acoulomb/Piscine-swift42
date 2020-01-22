//
//  Main.swift
//  day01
//
//  Created by Aubane COULOMBIER on 11/15/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import Foundation

var suffledGame = Deck.allCards

suffledGame.shuffle()

print("Shuffled game:\n")
for card in suffledGame {
    print(card)
}
