//
//  RecommendCollectionViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

protocol ModifyCollectionViewItemCountDelegate : class {
    
    func updateItemQuantity(_ count : String, _ indexPath : IndexPath)
    func itemAddedIntoCart( _ indexPath: IndexPath)
}

class RecommendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewBg: UIView!
//    @IBOutlet weak var imageViewItem: UIImageView!
//    @IBOutlet weak var imageViewFoodType: UIImageView!
    @IBOutlet weak var labelMenuName: UILabel!
    @IBOutlet weak var labelMenuDetails: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
//    @IBOutlet weak var imageViewItemCart: UIImageView!
//    @IBOutlet weak var imageViewStars: UIImageView!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelPlus: UILabel!
    @IBOutlet weak var labelMinus: UILabel!
    @IBOutlet weak var viewItemBG: UIView!
    @IBOutlet weak var buttonAddToCart: UIButton!
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var buttonMinus: UIButton!
    @IBOutlet weak var labelOriginalPrice: UILabel!
    
    let MINUS_CLICKED = 1
    let PLUS_CLICKED = 2
    var indexPath = IndexPath()
    weak var delegate : ModifyCollectionViewItemCountDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.imageViewItemCart.isHidden = true
        UtilityMethods.addBorderAndShadow(self.viewBg, 5.0)
        UtilityMethods.addBorder(self.viewItemBG, Colors.colorWithHexString(Colors.GREEN_COLOR), 5.0)
        
        self.viewItemBG.backgroundColor = .white
        self.labelPlus.textColor = .white
        self.labelMinus.textColor = .white
        self.buttonAddToCart.setTitleColor(Colors.colorWithHexString(Colors.GREEN_COLOR), for: .normal)
        UtilityMethods.addBorder(self.buttonAddToCart, Colors.colorWithHexString(Colors.GREEN_COLOR), 5.0)
    }

//    Button Plus & Minus Action
    @IBAction func buttonCountAction(_ sender: UIButton) {
        
        if sender.tag == self.MINUS_CLICKED {
            
            var count = Int(self.labelCount.text!)!
            
            if count > 0 {
                
                count -= 1
//                self.labelCount.text = "\(count)"
                self.delegate?.updateItemQuantity("\(count)", self.indexPath)
            }
        }else if sender.tag == self.PLUS_CLICKED {
            
            var count = Int(self.labelCount.text!)!
            
            if count < 99 {
                
                count += 1
//                self.labelCount.text = "\(count)"
                self.delegate?.updateItemQuantity("\(count)", self.indexPath)
            }
        }
    }
    
//    Button Add to cart action
    @IBAction func buttonAddToCartAction(_ sender: UIButton) {
        
        self.delegate?.itemAddedIntoCart(self.indexPath)
    }
    
}
