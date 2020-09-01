//
//  MenuDetailsTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 02/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class MenuDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewSelection: UIImageView!
    @IBOutlet weak var labelMenuDetail: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
