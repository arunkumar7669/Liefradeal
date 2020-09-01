//
//  LiveOrderTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

protocol LiveOrderOptionDelegate : class {
    
    func trackOrderWithIndexPath(_ indexPath : IndexPath)
    func cancelOrderWithIndexPath(_ indexPath : IndexPath)
}

class LiveOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewFoodType: UIImageView!
    @IBOutlet weak var labelOrderID: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonReorder: UIButton!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var buttonCancelHeight: NSLayoutConstraint!
    
    var indexPath = IndexPath()
    weak var delegate : LiveOrderOptionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.buttonCancel.backgroundColor = Colors.colorWithHexString(Colors.RED_COLOR)
        self.buttonReorder.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.labelAmount.textColor = Colors.colorWithHexString(Colors.RED_COLOR)
        UtilityMethods.addBorderAndShadow(self.buttonCancel, 5.0)
        UtilityMethods.addBorderAndShadow(self.buttonReorder, 5.0)
//        self.buttonReorder.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //    MARK:- Button Action
    @IBAction func buttonCancelAction(_ sender: UIButton) {
        
        self.delegate?.cancelOrderWithIndexPath(self.indexPath)
    }
    
    @IBAction func buttonReorderAction(_ sender: UIButton) {
        
        self.delegate?.trackOrderWithIndexPath(self.indexPath)
    }
}
