//
//  SelectBranchTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 07/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

protocol SelectBranchLocationMapDelegate : class {
    
    func openAppleMapWith(_ indexPath : IndexPath)
}

class SelectBranchTableViewCell: UITableViewCell {

    @IBOutlet weak var labelLocationName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var emailIconHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewSelect: UIImageView!
    
    var indexPath = IndexPath()
    weak var delegate : SelectBranchLocationMapDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.labelLocationName.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.labelAddress.textColor = Colors.colorWithHexString(Colors.DARK_GRAY_COLOR)
        self.labelPhone.textColor = Colors.colorWithHexString(Colors.DARK_GRAY_COLOR)
        self.labelEmail.textColor = Colors.colorWithHexString(Colors.DARK_GRAY_COLOR)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonOpenLocationMapAction(_ sender: UIButton) {
        
        self.delegate?.openAppleMapWith(self.indexPath)
    }
}