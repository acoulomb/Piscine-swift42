//
//  AddEntryViewController.swift
//  day02
//
//  Created by Aubane COULOMBIER on 12/4/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {

    // MARK: - Navigation

    @IBOutlet weak var NameCell: UITextField!
    @IBOutlet weak var DescriptionCell: UITextView!
    @IBOutlet weak var DatePick: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        DescriptionCell.layer.borderWidth = 1.0
        DescriptionCell.layer.borderColor = UIColor.lightGray.cgColor
        DescriptionCell.layer.cornerRadius = 8;
    }

    @IBAction func onClick(_ sender: Any) {
        DatePick.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy hh:mm"
        let selectedDate = dateFormatter.string(from: DatePick.date)

        if (NameCell.text! != "") {
            List.append(Person(name: NameCell.text!, description: DescriptionCell.text!, date: selectedDate))
        }

        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }

}
