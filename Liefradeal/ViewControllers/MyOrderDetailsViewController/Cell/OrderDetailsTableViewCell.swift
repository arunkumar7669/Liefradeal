//
//  OrderDetailsTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelItemName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var imageViewFoodType: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.labelQuantity.textColor = Colors.colorWithHexString(Colors.RED_COLOR)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
