//
//  ViewController.swift
//  day07
//
//  Created by Aubane COULOMBIER on 12/18/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit
import ForecastIO
import RecastAI
import CoreLocation

let client = DarkSkyClient(apiKey: "apiKey")
let bot = RecastAIClient(token: "token")

class ViewController: UIViewController {

    @IBOutlet weak var request: UITextField!
    @IBOutlet weak var result: UILabel!

    @IBAction func sendRequest(_ sender: Any) {
        view.endEditing(true)
        let requestString = request.text ?? ""
        if (requestString != "") {
            self.makeRequest(request: requestString)
        } else {
            displayError(error: "Please enter a question")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func makeRequest(request: String) {
        bot.textRequest(request, successHandler: recastRequestDone(_:), failureHandle: recastRequestError(_:))
    }
    
    func getWeather(location: CLLocationCoordinate2D) {
        client.getForecast(location: location) { result in
            switch result {
            case .success(let currentForecast, _):
                guard let weather = currentForecast.hourly?.summary else {self.displayError(error: "An error occured while searching for the weather forecast");return}
                self.displayResult(response: weather)
            case .failure(_):
                self.displayError(error: "An error occured while searching for the weather forecast")
            }
        }
    }
    
    func recastRequestDone(_ response : Response){
        guard let entities = response.entities, let location = entities["location"] as? [[String:Any]] else {self.displayError(error: "Sorry, we couldn't find location"); return }
        guard let lat: Double = location[0]["lat"] as? Double, let lng: Double = location[0]["lng"] as? Double else {self.displayError(error: "Sorry, we couldn't find location"); return }
        let reqLoc = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.getWeather(location: reqLoc)
    }
    
    func recastRequestError(_ error : Error){
        self.displayError(error: "Sorry, we couldn't find location")
    }
    
    func displayResult(response: String){
        DispatchQueue.main.async {
            self.result.text = response
        }
    }

    func displayError(error: String){
        self.result.text = error
    }

}

