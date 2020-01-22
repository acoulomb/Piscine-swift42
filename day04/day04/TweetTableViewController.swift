//
//  TweetTableViewController.swift
//  day04
//
//  Created by Aubane COULOMBIER on 12/13/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit

let CONSUMER_KEY = "CONSUMER_KEY"
let CONSUMER_SECRET = "CONSUMER_SECRET"
let BEARER = ((CONSUMER_KEY+":"+CONSUMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))


class TweetTableViewController: UITableViewController, UITextFieldDelegate, APITwitterDelegate {

    var keyword: String = "ecole 42"
    var token: String = ""
    var tweets:[Tweet] = []
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.keyword = textField.text!
        DispatchQueue.main.async {
            let controller = APIController(delegate: self, token: self.token)
            controller.req(search: self.keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            self.tableView.reloadData()
        }
        return true
    }
    
    func showTweet(tweet: [Tweet]) {
        self.tweets = tweet
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func error(error: NSError) {
        DispatchQueue.main.async {
            switch error.code {
            case 0:
                let alert = UIAlertController(title: "Error", message: "No results for this keyword", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case 1:
                let alert = UIAlertController(title: "Error", message: "An error occured", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case 2:
                let alert = UIAlertController(title: "Error", message: "No user found for the tweet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case 3:
                let alert = UIAlertController(title: "Error", message: "No user name found for the tweet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case 4:
                let alert = UIAlertController(title: "Error", message: "No date found for the tweet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case 5:
                let alert = UIAlertController(title: "Error", message: "No text found for the tweet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case 6:
                let alert = UIAlertController(title: "Error", message: "Please enter a keyword", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            default:
                let alert = UIAlertController(title: "Error", message: "An error occured", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("keyword : ", self.keyword)

        let url = URL(string: "https://api.twitter.com/oauth2/token")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic " +  BEARER, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let err = error {
                self.error(error: APIError.anErrorOccurred as NSError)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d) as? NSDictionary {
                        
                        self.token = dic.value(forKey: "access_token") as! String
                        if (self.token != "") {
                            let controller = APIController(delegate: self, token: self.token)
                            controller.req(search: self.keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                        }
                    }
                }
                catch (let err) {
                    self.error(error: APIError.anErrorOccurred as NSError)
                }
            }
            
        }
        task.resume()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tweets.count + 1)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchBar", for: indexPath) as! SearchBarViewCell
            cell.searchBar.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
            
            let tweet = tweets[indexPath.row - 1]
            cell.NameLabel?.text = tweet.name
            cell.DateLabel?.text = tweet.date
            cell.TextLabel?.text = tweet.text
            return cell
        }
    }


}
