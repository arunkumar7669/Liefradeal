//
//  LoyaltyTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 04/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class LoyaltyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imageViewLoyalty: UIImageView!
    @IBOutlet weak var labelPoints: UILabel!
    @IBOutlet weak var viewBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.labelPoints.textColor = Colors.colorWithHexString(Colors.RED_COLOR)
        UtilityMethods.addBorderAndShadow(self.viewBg, 5.0)
        self.viewBg.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
