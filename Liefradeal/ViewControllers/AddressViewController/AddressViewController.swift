//
//  AddressViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 05/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class AddressViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, AddressOptionDelegate, SelectAddressOptionDelegate, RefreshAddressListDelegate {
    
    func refreshAddressList() {
        
        self.webApiGetAllAddress()
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonGotoMenu: UIButton!
    @IBOutlet weak var buttonAddAddress: UIButton!
    @IBOutlet var viewAddAddress: UIView!
    @IBOutlet weak var buttonSaveAddress: UIButton!
    @IBOutlet weak var labelAddNewAddress: UILabel!
    @IBOutlet weak var textFieldAddressTitle: UITextField!
    @IBOutlet weak var textFieldHouseNumber: UITextField!
    @IBOutlet weak var textFieldStreetName: UITextField!
    @IBOutlet weak var textFieldPostalCode: UITextField!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var labelNoAddress: UILabel!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    var isAddressDeleted = Bool()
    var orderTypeString = String()
    var selectedAddressID = String()
    var placeOrderUrlString = String()
    var totalAmount = String()
    var button  = UIButton()
    var userDetails = UserDetails()
    var locationInfo = UserLocationInfo()
    let POPUP_VIEW_HEIGHT : CGFloat = 495
    var isAddressSelectable = Bool()
    var arrayAddressList = Array<Dictionary<String, String>>()
    var selectedAddress = Dictionary<String, String>()
    var orderType = Int()
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["Address"] as? String != nil) ? (self.appDelegate.languageData["Address"] as! String).trim() : "Address"
        
        self.setupBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewAddAddress.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.buttonAddAddress.layer.cornerRadius = self.buttonAddAddress.bounds.height / 2
        UtilityMethods.addBorderAndShadow(self.button, 5.0)
        UtilityMethods.addBorderAndShadow(self.viewAddAddress, 10.0)
        UtilityMethods.addBorderAndShadow(self.buttonSaveAddress, 5.0)
        self.setupTableViewDelegateAndDatasource()
        self.labelNoAddress.isHidden = true
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_LOCATION_INFO) as? UserLocationInfo != nil {
            
            self.locationInfo = UserDefaultOperations.getStoredObject(ConstantStrings.USER_LOCATION_INFO) as! UserLocationInfo
        }
        
        if self.isAddressSelectable {
            
            self.buttonGotoMenu.setTitle(ConstantStrings.CONFIRM_DELIVERY_ADDRESS, for: .normal)
        }else {
            
            self.buttonGotoMenu.setTitle(ConstantStrings.GO_TO_MENU, for: .normal)
        }
        self.webApiGetAllAddress()
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
        
        return self.arrayAddressList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.isAddressSelectable {
            
            let cell = Bundle.main.loadNibNamed("SelectAddressTableViewCell", owner: self, options: nil)?.first as! SelectAddressTableViewCell
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            cell.delegate = self
            
            let dictionary = self.arrayAddressList[indexPath.row]
            
            cell.labelAddressName.text = dictionary[JSONKey.ADDRESS_TITLE]
            cell.labelPhoneTitle.text = ConstantStrings.PHONE_NUMBER
            cell.labelPhoneNo.text = dictionary[JSONKey.USER_PHONE]
            cell.labelAddress.text = dictionary[JSONKey.ADDRESS]
            
            if dictionary[JSONKey.IS_ADDRESS_SELECTED] == ConstantStrings.SELECTED_VALUE {
                
                cell.imageViewSelect.image = UIImage(named: ConstantStrings.SELECTED_ADDRESS_IMAGE)
            }else {
                
                cell.imageViewSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
            }
            
            return cell
        }else {
            
            let cell = Bundle.main.loadNibNamed("AddressTableViewCell", owner: self, options: nil)?.first as! AddressTableViewCell
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            cell.delegate = self
            
            let dictionary = self.arrayAddressList[indexPath.row]
            
            cell.labelAddressName.text = dictionary[JSONKey.ADDRESS_TITLE]
            cell.labelPhoneTitle.text = ConstantStrings.PHONE_NUMBER
            cell.labelPhoneNo.text = dictionary[JSONKey.USER_PHONE]
            cell.labelAddress.text = dictionary[JSONKey.ADDRESS]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isAddressSelectable {
            
            for i in 0..<self.arrayAddressList.count {
                
                var dictionary = self.arrayAddressList[i]
                if indexPath.row == i {
                    
                    dictionary[JSONKey.IS_ADDRESS_SELECTED] = ConstantStrings.SELECTED_VALUE
                    self.selectedAddress = dictionary
                }else {
                    
                    dictionary[JSONKey.IS_ADDRESS_SELECTED] = ConstantStrings.UNSELECTED_VALUE
                }
                self.arrayAddressList[i] = dictionary
            }
            let dictionary = self.arrayAddressList[indexPath.row]
            self.selectedAddressID = dictionary[JSONKey.ADDRESS_ID]!
            self.tableView.reloadData()
        }
    }
    
