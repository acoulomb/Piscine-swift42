//
//  Tweet.swift
//  day04
//
//  Created by Aubane COULOMBIER on 12/10/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import Foundation

struct Tweet : CustomStringConvertible {
    let name: String
    let text: String
    let date: String
    
    var description: String {
        return "Name : \(name)\nDate: \(date)\nTweet : \(text)"
    }
}
