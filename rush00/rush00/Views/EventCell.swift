//
//  EventCell.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/15/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var cursus: UILabel!
    @IBOutlet weak var campus: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
