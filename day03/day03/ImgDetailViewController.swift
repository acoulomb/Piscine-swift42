//
//  ImgDetailViewController.swift
//  day03
//
//  Created by Aubane COULOMBIER on 12/9/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit

class ImgDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var ImgDetailScroll: UIScrollView!
    @IBOutlet var ImgDetailView: UIImageView!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImage()
        self.setSize(screenWidth: self.view.bounds.width)

        ImgDetailScroll.addSubview(self.ImgDetailView!)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        ImgDetailScroll.addGestureRecognizer(doubleTapRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*
     ** madatory to zoom
     */
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.ImgDetailView
    }
    
    /*
    ** Set the size of scroll view / setting how far my scroll can go
    */
    func setSize(screenWidth: CGFloat){
        let imageFullSize = ImgDetailScroll!.frame.size
        let imageRatio = imageFullSize.height / imageFullSize.width
        self.ImgDetailScroll!.frame = CGRect(
            x: 0,
            y: 0,
            width: screenWidth,
            height: screenWidth * imageRatio
        );
        self.ImgDetailScroll.contentSize = self.ImgDetailScroll!.frame.size
        self.setZoom(screenWidth: screenWidth)
    }
    
    /*
     ** Set the image
     */
    func setImage(){
        self.ImgDetailView = UIImageView(image: image)
        self.ImgDetailView!.contentMode = .scaleAspectFill
        self.ImgDetailView!.clipsToBounds = true
        ImgDetailScroll.isScrollEnabled = true
        ImgDetailScroll.showsHorizontalScrollIndicator = true
        ImgDetailScroll.showsVerticalScrollIndicator = true
    }
    
    /*
    ** Set the zoom scale
    */
    func setZoom(screenWidth: CGFloat){
        let minScale = screenWidth / ImgDetailView!.bounds.size.width;
        ImgDetailScroll.minimumZoomScale = minScale // zoom scale to see the entire picture
        ImgDetailScroll.maximumZoomScale = 1 // 1 so there are no problem of resolution
        ImgDetailScroll.zoomScale = minScale // start fully zoomed out
    }
   
    
    /*
    ** to adapt size on rotation
    */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.setSize(screenWidth: size.width)
    }
    
    
    /*
    ** zoom in on double tap
    */
    @objc func handleTap(_ sender: UITapGestureRecognizer){ // to zoom when double tap
        if sender.state == .ended {
            let pointInView = sender.location(in: self.ImgDetailView) // where one taped
            
            var newZoomScale = ImgDetailScroll.zoomScale * 1.5 // calculate zoom scale 150% but within the maximum
            newZoomScale = min(newZoomScale, ImgDetailScroll.maximumZoomScale)
            
            let scrollViewSize = ImgDetailScroll.bounds.size // calculate the rectangle on zooms in
            let w = scrollViewSize.width / newZoomScale
            let h = scrollViewSize.height / newZoomScale
            let x = pointInView.x - (w / 2.0)
            let y = pointInView.y - (h / 2.0)
            let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h)
            
            ImgDetailScroll.zoom(to: rectToZoomTo, animated: true) // trigger the zoom with animation
        }
    }
    
}