//    Address Option Delegate
    func optionClickedForMoreAddressOption(_ indexPath : IndexPath) {
        
        
    }
    
    func deleteAddressButtonAction(_ indexPath : IndexPath) -> Void {
        
        let dictionaryAddress = self.arrayAddressList[indexPath.row]
        self.setupDeleteAddress(dictionaryAddress[JSONKey.ADDRESS_ID]!)
    }
    
//    Setup ask for delete address
    func setupDeleteAddress(_ addressID : String) -> Void {
        
        let alrtctrl = UIAlertController.init(title: ConstantStrings.ALERT, message: ConstantStrings.ARE_YOU_SURE_YOU_WANT_DELETE_ADDRESS, preferredStyle: .alert)
        
        let actionOK = UIAlertAction.init(title: ConstantStrings.OK_STRING, style: .default) { (alert) in
            
            self.webApiDeleteAddress(addressID)
        }
        
        let actionCancel = UIAlertAction.init(title: ConstantStrings.CANCEL_STRING, style: .default, handler: nil)
        
        alrtctrl.addAction(actionOK)
        alrtctrl.addAction(actionCancel)
        self.present(alrtctrl, animated: true, completion: nil)
    }
    
    //    MARK:- Button Action
    @IBAction func buttonCross(_ sender: UIButton) {
        
        self.viewAddAddress.removeFromSuperview()
        self.button.removeFromSuperview()
    }
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
        if self.isAddressSelectable {
            
            if self.selectedAddress.isEmpty {
                
                self.showToastWithMessage(self.view, ConstantStrings.PLEASE_SELECT_ADDRESS)
            }else {
                
                let paymentVC = PaymentViewController.init(nibName: "PaymentViewController", bundle: nil)
                paymentVC.totalAmount = self.totalAmount
                paymentVC.orderType = self.orderType
                paymentVC.placeOrderUrlString = self.placeOrderUrlString
                paymentVC.selectedAddressID = self.selectedAddressID
                self.navigationController?.pushViewController(paymentVC, animated: true)
            }
        }else {
            
            self.moveOnMenuPage()
        }
    }
    
    @IBAction func buttonSaveNewAddressClicked(_ sender: UIButton) {
        
        if self.checkValidation() {
            
            self.webApiAddAddress()
        }
    }
    
    @IBAction func buttonAddNewAddressClicked(_ sender: UIButton) {
        
//        let dictionaryPostalCodeDetails = UserDefaultOperations.getDictionaryObject(ConstantStrings.POSTAL_CODE_INFO)
//
//        if !dictionaryPostalCodeDetails.isEmpty{
//
//            if dictionaryPostalCodeDetails[JSONKey.POSTALCODE_CITY] != nil {
//
//                self.textFieldCity.text = (dictionaryPostalCodeDetails[JSONKey.POSTALCODE_CITY] as! String)
//                self.textFieldCity.textColor = .darkGray
//                self.textFieldCity.isUserInteractionEnabled = false
//            }
//            if dictionaryPostalCodeDetails[JSONKey.POSTALCODE_POSTAL_CODE] != nil {
//
//                self.textFieldPostalCode.text = (dictionaryPostalCodeDetails[JSONKey.POSTALCODE_POSTAL_CODE] as! String)
//                self.textFieldPostalCode.textColor = .darkGray
//                self.textFieldPostalCode.isUserInteractionEnabled = false
//            }
//        }
//
//        self.popupAddAddressView()
        let addAddressVC = AddAddressViewController.init(nibName: "AddAddressViewController", bundle: nil)
        addAddressVC.delegate = self
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
//    Popup Add Address View
    func popupAddAddressView() -> Void {
        
        self.button.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
        self.button.addTarget(self, action: #selector(self.buttonBackAction(_:)), for: .touchUpInside)
        self.button.backgroundColor = .black
        self.button.alpha = 0.4
        
        self.appDelegate.window?.rootViewController?.view.addSubview(self.button)
        
        let yposition = (self.screenHeight / 2) -  (self.POPUP_VIEW_HEIGHT / 2)
        
        self.viewAddAddress.frame = CGRect.init(x: 30, y: yposition, width: self.screenWidth - 60, height: self.POPUP_VIEW_HEIGHT)
        self.appDelegate.window?.rootViewController?.view.addSubview(self.viewAddAddress)
    }
    
    
    //    button back action
    @objc func buttonBackAction(_ sender: UIButton) {
        
        self.button.removeFromSuperview()
        self.viewAddAddress.removeFromSuperview()
    }
    
//    Check validation
    func checkValidation() -> Bool {
        
        self.view.endEditing(true)
        if self.textFieldAddressTitle.text!.isEmpty {
            
            self.textFieldAddressTitle.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.ADDRESS_TITLE_FIELD_IS_REQUIRED)
            return false
        }
        if self.textFieldHouseNumber.text!.isEmpty {
            
            self.textFieldHouseNumber.becomeFirstResponder()
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
//        if self.textFieldPostalCode.text!.count != 6 {
//            
//            self.textFieldPostalCode.becomeFirstResponder()
//            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PLEASE_ENTER_VALID_POSTAL_CODE)
//            return false
//        }
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
    
    //    MARK:- Web Api Code start
//    Api for get all address list
    func webApiGetAllAddress() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = WebApi.BASE_URL + "phpexpert_customer_address_list.php?CustomerId=\(self.userDetails.userID)&customer_long=\(self.locationInfo.latitude)&customer_lat=\(self.locationInfo.latitude)"
        
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupAllAddressList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup all address list
    func setupAllAddressList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.USER_ADDRESS] as? Dictionary<String, Any> != nil {
            
            let userAddressInfo = jsonDictionary[JSONKey.USER_ADDRESS] as! Dictionary<String, Any>
            if userAddressInfo[JSONKey.DELIVERY_ADDRESS] as? Array<Dictionary<String, Any>> != nil {
                
                self.arrayAddressList.removeAll()
                let arrayAddressList = userAddressInfo[JSONKey.DELIVERY_ADDRESS] as! Array<Dictionary<String, Any>>
                if arrayAddressList.count > 0 {
                    
                    for address in arrayAddressList {
                        
                        var dictionaryAddress = Dictionary<String, String>()
                        if address[JSONKey.ADDRESS_ID] as? Int != nil {
                            
                            dictionaryAddress[JSONKey.ADDRESS_ID] = String(address[JSONKey.ADDRESS_ID] as! Int)
                        }
                        if address[JSONKey.ADDRESS_TITLE] as? String != nil {
                            
                            dictionaryAddress[JSONKey.ADDRESS_TITLE] = (address[JSONKey.ADDRESS_TITLE] as! String)
                        }
                        if address[JSONKey.ADDRESS] as? String != nil {
                            
                            dictionaryAddress[JSONKey.ADDRESS] = (address[JSONKey.ADDRESS] as! String)
                        }
                        if address[JSONKey.ADDRESS_LATITUDE] as? String != nil {
                            
                            dictionaryAddress[JSONKey.ADDRESS_LATITUDE] = (address[JSONKey.ADDRESS_LATITUDE] as! String)
                        }
                        if address[JSONKey.ADDRESS_LONGITUDE] as? String != nil {
                            
                            dictionaryAddress[JSONKey.ADDRESS_LONGITUDE] = (address[JSONKey.ADDRESS_LONGITUDE] as! String)
                        }
                        if address[JSONKey.COMPANY_STREET] as? String != nil {
                            
                            dictionaryAddress[JSONKey.COMPANY_STREET] = (address[JSONKey.COMPANY_STREET] as! String)
                        }
                        if address[JSONKey.POSTAL_CODE] as? String != nil {
                            
                            dictionaryAddress[JSONKey.POSTAL_CODE] = (address[JSONKey.POSTAL_CODE] as! String)
                        }
                        if address[JSONKey.USER_PHONE] as? String != nil {
                            
                            dictionaryAddress[JSONKey.USER_PHONE] = (address[JSONKey.USER_PHONE] as! String)
                        }
                        if address[JSONKey.CITY_NAME] as? String != nil {
                            
                            dictionaryAddress[JSONKey.CITY_NAME] = (address[JSONKey.CITY_NAME] as! String)
                        }
                        dictionaryAddress[JSONKey.IS_ADDRESS_SELECTED] = ConstantStrings.UNSELECTED_VALUE
                        if !dictionaryAddress.isEmpty{
                            
                            self.arrayAddressList.append(dictionaryAddress)
                        }
                    }
                    self.buttonGotoMenu.isHidden = false
                    self.labelNoAddress.isHidden = true
                    self.tableView.reloadData()
                }else {
                    
                    if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                        
                        self.tableView.reloadData()
                        self.buttonGotoMenu.isHidden = true
                        self.labelNoAddress.isHidden = false
                        self.labelNoAddress.text = jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String
                        
                        if self.arrayAddressList.count == 0 && !self.isAddressDeleted {
                            
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
                            let addAddressVC = AddAddressViewController.init(nibName: "AddAddressViewController", bundle: nil)
                            addAddressVC.delegate = self
                            self.navigationController?.pushViewController(addAddressVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
//    Func web Api add address
    func webApiAddAddress() -> Void {
        
        MBProgressHUD.showAdded(to: self.viewAddAddress, animated: true)
        
        let url = WebApi.BASE_URL + "phpexpert_customer_add_new_address.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&user_phone=\(self.textFieldPhone.text!)&customerAddressLabel=\(self.textFieldAddressTitle.text!)&customerFloor_House_Number=\(self.textFieldHouseNumber.text!)&customerStreet=\(self.textFieldStreetName.text!)&customerCity=\(self.textFieldCity.text!)&customerZipcode=\(self.textFieldPostalCode.text!)&address_direction=&CustomerId=\(self.userDetails.userID)&customerFlat_Name=Arunalaya"
        
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.viewAddAddress, animated: true)
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
                    
                    self.button.removeFromSuperview()
                    self.viewAddAddress.removeFromSuperview()
                    self.showToastWithMessage(self.view, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }
        }else {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
                
                if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 1 {
                    
                    if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                        
                        self.button.removeFromSuperview()
                        self.viewAddAddress.removeFromSuperview()
                        self.webApiGetAllAddress()
                        self.showToastWithMessage(self.view, jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String)
                    }
                }
            }
        }
    }
    
//    Func web Api delete address
    func webApiDeleteAddress(_ addressID : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = WebApi.BASE_URL + "customer_address_delete.php?CustomerAddressId=\(addressID)"
        
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupOnSuccessDeleteAddress(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup On Success Delete Address
    func setupOnSuccessDeleteAddress(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
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
                        
                        self.isAddressDeleted = true
                        self.webApiGetAllAddress()
                        self.showToastWithMessage(self.view, jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String)
                    }
                }
            }
        }
    }
}
