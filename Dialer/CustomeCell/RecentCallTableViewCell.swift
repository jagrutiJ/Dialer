//
//  RecentCallTableViewCell.swift
//  Dialer
//
//  Created by Jagruti on 12/3/18.
//  Copyright © 2018 Jagruti. All rights reserved.
//

import UIKit

class RecentCallTableViewCell: UITableViewCell {

  @IBOutlet var name : UILabel!
  @IBOutlet var number : UILabel!
  @IBOutlet var callTime : UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
