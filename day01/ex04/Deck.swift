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
    
    var cards: [Card] = Deck.allCards
    var discards: [Card] = [Card]()
    var outs: [Card] = [Card]()
    
    init(mix:Bool) {
        if (mix) {
            self.cards = Deck.allCards
            self.cards.shuffle()
        } else {
            self.cards = Deck.allCards
        }
     }
    
    override var description: String {
        return self.cards.description
    }
    
    func draw() -> Card? {
        if let firstCard = cards.first {
            outs.append(firstCard)
            cards.remove(at: 0)
            return firstCard
        }
        return nil
    }
    
    func fold(c : Card) {
        if (outs.contains(c)) {
            let index = outs.firstIndex(where: { $0 == c })!
            discards.append(c)
            outs.remove(at: index)
        }
    }
}


extension Array {
    mutating func shuffle() {
        if self.count < 2 { return }
        for index in 0..<(self.count) {
            let i = Int(arc4random_uniform(UInt32(self.count)))
            self.swapAt(index, i)
        }
    }
}
