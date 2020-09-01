//
//  StripeViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 13/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import Stripe
import SwiftyJSON
import MBProgressHUD

class StripeViewController: BaseViewController, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var buttonPayment: UIButton!
    @IBOutlet weak var labelPayableAmount: UILabel!
    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var labelPayable: UILabel!
    
    let paymentTextField = STPPaymentCardTextField()
    var totalAmount = String()
    var userDetails = UserDetails()
    var placeOrderUrl = String()
    var selectedAddressID = String()
    var paymentMethod = String()
    var specialInstruction = String()
    var scheduleTime = String()
    
    let ORDER_TIME = "ORDER_TIME"
    let CUSTOMER_ADDRESS_ID = "CUSTOMER_ADDRESS_ID"
    let PAYMENT_TYPE_STRING = "PAYMENT_TYPE_STRING"
    let SPECIAL_INSTRUCTION = "SPECIAL_INSTRUCTION"
    
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
                
                if self.specialInstruction.isEmpty {
                    
                    self.placeOrderUrl = self.placeOrderUrl.replacingOccurrences(of: self.SPECIAL_INSTRUCTION, with: "")
                }else {
                    
                    self.placeOrderUrl = self.placeOrderUrl.replacingOccurrences(of: self.SPECIAL_INSTRUCTION, with: self.specialInstruction)
                }
                self.placeOrderUrl = self.placeOrderUrl.replacingOccurrences(of: self.ORDER_TIME, with: self.scheduleTime)
                self.placeOrderUrl = self.placeOrderUrl.replacingOccurrences(of: self.CUSTOMER_ADDRESS_ID, with: self.selectedAddressID)
                self.placeOrderUrl = self.placeOrderUrl.replacingOccurrences(of: self.PAYMENT_TYPE_STRING, with: self.paymentMethod)
                self.webApiPlaceOrder(self.placeOrderUrl)
            }
        }
    }
    
    //    Web Api for place order
    func webApiPlaceOrder(_ url : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        WebApi.webApiForGetRequest(updatedUrl) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json[JSONKey.ERROR_CODE] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupUserDetails(json.dictionaryObject!)
                }
            }
        }
    }
    
    //    func for setup user details
    func setupUserDetails(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int != 0 {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }
        }else {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
                
                if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 1 {
                    
                    if jsonDictionary["order_identifyno"] as? String != nil {
                        
                        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS, "")
                        UserDefaultOperations.setBoolObject(ConstantStrings.IS_LOYALTY_POINTS_REDEEMED, false)
                        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS_AMOUNT, "")
                        UserDefaultOperations.setBoolObject(ConstantStrings.IS_COUPON_APPLIED, false)
                        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_COUPON_CODE, "")
                        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_COUPON_AMOUNT, "")
                        UserDefaultOperations.setArrayObject(ConstantStrings.CART_ITEM_LIST, Array<Any>())
                        
                        let orderID = jsonDictionary["order_identifyno"] as! String
                        let thankyouVC = ThankyouViewController.init(nibName: "ThankyouViewController", bundle: nil)
                        thankyouVC.orderID = String(orderID)
                        self.navigationController?.pushViewController(thankyouVC, animated: true)
                    }else {
                        
                        self.showToastWithMessage(self.view, ConstantStrings.YOUR_ORDER_COULD_NOT_PLACED)
                    }
                }
            }
        }
    }
}
