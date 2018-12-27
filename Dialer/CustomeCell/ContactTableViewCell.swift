//
//  DisplayMileTableViewCell.swift
//
//  Created by Jagruti on 4/9/18.
//  Copyright © 2018 Jagruti. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet var name : UILabel!
    @IBOutlet var number : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    //  self.containerview.layer.cornerRadius = 10.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
