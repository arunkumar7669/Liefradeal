//
//  DrawerTableViewCell.swift
//  YesBeauty
//
//  Created by Arun Kumar Rathore on 22/01/19.
//  Copyright © 2019 Arun Kumar Rathore. All rights reserved.
//

import UIKit

class DrawerTableViewCell: UITableViewCell {

    @IBOutlet weak var labelMenu: UILabel!
    @IBOutlet weak var imageViewMenu: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
