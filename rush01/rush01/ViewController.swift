//
//  ViewController.swift
//  rush01
//
//  Created by Alexandre KARASSOULOFF on 12/21/19.
//  Copyright © 2019 Alexandre KARASSOULOFF. All rights reserved.
//

import UIKit
import MapKit


protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {  

    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var  path: [MKPlacemark] =  []

    @IBAction func changeMapLayout(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            map.mapType = .standard
        case 1:
            map.mapType = .satellite
        default:
            map.mapType = .hybrid
        }
    }
    
    @IBAction func locateMe(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                let alert = UIAlertController(title: "Error", message: "Location services are not enabled. Please allow them in your device parameters.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                if (map.userLocation.coordinate.latitude <= 90 &&
                    map.userLocation.coordinate.latitude >= -90 &&
                    map.userLocation.coordinate.longitude <= 180 &&
                    map.userLocation.coordinate.longitude >= -180) {
                    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    let region = MKCoordinateRegion(center: map.userLocation.coordinate, span: span)
                    self.map.setRegion(region, animated: true)
                }
            @unknown default:
                break
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Location services are not enabled. Please allow them in your device parameters.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        /*
         * Search table result load
         */
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.map = self.map
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        /*
         * Search bar load
         */
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        /*
         * Search bar style
         */
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.map = map
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = map.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = UIColor.orange
            pinView?.canShowCallout = true
        } else {
            pinView!.annotation = annotation
        }
        if path.count == 1 {
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "itineraire"), for: .normal)
            button.addTarget(self, action: #selector(self.getDirections), for: .touchUpInside)
            pinView?.leftCalloutAccessoryView = button
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        renderer.lineWidth = 3.0
        return renderer
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            print("Authorization reject")
        case .notDetermined:
            print("Authorization undefined")
        case .restricted:
            print("Restricted Authorization")
        default:
            print("Unknow status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.map.setRegion(region, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}

extension ViewController {
    
}

protocol MyHandleMapSearch {
    func transmitPath(_: [MKPlacemark])
}

extension ViewController: MyHandleMapSearch {
    func showAnnotation(_ placemark: MKPlacemark) -> MKPointAnnotation {
        selectedPin = placemark
        // clear existing pins
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        map.addAnnotation(annotation)
        return annotation
    }
    
    func getItenerary(origin: MKPlacemark, dest: MKPlacemark, execute: @escaping (MKMapRect)->Void) {
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: origin)
        directionRequest.destination = MKMapItem(placemark: dest)
        directionRequest.transportType = .automobile
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Direction not available.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.path = []
                    self.map.removeOverlays(self.map.overlays)
                    self.map.removeAnnotations(self.map.annotations)
                }
                return
            }
            let route = response.routes[0]
            self.map.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            execute(MKMapRect(
                origin: MKMapPoint(x: route.polyline.boundingMapRect.origin.x - route.polyline.boundingMapRect.width * 0.05, y: route.polyline.boundingMapRect.origin.y - route.polyline.boundingMapRect.height * 0.05),
                size: MKMapSize(width: route.polyline.boundingMapRect.width * 1.1, height: route.polyline.boundingMapRect.height * 1.1)))
        }
    }
    
    @objc func getDirections(){
        let args: [MKPlacemark] = [
            MKPlacemark(coordinate: self.map!.userLocation.coordinate, addressDictionary: nil),
            self.path[0]
        ]
        self.transmitPath(args)
    }
    
    func transmitPath(_ placemarks:[MKPlacemark]){
        var rect: MKMapRect!
        if placemarks.count == 0 {
            return
        }
        self.map.removeOverlays(self.map.overlays)
        self.path = placemarks
        self.map.removeAnnotations(self.map.annotations)
        if placemarks.count == 1 {
            let annotation = showAnnotation(placemarks[0])
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: placemarks[0].coordinate, span: span)
            map.setRegion(region, animated: true)
        } else {
            var count: Int = placemarks.count - 1
            for (index, _) in placemarks.enumerated() {
                let _ = showAnnotation(placemarks[index])
                if (index < placemarks.count - 1) {
                    getItenerary(origin: placemarks[index], dest: placemarks[index + 1]) { tmp in
                        if rect == nil {
                            rect = tmp
                        } else {
                            rect = MKMapRect (
                                origin: MKMapPoint(
                                    x: min(rect.origin.x, tmp.origin.x),
                                    y: min(rect.origin.y, tmp.origin.y)
                                ),
                                size: MKMapSize(
                                    width: max(rect.size.width, tmp.size.width),
                                    height: max(rect.size.height, tmp.size.height)
                                )
                            )
                        }
                        count -= 1
                        if count <= 0 {
                            self.map.setRegion(MKCoordinateRegion(rect), animated: true)
                        }
                    }
                }
            }
        }
    }
}
