//
//  OptionCollectionViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class OptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imageViewOption: UIImageView!
    @IBOutlet weak var labelOptionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UtilityMethods.addBorderAndShadow(self.viewBg, 5.0)
    }

}
