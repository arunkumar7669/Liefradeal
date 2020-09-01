//
//  MenuTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 27/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

protocol ModifyItemCountDelegate : class {
    
    func updateItemQuantity(_ count : String, _ indexPath : IndexPath, _ buttonTag : Int)
    func itemAddedIntoCart( _ indexPath: IndexPath)
}

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var labelMenuName: UILabel!
    @IBOutlet weak var labelMenuDetails: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
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
    weak var delegate : ModifyItemCountDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UtilityMethods.addBorderAndShadow(self.viewBg, 5.0)
        UtilityMethods.addBorder(self.viewItemBG, Colors.colorWithHexString(Colors.GREEN_COLOR), 5.0)
        
        self.viewItemBG.backgroundColor = .white
        self.labelPlus.textColor = .white
        self.labelMinus.textColor = .white
        self.buttonAddToCart.setTitleColor(Colors.colorWithHexString(Colors.GREEN_COLOR), for: .normal)
        UtilityMethods.addBorder(self.buttonAddToCart, Colors.colorWithHexString(Colors.GREEN_COLOR), 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //    Button Plus & Minus Action
    @IBAction func buttonCountAction(_ sender: UIButton) {
        
        if sender.tag == self.MINUS_CLICKED {
            
            var count = Int(self.labelCount.text!)!
            
            if count > 0 {
                
                count -= 1
                //                self.labelCount.text = "\(count)"
                self.delegate?.updateItemQuantity("\(count)", self.indexPath, self.MINUS_CLICKED)
            }
        }else if sender.tag == self.PLUS_CLICKED {
            
            var count = Int(self.labelCount.text!)!
            
            if count < 99 {
                
                count += 1
                //                self.labelCount.text = "\(count)"
                self.delegate?.updateItemQuantity("\(count)", self.indexPath, self.PLUS_CLICKED)
            }
        }
    }
    
    //    Button Add to cart action
    @IBAction func buttonAddToCartAction(_ sender: UIButton) {
        
        self.delegate?.itemAddedIntoCart(self.indexPath)
    }
    
}
