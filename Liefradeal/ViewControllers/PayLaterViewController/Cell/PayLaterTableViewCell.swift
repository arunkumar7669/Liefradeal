//
//  PayLaterTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 23/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
protocol PayNowDelegate : class {
    
    func buttonPayNowAction(_ indexPath : IndexPath)
    func buttonContinueOrderClicked(_ indexPath : IndexPath)
}

class PayLaterTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonPayNow: UIButton!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelOrderId: UILabel!
    @IBOutlet weak var buttonContinueOrder: UIButton!
    
    weak var delegate : PayNowDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.buttonPayNow.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.buttonContinueOrder.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        UtilityMethods.addBorderAndShadow(self.buttonPayNow, 5.0)
        UtilityMethods.addBorderAndShadow(self.buttonContinueOrder, 5.0)
    }
    
    @IBAction func buttonPayNowClicked(_ sender: UIButton) {
        
        self.delegate?.buttonPayNowAction(self.indexPath)
    }
    
    @IBAction func buttonContinueOrderAction(_ sender: UIButton) {
        
        self.delegate?.buttonContinueOrderClicked(self.indexPath)
    }
}
