//
//  OfferTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 05/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imageViewOffer: UIImageView!
    @IBOutlet weak var labelOffer: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelCode: UILabel!
    @IBOutlet weak var labelOfferFor: UILabel!
    @IBOutlet weak var labelTillValid: UILabel!
    @IBOutlet weak var labelOfferDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UtilityMethods.addBorderAndShadow(self.viewBg, 5.0)
        self.viewBg.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
