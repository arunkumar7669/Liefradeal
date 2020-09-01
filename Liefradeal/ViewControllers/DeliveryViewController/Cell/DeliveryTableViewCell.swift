//
//  DeliveryTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 04/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class DeliveryTableViewCell: UITableViewCell {

    @IBOutlet weak var labelAreaName: UILabel!
    @IBOutlet weak var labelPostalCode: UILabel!
    @IBOutlet weak var labelMinAmount: UILabel!
    @IBOutlet weak var labelDeliveryCharge: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
