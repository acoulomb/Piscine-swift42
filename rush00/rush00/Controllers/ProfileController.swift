//
//  ProfileController.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/14/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import UIKit

let cellReuseIdentifier = "CursusCell"

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var prenom: UILabel!
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var preloader: UIActivityIndicatorView!
    @IBOutlet weak var cursusTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cursusTableView.delegate = self
        self.cursusTableView.dataSource = self
        self.preloader.startAnimating()
        self.preloader.hidesWhenStopped = true
        FTController.RequestUserData() { (success, error) in
            if success == true {
                self.updateUserData()
                self.cursusTableView.reloadData()
            } else {
                print(error)
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        Profile = UserModel(id: -1, nom: "", prenom: "", login: "", urlPhotoProfile: "")
        UserCursus = []
        RegisteredEvent = []
        Events = []
        FilteredEvents = []
        Cursus = [:]
        FilterCursusIndex = -1
        FilterCampusIndex = -1
        FilterKindIndex = -1
        Kinds = []
        EventsSelected = -1
        Campus = [:]
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserCursus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CursusCell = self.cursusTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CursusCell
        let cursurData = UserCursus[indexPath.row]
        cell.cursus?.text = cursurData.slug
        cell.level?.text = "\(cursurData.level)"
        return cell
    }
    
    func updateUserData() {
        self.prenom.text = Profile.prenom
        self.nom.text = Profile.nom
        self.login.text = Profile.login
        let urlString = URL(string: Profile.urlPhotoProfile)
        self.imageProfile.asyncLoad(url: urlString!) { (success, error) in
            self.preloader.stopAnimating()
            if success == false {
                let alertController = UIAlertController(title: "Alert", message: "Failed to get image", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        self.preloader.stopAnimating()
    }
}

extension UIImageView {
    func asyncLoad(url: URL, execute: @escaping (Bool, String) -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self?.image = image
                        execute(true, "")
                    } else {
                        execute(false, "Failed to get image")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    execute(false, "Failed to get image")
                }
            }
        }
    }
}
