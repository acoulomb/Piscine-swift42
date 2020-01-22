//
//  ImgCollectionViewController.swift
//  day03
//
//  Created by Aubane COULOMBIER on 12/9/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ImgCell"


class ImgCollectionViewController: UICollectionViewController {

    @IBOutlet var ImgCollectionView: UICollectionView!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImgCollectionViewCell
       
        // Move to a background thread to do some long running work
        DispatchQueue.global(qos: .userInitiated).async {
            let imgUrl = Images[indexPath.item]
            let path = try? Data(contentsOf: imgUrl)
            if (path == nil) {
                let alert = UIAlertController(title: "Error", message: "An error occurred while loading : \(imgUrl)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    cell.preloader.hidesWhenStopped = true
                    cell.preloader.stopAnimating()
                    cell.layer.backgroundColor = (UIColor.lightGray.cgColor)
                }))
                self.present(alert, animated: true)
                self.count += 1
                if (self.count == Images.count) {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            } else {
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    cell.preloader.hidesWhenStopped = true
                    cell.preloader.stopAnimating()
                    cell.imgView.image = UIImage(data: path!)
                    self.count += 1
                    if (self.count == Images.count) {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        cell.preloader.startAnimating()
        return cell
    }

    // MARK: UICollectionViewDelegate
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let seq = segue.destination as! ImgDetailViewController
        let cell = sender! as! ImgCollectionViewCell
        if cell.imgView.image != nil {
            seq.image = cell.imgView.image!
        } else {
            let alertController = UIAlertController(title: "Error", message: "Cannot acces to this image", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

