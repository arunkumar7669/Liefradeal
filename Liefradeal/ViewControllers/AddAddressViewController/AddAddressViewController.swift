//
//  AddAddressViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 24/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import RPFloatingPlaceholders

protocol RefreshAddressListDelegate : class {
    
    func refreshAddressList()
}

class AddAddressViewController: BaseViewController {

    @IBOutlet weak var textFieldAddressTitle: UITextField!
    @IBOutlet weak var textFieldHomeNumber: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldStreetName: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldPostalCode: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldCity: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldPhone: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldFlatName: RPFloatingPlaceholderTextField!
    @IBOutlet weak var buttonAddAddress: UIButton!
    @IBOutlet weak var labelAddAddressTitle: UILabel!
    
    var userDetails = UserDetails()
    weak var delegate : RefreshAddressListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        let buttonAddAddressTitle = (self.appDelegate.languageData["add_address"] as? String != nil) ? (self.appDelegate.languageData["add_address"] as! String).trim() : "Add Address"
        self.navigationItem.title = buttonAddAddressTitle
        self.buttonAddAddress.setTitle(buttonAddAddressTitle, for: .normal)
        let addressTitlePlaceholder = (self.appDelegate.languageData["Address_Title"] as? String != nil) ? (self.appDelegate.languageData["Address_Title"] as! String).trim() : "Address Title"
        let houseDoorPlaceholder = (self.appDelegate.languageData["House_Door_Number"] as? String != nil) ? (self.appDelegate.languageData["House_Door_Number"] as! String).trim() : "House/Door Number"
        let flatNamePlaceholder = (self.appDelegate.languageData["Flat_Name"] as? String != nil) ? (self.appDelegate.languageData["Flat_Name"] as! String).trim() : "Flat Name"
        let streetNamePlaceholder = (self.appDelegate.languageData["Street_Name"] as? String != nil) ? (self.appDelegate.languageData["Street_Name"] as! String).trim() : "Street Name"
        let PostCodePlaceholder = (self.appDelegate.languageData["Postal_Code"] as? String != nil) ? (self.appDelegate.languageData["Postal_Code"] as! String).trim() : "Postcode"
        let cityPlaceholder = (self.appDelegate.languageData["City_Name"] as? String != nil) ? (self.appDelegate.languageData["City_Name"] as! String).trim() : "City Name"
        let phoneNumberPlaceholder = (self.appDelegate.languageData["Mobile_No"] as? String != nil) ? (self.appDelegate.languageData["Mobile_No"] as! String).trim() : "Mobile Number"
        self.labelAddAddressTitle.text = (self.appDelegate.languageData["Add_New_Address"] as? String != nil) ? (self.appDelegate.languageData["Add_New_Address"] as! String).trim() : "Add New Address"
        
        self.textFieldAddressTitle.placeholder = addressTitlePlaceholder
        self.textFieldHomeNumber.placeholder = houseDoorPlaceholder
        self.textFieldHomeNumber.placeholder = flatNamePlaceholder
        self.textFieldStreetName.placeholder = streetNamePlaceholder
        self.textFieldPostalCode.placeholder = PostCodePlaceholder
        self.textFieldCity.placeholder = cityPlaceholder
        self.textFieldPhone.placeholder = phoneNumberPlaceholder
        
        self.setupBackBarButton()
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        UtilityMethods.addBorderAndShadow(self.buttonAddAddress, self.buttonAddAddress.bounds.height / 2)
        let dictionaryPostalCodeDetails = UserDefaultOperations.getDictionaryObject(ConstantStrings.POSTAL_CODE_INFO)
        if !dictionaryPostalCodeDetails.isEmpty{
            if dictionaryPostalCodeDetails[JSONKey.POSTALCODE_CITY] != nil {
                self.textFieldCity.text = (dictionaryPostalCodeDetails[JSONKey.POSTALCODE_CITY] as! String)
                self.textFieldCity.textColor = .darkGray
                self.textFieldCity.isUserInteractionEnabled = false
            }
            if dictionaryPostalCodeDetails[JSONKey.POSTALCODE_POSTAL_CODE] != nil {
                self.textFieldPostalCode.text = (dictionaryPostalCodeDetails[JSONKey.POSTALCODE_POSTAL_CODE] as! String)
                self.textFieldPostalCode.textColor = .darkGray
                self.textFieldPostalCode.isUserInteractionEnabled = false
            }
        }
    }
    
//    Check validation
    func checkValidation() -> Bool {
        
        self.view.endEditing(true)
        if self.textFieldAddressTitle.text!.isEmpty {
            
            self.textFieldAddressTitle.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.ADDRESS_TITLE_FIELD_IS_REQUIRED)
            return false
        }
        if self.textFieldHomeNumber.text!.isEmpty {
            
            self.textFieldHomeNumber.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.HOME_NUMBER_IS_REQUIRED)
            return false
        }
        
        if self.textFieldStreetName.text!.isEmpty {
            
            self.textFieldStreetName.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.STREET_NAME_IS_REQUIRED)
            return false
        }
        if self.textFieldPostalCode.text!.isEmpty {
            
            self.textFieldPostalCode.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.POSTAL_CODE_FIELD_IS_REQUIRED)
            return false
        }
        if self.textFieldCity.text!.isEmpty {
            
            self.textFieldCity.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.CITY_NAME_FIELD_IS_REQUIRED)
            return false
        }
        if self.textFieldPhone.text!.isEmpty {
            
            self.textFieldPhone.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.MOBILE_NO_FIELD_IS_REQUIRED)
            return false
        }
        if self.textFieldPhone.text!.count > 14 {
            
            self.textFieldPhone.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PLEASE_ENTER_VALID_MOBILE)
            return false
        }
        
        return true
    }
    
    //    MARK:- Button Action
    @IBAction func buttonAddAddressAction(_ sender: UIButton) {
        
        if self.checkValidation() {
            
            self.webApiAddAddress()
        }
    }
    
    //    MARK:- Web Code Start
//    Func web Api add address
    func webApiAddAddress() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = WebApi.BASE_URL + "phpexpert_customer_add_new_address.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&user_phone=\(self.textFieldPhone.text!)&customerAddressLabel=\(self.textFieldAddressTitle.text!)&customerFloor_House_Number=\(self.textFieldHomeNumber.text!)&customerStreet=\(self.textFieldStreetName.text!)&customerCity=\(self.textFieldCity.text!)&customerZipcode=\(self.textFieldPostalCode.text!)&address_direction=&CustomerId=\(self.userDetails.userID)&customerFlat_Name=\(self.textFieldFlatName.text!)"
        
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupOnSuccessAddAddress(json.dictionaryObject!)
                }
            }
        }
    }
    
    //    Setup On Success Add Address
    func setupOnSuccessAddAddress(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int != 0 {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    self.showToastWithMessage(self.view, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }
        }else {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
                
                if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 1 {
                    
                    if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                        
                        self.delegate?.refreshAddressList()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
