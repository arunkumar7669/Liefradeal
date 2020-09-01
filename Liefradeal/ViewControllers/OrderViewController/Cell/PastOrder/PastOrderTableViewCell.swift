//
//  PastOrderTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class PastOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewFoodType: UIImageView!
    @IBOutlet weak var labelOrderID: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var buttonReorder: UIButton!
    @IBOutlet weak var labelAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        self.buttonReorder.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.labelAmount.textColor = Colors.colorWithHexString(Colors.RED_COLOR)
        UtilityMethods.addBorderAndShadow(self.buttonReorder, 5.0)
        self.buttonReorder.isHidden = true
    }
    
    //    MARK:- Button Action
    @IBAction func buttonReorderAction(_ sender: UIButton) {
        
        
    }
}
