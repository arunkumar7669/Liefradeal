//
//  StripeTableViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 19/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import Stripe
import SwiftyJSON
import MBProgressHUD

class StripeTableViewController: BaseViewController, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var buttonPayment: UIButton!
    @IBOutlet weak var labelPayableAmount: UILabel!
    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var labelPayable: UILabel!
    
    let paymentTextField = STPPaymentCardTextField()
    var totalAmount = String()
    var userDetails = UserDetails()
    var specialInstruction = String()
    var tableInformation = Dictionary<String, String>()
    var personCount = String()
    var tableID = String()
    var tableName = String()
    var bookingDate = String()
    var bookingTime = String()
    var serviceCharge = String()
    var subTotalAmount = String()
    var totalBillAmount = String()
    var totalFinalAmount = String()
    var totalDepositAmount = String()
    var totalDiscountAmount = String()
    var cutomerContactNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Stripe_Payment"] as? String != nil) ? (self.appDelegate.languageData["Stripe_Payment"] as! String).trim() : "Stripe Payment"
        self.labelPayable.text = (self.appDelegate.languageData["Payable_Amount"] as? String != nil) ? (self.appDelegate.languageData["Payable_Amount"] as! String).trim() : "Payable Amount"
        let buttonTitle = (self.appDelegate.languageData["PAY_STRING"] as? String != nil) ? (self.appDelegate.languageData["PAY_STRING"] as! String).trim() : "Pay"
        self.buttonPayment.setTitle(buttonTitle, for: .normal)
        self.setupBackBarButton()
        self.paymentTextField.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth - 30, height: 44)
        self.paymentTextField.delegate = self
        self.viewTextField.addSubview(self.paymentTextField)
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        UtilityMethods.addBorder(self.buttonPayment, Colors.colorWithHexString(Colors.GREEN_COLOR), 5.0)
        self.buttonPayment.isHidden = true
        self.labelPayableAmount.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.labelPayableAmount.text = ConstantStrings.RUPEES_SYMBOL + totalAmount
//        print("Timestamp: \(Int(NSDate().timeIntervalSince1970))")
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        if textField.isValid {
            self.buttonPayment.isHidden = false
        }else {
            self.buttonPayment.isHidden = true
        }
    }
    
//    Button Action
    @IBAction func buttPaymentOptionAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let cardParams: STPCardParams = STPCardParams()
        cardParams.number = self.paymentTextField.cardNumber
        cardParams.expMonth = self.paymentTextField.expirationMonth
        cardParams.expYear = self.paymentTextField.expirationYear
        cardParams.cvc = self.paymentTextField.cvc

        STPAPIClient.shared().createToken(withCard: cardParams, completion: { (token, error) -> Void in

            if let error = error {
                print(error)
            }else if let token = token {
                print(token)
                self.webApiSetupOrderPayment(token.tokenId)
            }
        })
    }
    
//    MARK:- Web Code Start
//    Web Api for get order tracking information
    func webApiSetupOrderPayment(_ tokenID : String) -> Void {
        
        let currencyCode = UserDefaultOperations.getStringObject(ConstantStrings.COUNTRY_CODE)
        let emailAddress = self.generate4DigitsRandomNumber(4) + self.userDetails.userEmail
        let url = WebApi.BASE_URL + "phpexpert_payment_intent_generate.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&amount=\(totalAmount)&currency=\(currencyCode)&stripeToken=\(tokenID)&description=\(emailAddress)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json[JSONKey.ERROR_CODE] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupPaymentForProdunct(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupPaymentForProdunct(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if (jsonDictionary["response"] as? String != nil) {
            
            if (jsonDictionary["response"] as! String == "Success") {
                
                webApiBookATable()
            }
        }
    }
    
//    Web Api Book Table
    func webApiBookATable() -> Void {
        
        let transactionNumber = self.userDetails.userID + "_\(Int(NSDate().timeIntervalSince1970))"
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_table_booking.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&CustomerId=\(self.userDetails.userID)&table_number_assign=\(self.tableID)&booking_mobile=\(self.cutomerContactNumber)&booking_date=\(self.bookingDate)&booking_time=\(self.bookingTime)&booking_instruction=\(self.specialInstruction)&Number_of_person=\(self.personCount)&Total_bill_amount=\(self.totalBillAmount)&Total_bill_discount_amount=\(self.totalDiscountAmount)&Total_Sub_Total_after_discount=\(self.subTotalAmount)&Total_Service_Charge=\(self.serviceCharge)&Total_Final_Amount=\(self.totalFinalAmount)&Total_Deposit_Amount=\(self.totalDepositAmount)&Transaction_Number=\(transactionNumber)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupBookTableOnSuccessfull(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupBookTableOnSuccessfull(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 1 {
                
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    
//                    self.delegate?.showMessageBookedTable((jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String))
//                    self.navigationController?.popViewController(animated: true)
                    let thankyouVC = ThankyouTableViewController.init(nibName: "ThankyouTableViewController", bundle: nil)
                    thankyouVC.bookingDate = self.bookingDate
                    thankyouVC.bookingTime = self.bookingTime
                    thankyouVC.tableNumber = self.tableName
                    thankyouVC.bookingConfirmation = (jsonDictionary["success_msg"] as? String != nil) ? (jsonDictionary["success_msg"] as! String) : ""
                    thankyouVC.thankyouString = (jsonDictionary["Thankyou"] as? String != nil) ? (jsonDictionary["Thankyou"] as! String) : ""
                    thankyouVC.transactionNumber = (jsonDictionary["Transaction_Number"] as? String != nil) ? (jsonDictionary["Transaction_Number"] as! String) : "0"
                    thankyouVC.noteString = (jsonDictionary["Important_Note"] as? String != nil) ? (jsonDictionary["Important_Note"] as! String) : ""
                    thankyouVC.bookingNumber = (jsonDictionary["Booking_Number"] as? String != nil) ? (jsonDictionary["Booking_Number"] as! String) : "0"
                    self.navigationController?.pushViewController(thankyouVC, animated: true)
                }
            }else {
                
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    
                    self.showToastWithMessage(self.view, (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String))
                }
            }
        }
    }
}

