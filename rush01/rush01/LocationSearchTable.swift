//
//  LocationSearchTable.swift
//  rush01
//
//  Created by Alexandre KARASSOULOFF on 12/21/19.
//  Copyright © 2019 Alexandre KARASSOULOFF. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var matchingItems:[MKMapItem] = []
    var map: MKMapView? = nil
    var handleMapSearchDelegate:MyHandleMapSearch? = nil
    @IBOutlet weak var pathTable: UITableView!
    @IBOutlet weak var searchTable: UITableView!
    var  path: [MKPlacemark] =  []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.path = []
        self.pathTable.reloadData()
//        self.pathTable.reloadData()
    }

    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    @IBAction func onSubmit(_ sender: Any) {
        handleMapSearchDelegate?.transmitPath(self.path)
        dismiss(animated: true, completion: nil)
    }
}

extension LocationSearchTable {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.searchTable {
            if indexPath.row == 0 {
                self.path.append(MKPlacemark(coordinate: self.map!.userLocation.coordinate, addressDictionary: nil))
            } else {
                let selectedItem = matchingItems[indexPath.row - 1].placemark
                self.path.append(selectedItem)
            }
            self.pathTable.reloadData()
        }
    }
}


extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let map = map,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = map.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.searchTable.reloadData()
        }
    }
}

extension LocationSearchTable {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.searchTable:
            return matchingItems.count + 1
        default:
            return self.path.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.searchTable:
            if indexPath.row == 0 {
                let cell = self.searchTable.dequeueReusableCell(withIdentifier: "searchCell")!
                cell.textLabel?.text = "Current location"
                cell.detailTextLabel?.text = ""
                return cell
            } else {
                let cell = self.searchTable.dequeueReusableCell(withIdentifier: "searchCell")!
                let selectedItem = matchingItems[indexPath.row - 1].placemark
                cell.textLabel?.text = selectedItem.name
                cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
                return cell
            }
        default:
            let cell = self.pathTable.dequeueReusableCell(withIdentifier: "pathCell")!
            let selectedItem = path[indexPath.row]
            cell.textLabel?.text = "\(indexPath.row + 1) - \(selectedItem.name ?? "Current location")"
            cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
            return cell
        }
    }
}
