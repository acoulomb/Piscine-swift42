//
//  SearchBarViewCell.swift
//  day04
//
//  Created by Aubane COULOMBIER on 12/14/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit

class SearchBarViewCell: UITableViewCell {

    @IBOutlet weak var searchBar: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
