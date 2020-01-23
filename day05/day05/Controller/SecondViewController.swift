//
//  SecondViewController.swift
//  day05
//
//  Created by Aubane COULOMBIER on 12/16/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    @IBOutlet weak var mapView: MKMapView!
    var selectedPlace: Place = Place(id:-1, name:"", description: "", latitude: 0, longitude:0)
    
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
    @IBAction func unwindToMap(segue:UIStoryboardSegue) {
        self.viewDidLoad()
        let coordinatesSelected = CLLocationCoordinate2D(latitude: selectedPlace.latitude, longitude:selectedPlace.longitude)
        if(selectedPlace.id != -1) {
            self.focusMapView(place: coordinatesSelected)
        }
    }
    /*
    ** If authorized, update user's location
    */
    @IBAction func updateCurrentLocation(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                let alert = UIAlertController(title: "Error", message: "Location services are not enabled. Please allow them in your device parameters.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                if (currentLocation != nil) {
                    self.focusMapView(place: currentLocation!.coordinate)
                } else {
                    locationManager.startUpdatingLocation()
                }
            @unknown default:
                break
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Location services are not enabled. Please allow them in your device parameters.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Location services are not enabled")
        }
    }
    
    /*
    ** Add a pin on map
    */
    func addPin(place: Place) -> CLLocationCoordinate2D {
        let annotation = MKPointAnnotation()
        annotation.title = place.name
        annotation.subtitle = place.description
        let coordinates = CLLocationCoordinate2D(latitude: place.latitude, longitude:place.longitude)
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        return annotation.coordinate
    }
    
    /*
    ** Focus on location
    */
    func focusMapView(place: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: place, latitudinalMeters: CLLocationDistance(exactly: 2000)!, longitudinalMeters: CLLocationDistance(exactly: 2000)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isEqual(mapView.userLocation)) { return nil }
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = true
        guard let title = annotation.title! else {return annotationView}
        switch(title) {
            case "42" :
                annotationView.pinTintColor = UIColor.purple
            case "Lyon":
                annotationView.pinTintColor = UIColor.blue
            case "Eaubonne" :
                annotationView.pinTintColor = UIColor.orange
            default:
                annotationView.pinTintColor = UIColor.red
        }
        return annotationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        mapView.showsUserLocation = true

        /*
        ** Set all the places from the model
        */
        for place in Places {
            let pin = self.addPin(place: place)
            if (place.id == 0){
                self.focusMapView(place: pin)
            }
        }
        
        /*
        ** User's location parameters
        */
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
    }
    
    /*
    ** Center on update user's location
    */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        if currentLocation == nil {
            if let userLocation = locations.last {
                self.focusMapView(place: userLocation.coordinate)
            }
        }
    }

}

