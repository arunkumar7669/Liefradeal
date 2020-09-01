//
//  OpeningHoursTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 04/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class OpeningHoursTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
