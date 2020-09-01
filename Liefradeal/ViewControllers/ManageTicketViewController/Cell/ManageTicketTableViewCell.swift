//
//  ManageTicketTableViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 02/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

protocol SubmitTicketDelegate : class {
    
    func moveOnPageSubmitTicket(_ indexPath : IndexPath)
}

class ManageTicketTableViewCell: UITableViewCell {

    var indexPath = IndexPath()
    weak var delegate : SubmitTicketDelegate?
    @IBOutlet weak var labelTicketNumber: UILabel!
    @IBOutlet weak var labelOrderNumber: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //    MARK:- Button Action
    @IBAction func buttonSubmitTicketAction(_ sender: UIButton) {
        
        self.delegate?.moveOnPageSubmitTicket(self.indexPath)
    }
}
