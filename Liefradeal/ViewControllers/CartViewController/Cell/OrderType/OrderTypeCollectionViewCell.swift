//
//  OrderTypeCollectionViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 14/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class OrderTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imageViewOrderType: UIImageView!
    @IBOutlet weak var labelOrderType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UtilityMethods.addBorderAndShadow(self.viewBg, 5.0)
    }

}
