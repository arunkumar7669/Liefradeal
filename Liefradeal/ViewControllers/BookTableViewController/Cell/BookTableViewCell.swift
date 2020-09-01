//
//  BookTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 25/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewSelect: UIImageView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imageViewTable: UIImageView!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelTableCount: UILabel!
    @IBOutlet weak var labelUserCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UtilityMethods.addBorder(self.viewBg, .white, 5.0)
        self.viewBg.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
