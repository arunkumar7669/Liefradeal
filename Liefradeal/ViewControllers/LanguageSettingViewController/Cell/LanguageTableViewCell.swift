//
//  LanguageTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 19/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var labelLanguageSelection: UILabel!
    @IBOutlet weak var imageViewSelection: UIImageView!
    @IBOutlet weak var imageViewCountry: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.labelLanguageSelection.text = "Hindi"
        self.imageViewSelection.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
