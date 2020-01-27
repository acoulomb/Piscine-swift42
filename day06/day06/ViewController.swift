//
//  ViewController.swift
//  day06
//
//  Created by Aubane COULOMBIER on 12/17/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
        
    var animator = UIDynamicAnimator()
    var gravity = UIGravityBehavior()
    var collision = UICollisionBehavior()
    var itemBehaviour = UIDynamicItemBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
        itemBehaviour = UIDynamicItemBehavior(items: [])
        gravity = UIGravityBehavior(items: [])
        collision = UICollisionBehavior(items: [])
        
        itemBehaviour.elasticity = 0.5
        collision.translatesReferenceBoundsIntoBoundary = true
        gravity.magnitude = 2
        
        animator.addBehavior(itemBehaviour)
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
    }
    
    
    func addDynamics(shape: UIView){
        gravity.addItem(shape)
        collision.addItem(shape)
        itemBehaviour.addItem(shape)
        itemBehaviour.elasticity = 0.6
    }
    
    func removeDynamics(shape: UIView) {
        gravity.removeItem(shape)
        collision.removeItem(shape)
        itemBehaviour.removeItem(shape)
    }
    
    func addGestures(shape: UIView){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        shape.addGestureRecognizer(pan)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(_:)))
        shape.addGestureRecognizer(pinch)
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(onRotation(_:)))
        shape.addGestureRecognizer(rotation)
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        let frame = CGRect(
            x: location.x - (WIDTH / 2),
            y: location.y - (HEIGHT / 2),
            width:WIDTH,
            height:HEIGHT
        )
        let shape = ShapeView(frame: frame)

        shape.isUserInteractionEnabled = true
        shape.clipsToBounds = true
        self.view.addSubview(shape)
        self.addDynamics(shape: shape)
        self.addGestures(shape: shape)
    }
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        guard let shape = recognizer.view else { return }
        switch recognizer.state {
            case .began :
                self.removeDynamics(shape: shape)
            case  .changed :
                shape.center = recognizer.location(in: shape.superview)
                self.animator.updateItem(usingCurrentState: shape)
                self.view.bringSubviewToFront(shape)
            case .ended :
                self.addDynamics(shape:shape)
            case .possible, .cancelled, .failed:
                return
            default :
                return
        }
    }
    
    @objc func onPinch(_ recognizer:UIPinchGestureRecognizer) {
        guard let shape = recognizer.view else { return}
        switch recognizer.state {
            case .began :
                self.removeDynamics(shape: shape)
            case .changed :
                shape.layer.bounds.size.width *= recognizer.scale
                shape.layer.bounds.size.height *= recognizer.scale
                if (shape.layer.cornerRadius != 0) {
                    shape.layer.cornerRadius *= recognizer.scale
                }
                recognizer.scale = 1.0 // Resetting the scale factor causes the gesture recognizer to report only the amount of change since the value was reset, which results in linear scaling of the view.
                self.animator.updateItem(usingCurrentState: shape)
                self.view.bringSubviewToFront(shape)
            case .ended :
                self.addDynamics(shape: shape)
            case .possible, .cancelled, .failed:
                return
            default :
                return
        }
    }
    
    @objc func onRotation(_ recognizer:UIRotationGestureRecognizer) {
        guard let shape = recognizer.view else { return }
        switch recognizer.state {
            case .began:
                self.removeDynamics(shape: shape)
            case .changed :
                shape.transform = CGAffineTransform.init(rotationAngle: recognizer.rotation)
                self.view.bringSubviewToFront(shape)
            case .ended :
                self.addDynamics(shape: shape)
            case .possible, .cancelled, .failed:
                return
            default :
                return
        }
        
    }
}

