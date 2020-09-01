//
//  AddressTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 05/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

protocol AddressOptionDelegate : class {
    
    func deleteAddressButtonAction(_ indexPath : IndexPath)
}

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var labelAddressName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelPhoneTitle: UILabel!
    @IBOutlet weak var labelPhoneNo: UILabel!
    
    var indexPath = IndexPath()
    weak var delegate : AddressOptionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    Button Action
    @IBAction func buttonOptionClicked(_ sender: UIButton) {
        
//        self.delegate?.optionClickedForMoreAddressOption(self.indexPath)
        self.delegate?.deleteAddressButtonAction(self.indexPath)
    }
}
