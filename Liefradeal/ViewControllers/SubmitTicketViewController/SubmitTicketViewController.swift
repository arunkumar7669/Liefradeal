//
//  SubmitTicketViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 05/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

protocol NewComplaintSubmettedDelegate : class {
    
    func newComplaintSubmitted(_ message : String)
}

class SubmitTicketViewController: BaseViewController {

    @IBOutlet weak var textFieldOrderNumber: UITextField!
    @IBOutlet weak var textFieldIssueType: UITextField!
    @IBOutlet weak var textViewComment: UITextView!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var userDetails = UserDetails()
    weak var delegate : NewComplaintSubmettedDelegate?
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["Submit_Ticket"] as? String != nil) ? (self.appDelegate.languageData["Submit_Ticket"] as! String).trim() : "Submit Ticket"
        self.textFieldOrderNumber.placeholder = (self.appDelegate.languageData["Order_Number"] as? String != nil) ? (self.appDelegate.languageData["Order_Number"] as! String).trim() : "Order Number"
        self.textFieldIssueType.placeholder = (self.appDelegate.languageData["Issue_Type"] as? String != nil) ? (self.appDelegate.languageData["Issue_Type"] as! String).trim() : "Issue Type"
        self.textViewComment.placeholder = (self.appDelegate.languageData["Comment"] as? String != nil) ? (self.appDelegate.languageData["Comment"] as! String).trim() : "Comment"
        let buttonSubmitTitle = (self.appDelegate.languageData["Submit"] as? String != nil) ? (self.appDelegate.languageData["Submit"] as! String).trim() : "Submit"
        self.buttonSubmit.setTitle(buttonSubmitTitle, for: .normal)
        
        self.setupBackBarButton()
        UtilityMethods.addBorderAndShadow(self.buttonSubmit, 5.0)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
    }
    
    //    MARK:- Button Action
    @IBAction func buttonSubmitComplaintAction(_ sender: UIButton) {
        
        if self.checkValidation() {
            self.webApiSubmitComplaintTicketList()
        }
    }
    
    func checkValidation() -> Bool {
        
        if self.textFieldOrderNumber.text!.isEmpty {
            
            self.textFieldOrderNumber.becomeFirstResponder()
            self.showToastWithMessage(self.view, "Order number is required field.")
            return false
        }
        
        if self.textFieldIssueType.text!.isEmpty {
            
            self.textFieldIssueType.becomeFirstResponder()
            self.showToastWithMessage(self.view, "Issue type is required field.")
            return false
        }
        
        if self.textViewComment.text!.isEmpty {
            
            self.textViewComment.becomeFirstResponder()
            self.showToastWithMessage(self.view, "Comment is required field.")
            return false
        }
        
        return true
    }
    
    //    Get Manage Ticket
    func webApiSubmitComplaintTicketList() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_ticket_submit.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&CustomerId=\(self.userDetails.userID)&order_identifyno=\(self.textFieldOrderNumber.text!)&Order_Message=\(self.textViewComment.text!)&Order_Issue_Subject=\(self.textFieldIssueType.text!)&Order_Email_Address=\(self.userDetails.userEmail)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupOnSuccessNewComplaint(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Func setup Submit List
    func setupOnSuccessNewComplaint(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int == 0 {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    self.delegate?.newComplaintSubmitted((jsonDictionary[JSONKey.ERROR_MESSAGE] as! String))
                    self.navigationController?.popViewController(animated: true)
                }
            }else {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    self.showToastWithMessage(self.view, (jsonDictionary[JSONKey.ERROR_MESSAGE] as! String))
                }
            }
        }
    }
}

//{"error":0,"error_msg":"Thank you for submitting your query, our customer support will contact you very soon"}
//{"error":0,"error_msg":"Invalid Order Number"}
