//
//  TicketViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 11/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class TicketViewController: BaseViewController {

    @IBOutlet weak var labelTicketNo: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelIssueType: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var labelReply: UILabel!
    @IBOutlet weak var labelTicketNumberTitle: UILabel!
    @IBOutlet weak var labelTableStatusTitle: UILabel!
    @IBOutlet weak var labelLookingFor: UILabel!
    @IBOutlet weak var labelMessageTitle: UILabel!
    @IBOutlet weak var labelReplyTitle: UILabel!
    
    var dictioanryTicket = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        self.navigationItem.title = (self.appDelegate.languageData["Manage_Ticket"] as? String != nil) ? (self.appDelegate.languageData["Manage_Ticket"] as! String).trim() : "Manage Ticket"
        self.labelTicketNumberTitle.text = (self.appDelegate.languageData["Ticket_Number"] as? String != nil) ? (self.appDelegate.languageData["Ticket_Number"] as! String).trim() : "Ticket Number"
        self.labelMessageTitle.text = (self.appDelegate.languageData["Message"] as? String != nil) ? (self.appDelegate.languageData["Message"] as! String).trim() : "Message"
        self.labelStatus.text = (self.appDelegate.languageData["Status"] as? String != nil) ? (self.appDelegate.languageData["Status"] as! String).trim() : "Status"
        self.labelLookingFor.text = (self.appDelegate.languageData["Looking_For"] as? String != nil) ? (self.appDelegate.languageData["Looking_For"] as! String).trim() : "Looking For"
        self.labelReplyTitle.text = (self.appDelegate.languageData["Reply"] as? String != nil) ? (self.appDelegate.languageData["Reply"] as! String).trim() : "Reply"
        
        self.setupBackBarButton()
        self.labelTicketNo.text = self.dictioanryTicket[JSONKey.TICKET_ID]
        self.labelStatus.text = self.dictioanryTicket[JSONKey.TICKET_STATUS]
        self.labelIssueType.text = self.dictioanryTicket[JSONKey.TICKET_ISSUE]
        self.labelComment.text = self.dictioanryTicket[JSONKey.TICKET_MESSAGE]
        self.labelReply.text = self.dictioanryTicket[JSONKey.TICKET_REPLY]
        if self.labelReply.text!.isEmpty {
            self.labelReplyTitle.text = ""
        }
    }
}
