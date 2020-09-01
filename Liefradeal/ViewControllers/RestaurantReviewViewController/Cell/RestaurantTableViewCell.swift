//
//  RestaurantTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import Cosmos

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var viewUserReview: UIView!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelReview: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UtilityMethods.addBorderAndShadow(self.viewUserReview, 5.0)
        self.imageViewUser.layer.cornerRadius = self.imageViewUser.bounds.height / 2
        self.imageViewUser.layer.masksToBounds = true
        self.viewUserReview.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
