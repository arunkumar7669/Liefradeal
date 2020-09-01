//
//  SplashCollectionViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class SplashCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewSplash: UIImageView!
    @IBOutlet weak var labelTitle1: UILabel!
    @IBOutlet weak var labelTitle2: UILabel!
    @IBOutlet weak var labelTitle3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.labelTitle1.textColor = Colors.colorWithHexString(Colors.BLACK_COLOR)
        self.labelTitle2.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.labelTitle3.textColor = Colors.colorWithHexString(Colors.BLACK_COLOR)
    }

}
