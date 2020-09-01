//
//  ManageTicketViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 02/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class ManageTicketViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SubmitTicketDelegate, NewComplaintSubmettedDelegate {

    @IBOutlet weak var viewTopTitle: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var labelNoMessage: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var labelAddComplaint: UILabel!
    @IBOutlet weak var labelTicketNumber: UILabel!
    @IBOutlet weak var labelOrderNumber: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    var userDetails = UserDetails()
    var arrayTicketList = Array<Dictionary<String, String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST)
        self.setupCartButtonWithBadge(arrayCartItems.count)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Manage_Ticket"] as? String != nil) ? (self.appDelegate.languageData["Manage_Ticket"] as! String).trim() : "Manage Ticket"
        self.labelNoMessage.text = (self.appDelegate.languageData["NO_ANY_COMPLAINT"] as? String != nil) ? (self.appDelegate.languageData["NO_ANY_COMPLAINT"] as! String).trim() : "No Delivery area available."
        self.labelTicketNumber.text = (self.appDelegate.languageData["Ticket_Number"] as? String != nil) ? (self.appDelegate.languageData["Ticket_Number"] as! String).trim() : "Ticket Number"
        self.labelOrderNumber.text = (self.appDelegate.languageData["Order_Number"] as? String != nil) ? (self.appDelegate.languageData["Order_Number"] as! String).trim() : "Order Number"
        self.labelStatus.text = (self.appDelegate.languageData["Status"] as? String != nil) ? (self.appDelegate.languageData["Status"] as! String).trim() : "Status"
        
        self.setupBackBarButton()
        self.buttonMenu.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        UtilityMethods.addBorderAndShadow(self.viewTopTitle, 5.0)
        self.viewTopTitle.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.buttonMenu.setTitle(ConstantStrings.GO_TO_MENU, for: .normal)
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        self.labelAddComplaint.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        UtilityMethods.addBorder(self.viewButton, Colors.colorWithHexString(Colors.GREEN_COLOR), self.viewButton.bounds.height / 2)
        self.labelNoMessage.isHidden = true
        self.setupTableViewDelegateAndDatasource()
        self.webApiGetManageTicketList()
    }
    
//    Setup tableView Delegate And datasource
    func setupTableViewDelegateAndDatasource() -> Void {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 40
    }
    
    //    MARK:- UITableView Delegate And Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayTicketList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ManageTicketTableViewCell", owner: self, options: nil)?.first as! ManageTicketTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.indexPath = indexPath
        
        let dictionary = self.arrayTicketList[indexPath.row]
        cell.labelTicketNumber.text = dictionary[JSONKey.TICKET_ID]
        cell.labelOrderNumber.text = dictionary[JSONKey.TICKET_ORDER_ID]
        cell.labelStatus.text = dictionary[JSONKey.TICKET_STATUS]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ticketVC = TicketViewController.init(nibName: "TicketViewController", bundle: nil)
        ticketVC.dictioanryTicket = self.arrayTicketList[indexPath.row]
        self.navigationController?.pushViewController(ticketVC, animated: true)
    }
    
//    Submitted Ticket
    func newComplaintSubmitted(_ message : String) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            self.showToastWithMessage(self.view, message)
        }
        self.webApiGetManageTicketList()
    }
    
//    Submit ticket Delegate Action
    func moveOnPageSubmitTicket(_ indexPath : IndexPath) {
        
        let submitTicketVC = SubmitTicketViewController.init(nibName: "SubmitTicketViewController", bundle: nil)
        self.navigationController?.pushViewController(submitTicketVC, animated: true)
    }
    
//    MARK:- Button Action
    @IBAction func buttonAddNewComplaintAction(_ sender: UIButton) {
        
        let submitTicketVC = SubmitTicketViewController.init(nibName: "SubmitTicketViewController", bundle: nil)
        submitTicketVC.delegate = self
        self.navigationController?.pushViewController(submitTicketVC, animated: true)
    }
    
//    MARK:- Web Api Start Code
//    Get Manage Ticket
    func webApiGetManageTicketList() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_ticket_list.php?lang_code=\(WebApi.LANGUAGE_CODE)&api_key=\(WebApi.API_KEY)&CustomerId=\(self.userDetails.userID)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupManageTicketList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup Manage Ticket List
    func setupManageTicketList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.TICKET_LIST] as? Array<Dictionary<String, Any>> != nil {
            
            self.arrayTicketList.removeAll()
            let arrayTicket = jsonDictionary[JSONKey.TICKET_LIST] as! Array<Dictionary<String, Any>>
            
            for ticket in arrayTicket {
                
                if ticket[JSONKey.ERROR_CODE] as? String != nil {
                    
                    if ticket[JSONKey.ERROR_CODE] as! String == "0" {
                        
                        var dictionaryTicket = Dictionary<String, String>()
                        dictionaryTicket[JSONKey.TICKET_ID] = (ticket[JSONKey.TICKET_ID] as? String != nil) ? (ticket[JSONKey.TICKET_ID] as! String) : "0"
                        dictionaryTicket[JSONKey.TICKET_ORDER_ID] = (ticket[JSONKey.TICKET_ORDER_ID] as? String != nil) ? (ticket[JSONKey.TICKET_ORDER_ID] as! String) : "0"
                        dictionaryTicket[JSONKey.TICKET_MESSAGE] = (ticket[JSONKey.TICKET_MESSAGE] as? String != nil) ? (ticket[JSONKey.TICKET_MESSAGE] as! String) : " "
                        dictionaryTicket[JSONKey.TICKET_ISSUE] = (ticket[JSONKey.TICKET_ISSUE] as? String != nil) ? (ticket[JSONKey.TICKET_ISSUE] as! String) : " "
                        dictionaryTicket[JSONKey.TICKET_STATUS] = (ticket[JSONKey.TICKET_STATUS] as? String != nil) ? (ticket[JSONKey.TICKET_STATUS] as! String) : " "
                        dictionaryTicket[JSONKey.TICKET_REPLY] = (ticket[JSONKey.TICKET_REPLY] as? String != nil) ? (ticket[JSONKey.TICKET_REPLY] as! String) : " "
                        
                        if !dictionaryTicket.isEmpty {
                            
                            self.arrayTicketList.append(dictionaryTicket)
                        }
                    }else {
                        
                        if ticket[JSONKey.ERROR_MESSAGE] as? String != nil {
                            
                            self.showToastWithMessage(self.view, (ticket[JSONKey.ERROR_MESSAGE] as! String))
                        }
                    }
                }
            }
        }
        
        if self.arrayTicketList.count == 0 {
            
            self.labelNoMessage.isHidden = false
        }else {
            
            self.labelNoMessage.isHidden = true
            self.tableView.reloadData()
        }
    }
}
