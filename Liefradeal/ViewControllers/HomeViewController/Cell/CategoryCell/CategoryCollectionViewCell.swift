//
//  CategoryCollectionViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 02/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMenuBg: UIView!
    @IBOutlet weak var imageViewMenu: UIImageView!
    @IBOutlet weak var labelMenu: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viewMenuBg.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewBottom.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.viewBottom.layer.cornerRadius = self.viewBottom.bounds.height / 2
        
        UtilityMethods.addBorderAndShadow(self.viewMenuBg, 5.0)
    }

}
