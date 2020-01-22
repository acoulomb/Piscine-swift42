//
//  ViewController.swift
//  day00
//
//  Created by Aubane COULOMBIER on 11/14/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var result: UILabel!
    var oper = false
    var operType:Int = 0
    var val1:Int = 0
    var val2:Int = 0
    var res:Int = 0
    var lastKey:Int = 0
    let maxInt = 9223372036854775807
    let minInt = -9223372036854775808
    
    @IBAction func debug(_ sender: UIButton) {
        print("Key :", sender.currentTitle!)
    }


    @IBAction func keyDown(_ sender: UIButton) {
        if (operType == 0 && oper == false) {
            if (val1 == 0) {
                val1 = sender.tag
            } else {
                if (val1 >= 0 && (val1 < maxInt / 10 - sender.tag)){
                    val1 = val1 * 10 + sender.tag
                } else if(val1 < 0 && (val1 > minInt / 10 + sender.tag)) {
                    val1 = val1 * 10 - sender.tag
                } else {
                    error(value: "Max int reached")
                    return
                }
            }
            res = val1
        } else if (operType == 0 && oper == true) {
            val1 = sender.tag
            res = val1
            oper = false
        } else {
            if (val2 == 0) {
                val2 = sender.tag
            } else {
                if (val2 >= 0 && (val2 < maxInt / 10 - sender.tag)){
                    val2 = val2 * 10 + sender.tag
                } else if(val2 < 0 && (val2 > minInt / 10 + sender.tag)) {
                    val2 = val2 * 10 - sender.tag
                } else {
                    error(value: "Max int reached")
                    return
                }
            }
            res = val2
        }
        display(value: res)
        lastKey = 1
    }
    
    
    @IBAction func operation(_ sender: UIButton) {
        if (lastKey == 2) { // if already clicked on an operator
            operType = sender.tag
            return
        }
        if (oper == true) { // if multiple operation
            calc()
        }
        oper = true;
        operType = sender.tag
        lastKey = 2
    }
    
    @IBAction func equal() {
        print("val1 : ", val1)
        print("val2 : ", val2)
        print("operType: ", operType)
        if (result.text != "Error") {
            calc()
        }
    }
    
    
    @IBAction func neg() {
        if (operType == 0 || lastKey == 2) {
            val1 *= -1
            res = val1
        } else {
            val2 *= -1
            res = val2
        }
        display(value: res)
    }
    
    
    @IBAction func reset() {
        oper = false
        operType = 0
        val1 = 0
        val2 = 0
        display(value: 0)
    }
    
    func display(value : Int) {
        result.text = String(value)
    }
    
    func error(value : String) {
        result.text = String(value)
        oper = false
        operType = 0
        val1 = 0
        val2 = 0
    }
    
    func calc() {
        if (operType == 14) { // addition
            if ((val2 >= 0 && val1 &+ val2 < val1)
                || (val2 < 0 && val1 &+ val2 > val1)) { // overflow and underflow check
                print("Max int reached")
                error(value: "Max int reached")
                return
            } else {
                res = val1 + val2
                val1 = res
            }
        } else if (operType == 15) { // substraction
            if ((val2 >= 0 && val1 &- val2 > val1)
                || (val2 < 0 && val1 &- val2 < val1)) { // overflow and underflow check
                print("Max int reached")
                error(value: "Max int reached")
                return
            } else {
                res = val1 - val2
                val1 = res
            }
        } else if (operType == 12) { // multiplication
           
            if (abs(val1) > 0 && abs(val2) < maxInt / abs(val1) || abs(val1) == 0) { // overflow check
                res = val1 * val2
                val1 = res
            } else {
                print("Max int reached")
                error(value: "Max int reached")
                return;
            }
        } else if (operType == 13) { // division
            if (val2 == 0) { // divided by zero
                error(value: "Error")
                return;
            } else { // overflow doesn't need check
                res = val1 / val2
                val1 = res
            }
        }
        operType = 0
        val2 = 0
        display(value: res)
        lastKey = 0;
    }
    
    

}

