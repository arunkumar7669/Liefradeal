//
//  NewCategoryCollectionViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 12/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class NewCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageViewCategory: UIImageView!
    @IBOutlet weak var viewCategoryName: UIView!
    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viewContainer.layer.cornerRadius = 5.0
    }

}
//
