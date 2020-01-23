//
//  PlaceTableViewCell.swift
//  day05
//
//  Created by Aubane COULOMBIER on 12/16/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
