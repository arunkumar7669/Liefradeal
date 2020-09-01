//
//  CartTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 05/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

protocol ModifyCartItemCountDelegate : class {
    
    func updateCartItemQuantity(_ itemCount : String, _ indexPath : IndexPath, _ buttonTag : Int)
}

class CartTableViewCell: UITableViewCell {

//    @IBOutlet weak var imageViewFoodType: UIImageView!
    @IBOutlet weak var labelMenuName: UILabel!
    @IBOutlet weak var labelMenuDescription: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelPlus: UILabel!
    @IBOutlet weak var labelMinus: UILabel!
    @IBOutlet weak var viewCountBG: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    let MINUS_CLICKED = 1
    let PLUS_CLICKED = 2
    var indexPath = IndexPath()
    weak var delegate : ModifyCartItemCountDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viewCountBG.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewContainer.backgroundColor = .white
        
//        UtilityMethods.addBorderAndShadow(self.viewContainer, 5.0)
        UtilityMethods.addBorder(self.viewCountBG, Colors.colorWithHexString(Colors.GREEN_COLOR), 5.0)
        UtilityMethods.roundCorners(view: self.labelMinus, corners: [.topLeft, .bottomLeft], radius: 5.0)
        UtilityMethods.roundCorners(view: self.labelPlus, corners: [.topRight, .bottomRight], radius: 5.0)
        
        self.labelPrice.textColor = Colors.colorWithHexString(Colors.RED_COLOR)
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
                self.delegate?.updateCartItemQuantity("\(count)", self.indexPath, self.MINUS_CLICKED)
            }
        }else if sender.tag == self.PLUS_CLICKED {
            
            var count = Int(self.labelCount.text!)!
            
            if count < 99 {
                
                count += 1
//                self.labelCount.text = "\(count)"
                self.delegate?.updateCartItemQuantity("\(count)", self.indexPath, self.PLUS_CLICKED)
            }
        }
    }
}
