//
//  TrackTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 08/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewCenter: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viewCenter.layer.cornerRadius = self.viewCenter.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
