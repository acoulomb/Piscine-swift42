//
//  FilterController.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/15/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import UIKit

class FilterController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var arrayOfCursus: [String] = [""]
    var arrayOfCampus: [String] = [""]

    @IBOutlet weak var filterKind: UIPickerView!
    @IBOutlet weak var filterCursus: UIPickerView!
    @IBOutlet weak var filterCampus: UIPickerView!

    @IBAction func onSubmit(_ sender: Any) {
        let filterCursusIndex = self.filterCursus.selectedRow(inComponent: 0)
        let filterCursusStr = self.arrayOfCursus[filterCursusIndex]
        let cursus = Cursus.first(where: { key, val in val.name == filterCursusStr })
        FilterCursusIndex = cursus?.value.id ?? -1
        if FilterCursusIndex == 0 {
            FilterCursusIndex = -1
        }
        
        let filterCampusIndex = self.filterCampus.selectedRow(inComponent: 0)
        let filterCampusStr = self.arrayOfCampus[filterCampusIndex]
        let campus = Campus.first(where: { key, val in val.name == filterCampusStr })
        FilterCampusIndex = campus?.value.id ?? -1
        if FilterCampusIndex == 0 {
            FilterCampusIndex = -1
        }
        
        let filterKindIndex = self.filterKind.selectedRow(inComponent: 0)
        FilterKindIndex = filterKindIndex
        if FilterKindIndex == 0 {
            FilterKindIndex = -1
        }
        updateFilteredEvent()
        performSegue(withIdentifier: "filterSegue", sender: "filter")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case filterKind:
            return Kinds.count
        case filterCampus:
            return arrayOfCampus.count
        case filterCursus:
            return arrayOfCursus.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case filterKind:
            return Kinds[row]
        case filterCampus:
            return arrayOfCampus[row]
        case filterCursus:
            return arrayOfCursus[row]
        default:
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Cursus.forEach({ self.arrayOfCursus.append($0.value.name) })
        Campus.forEach({ self.arrayOfCampus.append($0.value.name) })
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
