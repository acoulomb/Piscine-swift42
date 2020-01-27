//
//  FTController.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/14/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import Foundation

class FTController {
    static let baseUrl: String = "https://api.intra.42.fr/v2"
    
    /*
     *  Function to update user and all his cursus
     */
    static func RequestUserUnregisteredEvent(_ idToTransmit: Int, execute: @escaping (Bool, String)->Void) {
        var urlString = FTController.baseUrl + "/events_users/\(idToTransmit)"
        let headers: [String: String] = [
            "Authorization": "Bearer " + storeToken["token"]!
        ]
        let request = RequestController.query(urlString: &urlString, params: [:], headers: headers, method: "DELETE")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var e: Error!
            if let err = error {
                e = err
            } else if let d = data {
                do {
                    DispatchQueue.main.async() {
                        execute(true, "")
                    }
                }
                catch (let err) {
                    e = err
                }
            }
            if e != nil {
                DispatchQueue.main.async() {
                    execute(false, "Failed to request user data")
                }
            }
        }
        task.resume()
    }

    /*
     *  Function to update user and all his cursus
     */
    static func RequestUserRegisteredEvent(_ idToTransmit: Int, execute: @escaping (Bool, String, NSDictionary?)->Void) {
        var urlString = FTController.baseUrl + "/events_users"
        let headers: [String: String] = [
            "Authorization": "Bearer " + storeToken["token"]!
        ]
        let params: [String: String] = [
            "events_user[user_id]": "\(Profile.id)",
            "events_user[event_id]": "\(idToTransmit)"
        ]
        let request = RequestController.query(urlString: &urlString, params: params, headers: headers, method: "POST")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var e: Error!
            if let err = error {
                e = err
            } else if let d = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: d) as? NSDictionary {
                        DispatchQueue.main.async() {
                            execute(dic.value(forKey: "error") as? String ?? "OK" == "OK", "", dic)
                        }
                    }
                }
                catch (let err) {
                    e = err
                }
            }
            if e != nil {
                DispatchQueue.main.async() {
                    execute(false, "Failed to request user data", nil)
                }
            }
        }
        task.resume()
    }
    
    /*
     *  Function to update user and all his cursus
     */
    static func RequestUserRegisteredEvent(execute: @escaping (Bool, String)->Void) {
        var urlString = FTController.baseUrl + "/users/\(Profile.id)/events_users"
        let headers: [String: String] = [
            "Authorization": "Bearer " + storeToken["token"]!
        ]
        let request = RequestController.query(urlString: &urlString, params: [:], headers: headers, method: "GET")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var e: Error!
            if let err = error {
                e = err
            } else if let d = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: d) as? [NSDictionary] {
                        RegisteredEvent = dic
                    }
                    DispatchQueue.main.async() {
                        execute(true, "")
                    }
                }
                catch (let err) {
                    e = err
                }
            }
            if e != nil {
                DispatchQueue.main.async() {
                    execute(false, "Failed to request user data")
                }
            }
        }
        task.resume()
    }
    
    /*
     *  Function to update user and all his cursus
     */
    static func UpdateCampusList(_ dict: [NSDictionary]) {
        for c in dict {
            let newCampus = CampusModel(
                id: c.value(forKey: "id") as? Int ?? -1,
                name: c.value(forKey: "name") as? String ?? "")
            Campus[newCampus.id] = newCampus
        }
    }
    
    static func RequestCampus(execute: @escaping (Bool, String)->Void) {
        var urlString = FTController.baseUrl + "/campus?page[size]=100"
        let headers: [String: String] = [
            "Authorization": "Bearer " + storeToken["token"]!
        ]
        let request = RequestController.query(urlString: &urlString, params: [:], headers: headers, method: "GET")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var e: Error!
            if let err = error {
                e = err
            } else if let d = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: d) as? [NSDictionary] {
                        UpdateCampusList(dic)
                    }
                    DispatchQueue.main.async() {
                        execute(true, "")
                    }
                }
                catch (let err) {
                    e = err
                }
            }
            if e != nil {
                DispatchQueue.main.async() {
                    execute(false, "Failed to request user data")
                }
            }
        }
        task.resume()
    }
    
    /*
     *  Function to update user and all his cursus
     */
    static func UpdateCursusList(_ dict: [NSDictionary]) {
        for c in dict {
            let newCursus = CursusModel(
                id: c.value(forKey: "id") as? Int ?? -1,
                name: c.value(forKey: "name") as? String ?? "")
            Cursus[newCursus.id] = newCursus
        }
    }
    
    static func RequestCursus(execute: @escaping (Bool, String)->Void) {
        var urlString = FTController.baseUrl + "/cursus"
        let headers: [String: String] = [
            "Authorization": "Bearer " + storeToken["token"]!
        ]
        let request = RequestController.query(urlString: &urlString, params: [:], headers: headers, method: "GET")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var e: Error!
            if let err = error {
                e = err
            } else if let d = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: d) as? [NSDictionary] {
                        UpdateCursusList(dic)
                    }
                    DispatchQueue.main.async() {
                        execute(true, "")
                    }
                }
                catch (let err) {
                    e = err
                }
            }
            if e != nil {
                DispatchQueue.main.async() {
                    execute(false, "Failed to request user data")
                }
            }
        }
        task.resume()
    }
    
    /*
     *  Function to update user and all his cursus
     */
    static func UpdateUserData(dict: NSDictionary) {
        Profile.prenom = dict.value(forKey: "first_name") as? String ?? ""
        Profile.nom = dict.value(forKey: "last_name") as? String ?? ""
        Profile.login = dict.value(forKey: "login") as? String ?? ""
        Profile.urlPhotoProfile = dict.value(forKey: "image_url") as? String ?? ""
        Profile.id = dict.value(forKey: "id") as? Int ?? 0
        let cursus = dict.value(forKey: "cursus_users") as! [NSDictionary]
        for cur in cursus {
            let data = cur.value(forKey: "cursus") as! NSDictionary
            UserCursus.append(UserCursusModel(
                slug: data.value(forKey: "slug") as? String ?? "Undefined",
                level: cur.value(forKey: "level") as? Double ?? 0.0
            ))
        }
    }
    
    static func RequestUserData(execute: @escaping (Bool, String)->Void) {
        var urlString = FTController.baseUrl + "/me"
        let headers: [String: String] = [
            "Authorization": "Bearer " + storeToken["token"]!
        ]
        let request = RequestController.query(urlString: &urlString, params: [:], headers: headers, method: "GET")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var e: Error!
            if let err = error {
                e = err
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d) as? NSDictionary {
                        UpdateUserData(dict: dic)
                    }
                    DispatchQueue.main.async() {
                        execute(true, "")
                    }
                }
                catch (let err) {
                    e = err
                }
            }
            if e != nil {
                DispatchQueue.main.async() {
                    execute(false, "Failed to request user data")
                }
            }
        }
        task.resume()
    }
    
    static func isoToDate(_ isoDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from:isoDate)!
    }
    
    /*
     *  Function to update list of cursus
     */

    static func UpdateEvent(_ dictEvent: [NSDictionary]) {
        var myKinds: Set<String> = Set()
        for e in dictEvent {
            let startAt = isoToDate(e.value(forKey: "begin_at") as? String ?? "0000-00-00T00:00:00.000Z")
            let endAt = isoToDate(e.value(forKey: "end_at") as? String ?? "0000-00-00T00:00:00.000Z")
            let dif = Calendar.current.dateComponents([.hour, .minute, .day], from: startAt, to: endAt)
            myKinds.update(with: e.value(forKey: "kind") as? String ?? "")
            Events.append(EventModel(
                id: e.value(forKey: "id") as? Int ?? 0,
                name: e.value(forKey: "name") as? String ?? "",
                desc: e.value(forKey: "description") as? String ?? "",
                nbr_subscribers: e.value(forKey: "nbr_subscribers") as? Int ?? 0,
                kind: e.value(forKey: "kind") as? String ?? "",
                max_people: e.value(forKey: "max_people") as? Int ?? 0,
                location: e.value(forKey: "location") as? String ?? "",
                duration: dif,
                startAt: startAt,
                endAt: endAt,
                campusId: e.value(forKey: "campus_ids") as? [Int] ?? [],
                cursusId: e.value(forKey: "cursus_ids") as? [Int] ?? []))
        }
        Kinds = Array(myKinds)
        Kinds.insert("", at: 0)
        updateFilteredEvent()
    }
    
    static func RequestEvent(execute: @escaping (Bool, String)->Void) {
        var urlString = FTController.baseUrl + "/events"
        let headers: [String: String] = [
            "Authorization": "Bearer " + storeToken["token"]!
        ]
        let request = RequestController.query(urlString: &urlString, params: [:], headers: headers, method: "GET")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var e: Error!
            if let err = error {
                e = err
            } else if let d = data {
                do {
                    if let dic : [NSDictionary] = try JSONSerialization.jsonObject(with: d) as? [NSDictionary] {
                        UpdateEvent(dic)
                    }
                    DispatchQueue.main.async() {
                        execute(true, "")
                    }
                }
                catch (let err) {
                    e = err
                }
            }
            if e != nil {
                DispatchQueue.main.async() {
                    execute(false, "Failed to request user data")
                }
            }
        }
        task.resume()
    }
}
