//
//  ContactViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 05/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import MBProgressHUD

class ContactViewController: BaseViewController {

    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelAppName: UILabel!
//    @IBOutlet weak var labelImageMap: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelEmailid: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textViewMessage: UITextView!
    @IBOutlet weak var buttonSend: UIButton!
//    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    
    var restaurantInfo = RestaurantInfo()
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["Contact"] as? String != nil) ? (self.appDelegate.languageData["Contact"] as! String).trim() : "Contact"
        
        let messageFeelFree = (self.appDelegate.languageData["Feel_free_to_drop_us_a_message"] as? String != nil) ? (self.appDelegate.languageData["Feel_free_to_drop_us_a_message"] as! String).trim() : "Feel free to drop us a message"
        let emailAddress = (self.appDelegate.languageData["Enter_your_email"] as? String != nil) ? (self.appDelegate.languageData["Enter_your_email"] as! String).trim() : "Enter your email address"
        let mobileNumber = (self.appDelegate.languageData["Mobile_No"] as? String != nil) ? (self.appDelegate.languageData["Mobile_No"] as! String).trim() : "Mobile Number"
        let messageString = (self.appDelegate.languageData["Message"] as? String != nil) ? (self.appDelegate.languageData["Message"] as! String).trim() : "Message"
        let buttonSendString = (self.appDelegate.languageData["Send"] as? String != nil) ? (self.appDelegate.languageData["Send"] as! String).trim() : "Send"
        let yourName = (self.appDelegate.languageData["Your_Name"] as? String != nil) ? (self.appDelegate.languageData["Your_Name"] as! String).trim() : "Name"
        self.labelMessage.text = messageFeelFree
        self.textFieldEmail.placeholder = emailAddress
        self.textFieldMobileNumber.placeholder = mobileNumber
        self.textFieldName.placeholder = yourName
        self.buttonSend.setTitle(buttonSendString, for: .normal)
        
        self.setupBackBarButton()
        self.textViewMessage.placeholder = messageString
        UtilityMethods.addBorderAndShadow(self.buttonSend, 5.0)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) != nil {
            
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        
        self.labelAppName.text = self.restaurantInfo.restaurantName
        self.labelAddress.text = self.restaurantInfo.address
        self.labelNumber.text = (self.restaurantInfo.contactNumber.isEmpty) ? "-" : (self.restaurantInfo.contactNumber)
        self.labelEmailid.text = (self.restaurantInfo.contactEmail.isEmpty) ? "-" : (self.restaurantInfo.contactEmail)
    }
    
//    Func check validation for form
    func checkValidation() -> Bool {
        
        self.view.endEditing(true)
        if self.textFieldName.text!.isEmpty {
            self.textFieldName.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.USERNAME_FIELD_IS_REQUIRED)
            return false
        }
        if self.textFieldEmail.text!.isEmpty {
            self.textFieldEmail.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.EMAIL_FIELD_IS_REQUIRED)
            return false
        }
        if !RegularExpression.validateEmail(self.textFieldEmail.text!) {
            self.textFieldEmail.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PLEASE_ENTER_VALID_EMAIL)
            return false
        }
        if self.textFieldMobileNumber.text!.isEmpty {
            self.textFieldMobileNumber.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.MOBILE_NO_FIELD_IS_REQUIRED)
            return false
        }
        if self.textFieldMobileNumber.text!.count > 14 {
            self.textFieldMobileNumber.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PLEASE_ENTER_VALID_MOBILE)
            return false
        }
        if self.textViewMessage.text!.isEmpty {
            self.textViewMessage.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.MESSAGE_FIELD_IS_REQUIRED)
            return false
        }
        
        return true
    }
    
//        MARK:- Button Action
    @IBAction func buttonSendMessageAction(_ sender: UIButton) {
        
        if self.checkValidation() {
            self.webApiSubmitContactDetails()
        }
    }
    
    @IBAction func buttonOpenLocationMapAction(_ sender: UIButton) {
        
        if (Double(self.restaurantInfo.latitude) == nil) || (Double(self.restaurantInfo.longitude) == nil) {
            self.showToastWithMessage(self.view, ConstantStrings.NO_CORDINATES_AVAILABLE)
        }else {
            let coordinate = CLLocationCoordinate2DMake(Double(self.restaurantInfo.latitude)!, Double(self.restaurantInfo.longitude)!)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = self.restaurantInfo.restaurantName
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
//        MARK:- Web Api Code start
//    Api for get Customer review List
        func webApiSubmitContactDetails() -> Void {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let url = WebApi.BASE_URL + "phpexpert_customer_contact_submit.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&contact_name=\(self.textFieldName.text!)&contact_email=\(self.textFieldEmail.text!)&contact_mobile=\(self.textFieldMobileNumber.text!)&contact_message=\(self.textViewMessage.text!)"
            WebApi.webApiForGetRequest(url) { (json : JSON) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if json.isEmpty {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
                }else{
                    if json["error"] == true {
                        self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                    }else {
                        self.setupOnSuccessWriteReview(json.dictionaryObject!)
                    }
                }
            }
        }
        
    //    Setup OnSuccess Write review
        func setupOnSuccessWriteReview(_ jsonDictionary : Dictionary<String, Any>) -> Void {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
                if jsonDictionary[JSONKey.ERROR_CODE] as! Int == 1 {
                    if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                        self.textFieldName.text = ""
                        self.textFieldEmail.text = ""
                        self.textFieldMobileNumber.text = ""
                        self.textViewMessage.text = ""
                        self.showToastWithMessage(self.view, (jsonDictionary[JSONKey.ERROR_MESSAGE] as! String))
                    }
                }
            }else {
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    self.showToastWithMessage(self.view, (jsonDictionary[JSONKey.ERROR_MESSAGE] as! String))
                }
            }
        }
}
