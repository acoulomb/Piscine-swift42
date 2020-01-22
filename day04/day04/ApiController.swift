//
//  ApiController.swift
//  day04
//
//  Created by Aubane COULOMBIER on 12/10/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import Foundation

protocol APITwitterDelegate: class {
    func showTweet(tweet: [Tweet])
    func error (error: NSError)
}

enum APIError : Error {
    case noResultForKeyword
    case anErrorOccurred
    case noUserForTweet
    case noUserNameForUser
    case noDateForTweet
    case noTextForTweet
    case emptyKeyword
}

class APIController {
    
    weak var delegate : APITwitterDelegate?
    let token : String
    
    init(delegate: APITwitterDelegate, token: String) {
        self.delegate = delegate
        self.token = token
    }
    
    func req(search: String){
        
        var tweets:[Tweet] = []
        var escapedSearch: String
        
        if search == "" {
            self.delegate?.error(error: APIError.emptyKeyword as NSError)
            return
        } else {
            escapedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        }
        
        let url = URL(string: "https://api.twitter.com/1.1/search/tweets.json?q="+escapedSearch+"&count=100&result_type=recent&lang=fr&tweet_mode=extended")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let err = error {
                self.delegate?.error(error: APIError.anErrorOccurred as NSError)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d) as? NSDictionary {
                        if let statuses: [NSDictionary] = dic.value(forKey: "statuses") as? [NSDictionary] {
                            var tweetIterator = statuses.makeIterator()
                            if statuses == [] {
                                self.delegate?.error(error: APIError.noResultForKeyword as NSError)
                                return
                            }
                            while let tweet = tweetIterator.next() {
                                guard let user = tweet["user"] as? NSDictionary else {
                                    self.delegate?.error(error: APIError.noUserForTweet as NSError)
                                    return
                                }
                                guard let username = user["name"] as? String else {
                                    self.delegate?.error(error: APIError.noUserNameForUser as NSError)
                                    return
                                }
                                guard let date = tweet["created_at"] as? String else {
                                    self.delegate?.error(error: APIError.noDateForTweet as NSError)
                                    return
                                }
                                guard let msg = tweet["full_text"] as? String else {
                                    self.delegate?.error(error: APIError.noTextForTweet as NSError)
                                    return
                                }
                                tweets.append(Tweet(name:username, text:msg, date:date))
                                self.delegate?.showTweet(tweet: tweets)
                            }
                        }
                    }
                }
                catch (let err) {
                    self.delegate?.error(error: APIError.anErrorOccurred as NSError)
                }
            }
            
        }
        task.resume()
        
        
    }
}
