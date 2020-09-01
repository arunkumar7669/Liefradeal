//
//  RestaurantListTVC.swift
//  Liefradeal
//
//  Created by Arun Kumar Rathore on 31/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class RestaurantListTVC: UITableViewCell {

    @IBOutlet weak var viewRestaurantBg: UIView!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        UtilityMethods.addBorderAndShadow(self.viewStatus, 3.0)
        UtilityMethods.addBorderAndShadow(self.imageViewRestaurant, 5.0)
        UtilityMethods.addBorderAndShadow(self.viewRestaurantBg, 5.0)
        UtilityMethods.addShadow(self.viewContainer)
    }
    
}
