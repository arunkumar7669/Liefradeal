//
//  CancelledOrderTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 07/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class CancelledOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var labelOrderID: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        self.labelAmount.textColor = Colors.colorWithHexString(Colors.RED_COLOR)
    }
    
}
