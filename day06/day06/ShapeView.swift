//
//  ShapeView.swift
//  day06
//
//  Created by Aubane COULOMBIER on 12/17/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit

let CIRCLE = 0
let SQUARE = 1

let WIDTH:CGFloat = 100
let HEIGHT:CGFloat = 100

class ShapeView: UIView {

    var lastLocation = CGPoint(x: 0, y: 0)
    
    override init(frame: CGRect) {
        super.init(frame:frame)

        // Random shape
        let randomShape = arc4random_uniform(2)
        if (randomShape == CIRCLE) {
            layer.cornerRadius = WIDTH / 2
        }
        
        // Random color
        let blueVal = CGFloat(Int(arc4random() % 255)) / 255.0
        let greenVal = CGFloat(Int(arc4random() % 255)) / 255.0
        let redVal = CGFloat(Int(arc4random() % 255)) / 255.0
        self.backgroundColor = UIColor(red:redVal, green: greenVal, blue: blueVal, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
