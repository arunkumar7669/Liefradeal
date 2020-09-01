//
//  LanguageSettingViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 19/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class LanguageSettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex = IndexPath()
    var selectedLanguageCode = String()
    var arrayLanguageList = Array<Dictionary<String, Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        self.navigationItem.title = (self.appDelegate.languageData["LANGUAGE_SETTINGS"] as? String != nil) ? (self.appDelegate.languageData["LANGUAGE_SETTINGS"] as! String) : "Language Settings"
        self.setupBackBarButton()
        self.setupTableViewDelegateAndDatasource()
        self.webApiGetLanguageList()
    }
    
    func setupTableViewDelegateAndDatasource() -> Void {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 30.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayLanguageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("LanguageTableViewCell", owner: self, options: nil)?.first as! LanguageTableViewCell
        cell.selectionStyle = .none
        let dictionaryLanguage = self.arrayLanguageList[indexPath.row]
        if dictionaryLanguage["lang_name"] as? String != nil {
            cell.labelLanguageSelection.text = (dictionaryLanguage["lang_name"] as! String)
        }else {
            cell.labelLanguageSelection.text = ""
        }
        if dictionaryLanguage["lang_icon"] as? String != nil {
            var imageUrl = (dictionaryLanguage["lang_icon"] as! String)
            imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
            cell.imageViewCountry.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "slider"))
        }else {
            cell.imageViewCountry.image = UIImage.init(named: "")
        }
        if dictionaryLanguage["isDefaultLanguage"] as? Bool != nil {
            if (dictionaryLanguage["isDefaultLanguage"] as! Bool) {
                cell.imageViewSelection.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
            }else {
                cell.imageViewSelection.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
            }
        }else {
            cell.imageViewSelection.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedIndex != indexPath {
            self.selectedIndex = indexPath
            let selectedLanguageDetails = self.arrayLanguageList[indexPath.row]
            if selectedLanguageDetails["lang_code"] as? String != nil {
                self.selectedLanguageCode = (selectedLanguageDetails["lang_code"] as! String)
            }else {
                self.selectedLanguageCode = WebApi.LANGUAGE_CODE
            }
            self.webApiGetLanguageData()
        }
    }
    
//    MARK:- WebApi Code Start
    func webApiGetLanguageList() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_app_langauge_list.php?api_key=\(WebApi.API_KEY)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupLanguageList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    func setup language list
    func setupLanguageList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        if jsonDictionary["LanguageListList"] as? Array<Dictionary<String, Any>> != nil {
            let arrayLanguage = jsonDictionary["LanguageListList"] as! Array<Dictionary<String, Any>>
            for i in 0..<arrayLanguage.count {
                var dictionaryLanguage = arrayLanguage[i]
                var isDefaultLanguage = Bool()
                if dictionaryLanguage["lang_code"] as? String != nil {
                    if WebApi.LANGUAGE_CODE == (dictionaryLanguage["lang_code"] as! String) {
                        isDefaultLanguage = true
                        self.selectedIndex = IndexPath.init(row: i, section: 0)
                    }else {
                        isDefaultLanguage = false
                    }
                }else {
                    isDefaultLanguage = false
                }
                dictionaryLanguage["isDefaultLanguage"] = isDefaultLanguage
                self.arrayLanguageList.append(dictionaryLanguage)
            }
            self.tableView.reloadData()
        }
    }
    
//    MARK:- WebApi Code Start
//    Api for get Multi Language Data
    func webApiGetLanguageData() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_app_langauge.php?lang_code=\(self.selectedLanguageCode)&api_key=\(WebApi.API_KEY)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupLanguageJson(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupLanguageJson(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        if !jsonDictionary.isEmpty {
            UserDefaultOperations.setDictionaryObject(ConstantStrings.MULTI_LANGUAGE_JSON_DATA, jsonDictionary)
            self.appDelegate.languageData = jsonDictionary
            self.navigationItem.title = (jsonDictionary["LANGUAGE_SETTINGS"] as? String != nil) ? (jsonDictionary["LANGUAGE_SETTINGS"] as! String) : "Language Settings"
            ConstantStrings.ALERT = (jsonDictionary["AlertText"] as? String != nil) ? (jsonDictionary["AlertText"] as! String) : ConstantStrings.ALERT
            ConstantStrings.INVALID = (jsonDictionary["InvalidText"] as? String != nil) ? (jsonDictionary["InvalidText"] as! String) : ConstantStrings.INVALID
            ConstantStrings.NETORK_ISSUE = (jsonDictionary["Network_Issue"] as? String != nil) ? (jsonDictionary["Network_Issue"] as! String) : ConstantStrings.NETORK_ISSUE
            ConstantStrings.ITEMS = (jsonDictionary["items"] as? String != nil) ? (jsonDictionary["items"] as! String) : ConstantStrings.ITEMS
            
            ConstantStrings.DATA_IS_NOT_AVAILABLE = (jsonDictionary["DATA_IS_NOT_AVAILABLE"] as? String != nil) ? (jsonDictionary["DATA_IS_NOT_AVAILABLE"] as! String) : ConstantStrings.DATA_IS_NOT_AVAILABLE
            ConstantStrings.FIRST_NAME_FIELD_IS_REQUIRED = (jsonDictionary["FIRST_NAME_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["FIRST_NAME_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.FIRST_NAME_FIELD_IS_REQUIRED
            ConstantStrings.USERNAME_FIELD_IS_REQUIRED = (jsonDictionary["USERNAME_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["USERNAME_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.USERNAME_FIELD_IS_REQUIRED
            ConstantStrings.PASSWORD_FIELD_IS_REQUIRED = (jsonDictionary["PASSWORD_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["PASSWORD_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.PASSWORD_FIELD_IS_REQUIRED
            ConstantStrings.MOBILE_NO_FIELD_IS_REQUIRED = (jsonDictionary["MOBILE_NO_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["MOBILE_NO_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.MOBILE_NO_FIELD_IS_REQUIRED
            ConstantStrings.MESSAGE_FIELD_IS_REQUIRED = (jsonDictionary["MESSAGE_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["MESSAGE_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.MESSAGE_FIELD_IS_REQUIRED
            ConstantStrings.EMAIL_FIELD_IS_REQUIRED = (jsonDictionary["EMAIL_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["EMAIL_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.EMAIL_FIELD_IS_REQUIRED
            ConstantStrings.PLEASE_ENTER_VALID_MOBILE = (jsonDictionary["PLEASE_ENTER_VALID_MOBILE"] as? String != nil) ? (jsonDictionary["PLEASE_ENTER_VALID_MOBILE"] as! String) : ConstantStrings.PLEASE_ENTER_VALID_MOBILE
            ConstantStrings.PLEASE_ENTER_VALID_EMAIL = (jsonDictionary["PLEASE_ENTER_VALID_EMAIL"] as? String != nil) ? (jsonDictionary["PLEASE_ENTER_VALID_EMAIL"] as! String) : ConstantStrings.PLEASE_ENTER_VALID_EMAIL
            ConstantStrings.ADDRESS_FIELD_IS_REQUIRED = (jsonDictionary["ADDRESS_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["ADDRESS_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.ADDRESS_FIELD_IS_REQUIRED
            ConstantStrings.DEVICE_DOES_NOT_SUPPORT_CAMERA = (jsonDictionary["DEVICE_DOES_NOT_SUPPORT_CAMERA"] as? String != nil) ? (jsonDictionary["DEVICE_DOES_NOT_SUPPORT_CAMERA"] as! String) : ConstantStrings.DEVICE_DOES_NOT_SUPPORT_CAMERA
            ConstantStrings.COULD_NOT_CONNECT_TO_SERVER = (jsonDictionary["COULD_NOT_CONNECT_TO_SERVER"] as? String != nil) ? (jsonDictionary["COULD_NOT_CONNECT_TO_SERVER"] as! String) : ConstantStrings.COULD_NOT_CONNECT_TO_SERVER
            ConstantStrings.FIRSTLY_PLEASE_ADD_INTO_CART = (jsonDictionary["FIRSTLY_PLEASE_ADD_INTO_CART"] as? String != nil) ? (jsonDictionary["FIRSTLY_PLEASE_ADD_INTO_CART"] as! String) : ConstantStrings.FIRSTLY_PLEASE_ADD_INTO_CART
            ConstantStrings.ITEM_HAS_BEEN_ADDED_INTO_CART = (jsonDictionary["ITEM_HAS_BEEN_ADDED_INTO_CART"] as? String != nil) ? (jsonDictionary["ITEM_HAS_BEEN_ADDED_INTO_CART"] as! String) : ConstantStrings.ITEM_HAS_BEEN_ADDED_INTO_CART
            ConstantStrings.SUCCESSFULLY_LOGGED_IN = (jsonDictionary["SUCCESSFULLY_LOGGED_IN"] as? String != nil) ? (jsonDictionary["SUCCESSFULLY_LOGGED_IN"] as! String) : ConstantStrings.SUCCESSFULLY_LOGGED_IN
            ConstantStrings.ADDRESS_TITLE_FIELD_IS_REQUIRED = (jsonDictionary["ADDRESS_TITLE_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["ADDRESS_TITLE_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.ADDRESS_TITLE_FIELD_IS_REQUIRED
            ConstantStrings.POSTAL_CODE_FIELD_IS_REQUIRED = (jsonDictionary["POSTAL_CODE_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["POSTAL_CODE_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.POSTAL_CODE_FIELD_IS_REQUIRED
            ConstantStrings.CITY_NAME_FIELD_IS_REQUIRED = (jsonDictionary["CITY_NAME_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["CITY_NAME_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.CITY_NAME_FIELD_IS_REQUIRED
            ConstantStrings.PLEASE_ENTER_VALID_POSTAL_CODE = (jsonDictionary["PLEASE_ENTER_VALID_POSTAL_CODE"] as? String != nil) ? (jsonDictionary["PLEASE_ENTER_VALID_POSTAL_CODE"] as! String) : ConstantStrings.PLEASE_ENTER_VALID_POSTAL_CODE
            ConstantStrings.PLEASE_SELECT_ORDER_TYPE = (jsonDictionary["PLEASE_SELECT_ORDER_TYPE"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_ORDER_TYPE"] as! String) : ConstantStrings.PLEASE_SELECT_ORDER_TYPE
            ConstantStrings.APPLY_COUPON_IS_REQUIRED = (jsonDictionary["APPLY_COUPON_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["APPLY_COUPON_IS_REQUIRED"] as! String) : ConstantStrings.APPLY_COUPON_IS_REQUIRED
            ConstantStrings.YOUR_COUPON_HAS_BEEN_APPLIED_SUCCESSFULLY = (jsonDictionary["YOUR_COUPON_HAS_BEEN_APPLIED_SUCCESSFULLY"] as? String != nil) ? (jsonDictionary["YOUR_COUPON_HAS_BEEN_APPLIED_SUCCESSFULLY"] as! String) : ConstantStrings.YOUR_COUPON_HAS_BEEN_APPLIED_SUCCESSFULLY
            ConstantStrings.PLEASE_SELECT_ADDRESS = (jsonDictionary["PLEASE_SELECT_ADDRESS"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_ADDRESS"] as! String) : ConstantStrings.PLEASE_SELECT_ADDRESS
            ConstantStrings.PLEASE_SELECT_PAYMENT_MODE = (jsonDictionary["PLEASE_SELECT_PAYMENT_MODE"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_PAYMENT_MODE"] as! String) : ConstantStrings.PLEASE_SELECT_PAYMENT_MODE
            ConstantStrings.YOUR_CART_IS_EMPTY = (jsonDictionary["YOUR_CART_IS_EMPTY"] as? String != nil) ? (jsonDictionary["YOUR_CART_IS_EMPTY"] as! String) : ConstantStrings.YOUR_CART_IS_EMPTY
            ConstantStrings.NO_ORDER_YET = (jsonDictionary["NO_ORDER_YET"] as? String != nil) ? (jsonDictionary["NO_ORDER_YET"] as! String) : ConstantStrings.NO_ORDER_YET
            ConstantStrings.HOME_NUMBER_IS_REQUIRED = (jsonDictionary["HOME_NUMBER_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["HOME_NUMBER_IS_REQUIRED"] as! String) : ConstantStrings.HOME_NUMBER_IS_REQUIRED
            ConstantStrings.STREET_NAME_IS_REQUIRED = (jsonDictionary["STREET_NAME_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["STREET_NAME_IS_REQUIRED"] as! String) : ConstantStrings.STREET_NAME_IS_REQUIRED
            ConstantStrings.PLEASE_ENTER_VALID_POSTAL_CODE = (jsonDictionary["PLEASE_ENTER_VALID_POSTAL_CODE"] as? String != nil) ? (jsonDictionary["PLEASE_ENTER_VALID_POSTAL_CODE"] as! String) : ConstantStrings.PLEASE_ENTER_VALID_POSTAL_CODE
            ConstantStrings.PLEASE_LOGIN_FIRSTLY = (jsonDictionary["PLEASE_LOGIN_FIRSTLY"] as? String != nil) ? (jsonDictionary["PLEASE_LOGIN_FIRSTLY"] as! String) : ConstantStrings.PLEASE_LOGIN_FIRSTLY
            ConstantStrings.FLAT_NAME_IS_REQUIRED = (jsonDictionary["FLAT_NAME_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["FLAT_NAME_IS_REQUIRED"] as! String) : ConstantStrings.FLAT_NAME_IS_REQUIRED
            ConstantStrings.WRITE_REVIEW_IS_REQUIRED = (jsonDictionary["WRITE_REVIEW_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["WRITE_REVIEW_IS_REQUIRED"] as! String) : ConstantStrings.WRITE_REVIEW_IS_REQUIRED
            ConstantStrings.RATING_REVIEW_COULD_NOT_SUBMITTED = (jsonDictionary["RATING_REVIEW_COULD_NOT_SUBMITTED"] as? String != nil) ? (jsonDictionary["RATING_REVIEW_COULD_NOT_SUBMITTED"] as! String) : ConstantStrings.RATING_REVIEW_COULD_NOT_SUBMITTED
            ConstantStrings.OLD_PASSWORD_IS_REQUIRED = (jsonDictionary["OLD_PASSWORD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["OLD_PASSWORD_IS_REQUIRED"] as! String) : ConstantStrings.OLD_PASSWORD_IS_REQUIRED
            ConstantStrings.NEW_PASSWORD_IS_REQUIRED = (jsonDictionary["NEW_PASSWORD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["NEW_PASSWORD_IS_REQUIRED"] as! String) : ConstantStrings.NEW_PASSWORD_IS_REQUIRED
            ConstantStrings.RE_TYPE_PASSWORD_IS_REQUIRED = (jsonDictionary["RE_TYPE_PASSWORD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["RE_TYPE_PASSWORD_IS_REQUIRED"] as! String) : ConstantStrings.RE_TYPE_PASSWORD_IS_REQUIRED
            ConstantStrings.BOTH_PASSWORD_SHOULD_BE_SAME = (jsonDictionary["BOTH_PASSWORD_SHOULD_BE_SAME"] as? String != nil) ? (jsonDictionary["BOTH_PASSWORD_SHOULD_BE_SAME"] as! String) : ConstantStrings.BOTH_PASSWORD_SHOULD_BE_SAME
            ConstantStrings.YOU_HAVE_ZERO_LOYALTY_POINTS = (jsonDictionary["YOU_HAVE_ZERO_LOYALTY_POINTS"] as? String != nil) ? (jsonDictionary["YOU_HAVE_ZERO_LOYALTY_POINTS"] as! String) : ConstantStrings.YOU_HAVE_ZERO_LOYALTY_POINTS
            ConstantStrings.ARE_YOU_SURE_YOU_WANT_TO_LOGOUT = (jsonDictionary["ARE_YOU_SURE_YOU_WANT_TO_LOGOUT"] as? String != nil) ? (jsonDictionary["ARE_YOU_SURE_YOU_WANT_TO_LOGOUT"] as! String) : ConstantStrings.ARE_YOU_SURE_YOU_WANT_TO_LOGOUT
            ConstantStrings.PLEASE_CHOOSE_ONE_OPTION = (jsonDictionary["PLEASE_CHOOSE_ONE_OPTION"] as? String != nil) ? (jsonDictionary["PLEASE_CHOOSE_ONE_OPTION"] as! String) : ConstantStrings.PLEASE_CHOOSE_ONE_OPTION
            ConstantStrings.YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE = (jsonDictionary["PLEASE_LOGIN_FIRSTLY"] as? String != nil) ? (jsonDictionary["PLEASE_LOGIN_FIRSTLY"] as! String) : ConstantStrings.YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE
            ConstantStrings.LOYALTY_POINT_FIELD_IS_REQUIRED = (jsonDictionary["Enter_your_loyalty_points"] as? String != nil) ? (jsonDictionary["Enter_your_loyalty_points"] as! String) : ConstantStrings.LOYALTY_POINT_FIELD_IS_REQUIRED
            ConstantStrings.PLEASE_SELECT_PAYMENT_MODE = (jsonDictionary["PLEASE_SELECT_PAYMENT_MODE"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_PAYMENT_MODE"] as! String) : ConstantStrings.PLEASE_SELECT_PAYMENT_MODE
            ConstantStrings.GO_TO_MENU = (jsonDictionary["Go_to_Menu"] as? String != nil) ? (jsonDictionary["Go_to_Menu"] as! String) : ConstantStrings.GO_TO_MENU
            ConstantStrings.CONFIRM_DELIVERY_ADDRESS = (jsonDictionary["Confirm_Delivery_Address"] as? String != nil) ? (jsonDictionary["Confirm_Delivery_Address"] as! String) : ConstantStrings.CONFIRM_DELIVERY_ADDRESS
            ConstantStrings.CONFIRM_AND_PAY = (jsonDictionary["Confirm_and_Pay"] as? String != nil) ? (jsonDictionary["Confirm_and_Pay"] as! String) : ConstantStrings.CONFIRM_AND_PAY
            ConstantStrings.WRITE_A_REVIEW = (jsonDictionary["write_a_review"] as? String != nil) ? (jsonDictionary["write_a_review"] as! String) : ConstantStrings.WRITE_A_REVIEW
            ConstantStrings.CONTINUE_ORDER = (jsonDictionary["continue_order"] as? String != nil) ? (jsonDictionary["continue_order"] as! String) : ConstantStrings.CONTINUE_ORDER
            ConstantStrings.YOU_ARE_NOT_AVAILABLE_AT_ANY_BRANCH = (jsonDictionary["sorry_you_are_not_available_Text"] as? String != nil) ? (jsonDictionary["sorry_you_are_not_available_Text"] as! String) : ConstantStrings.YOU_ARE_NOT_AVAILABLE_AT_ANY_BRANCH
            ConstantStrings.CONTINUE_ORDER = (jsonDictionary["continue_order"] as? String != nil) ? (jsonDictionary["continue_order"] as! String) : ConstantStrings.CONTINUE_ORDER
            
            ConstantStrings.YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE = (jsonDictionary["YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE"] as? String != nil) ? (jsonDictionary["YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE"] as! String) : ConstantStrings.YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE
            ConstantStrings.NO_CORDINATES_AVAILABLE = (jsonDictionary["NO_CORDINATES_AVAILABLE"] as? String != nil) ? (jsonDictionary["NO_CORDINATES_AVAILABLE"] as! String) : ConstantStrings.NO_CORDINATES_AVAILABLE
            ConstantStrings.NO_PICTURE_UPLOADED_YET = (jsonDictionary["NO_PICTURE_UPLOADED_YET"] as? String != nil) ? (jsonDictionary["NO_PICTURE_UPLOADED_YET"] as! String) : ConstantStrings.NO_PICTURE_UPLOADED_YET
            ConstantStrings.NO_OFFER_AVAILABLE = (jsonDictionary["NO_OFFER_AVAILABLE"] as? String != nil) ? (jsonDictionary["NO_OFFER_AVAILABLE"] as! String) : ConstantStrings.NO_OFFER_AVAILABLE
            ConstantStrings.PLEASE_ENTER_MORE_THAN_POINTS = (jsonDictionary["PLEASE_ENTER_MORE_THAN_POINTS"] as? String != nil) ? (jsonDictionary["PLEASE_ENTER_MORE_THAN_POINTS"] as! String) : ConstantStrings.PLEASE_ENTER_MORE_THAN_POINTS
            ConstantStrings.YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS = (jsonDictionary["YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS"] as? String != nil) ? (jsonDictionary["YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS"] as! String) : ConstantStrings.YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS
            ConstantStrings.YOUR_ORDER_COULD_NOT_PLACED = (jsonDictionary["YOUR_ORDER_COULD_NOT_PLACED"] as? String != nil) ? (jsonDictionary["YOUR_ORDER_COULD_NOT_PLACED"] as! String) : ConstantStrings.YOUR_ORDER_COULD_NOT_PLACED
            ConstantStrings.PHONE_NUMBER = (jsonDictionary["Mobile_Number"] as? String != nil) ? (jsonDictionary["Mobile_Number"] as! String) : "Mobile Number"
            ConstantStrings.PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING = (jsonDictionary["PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING"] as? String != nil) ? (jsonDictionary["PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING"] as! String) : ConstantStrings.PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING
            ConstantStrings.NEW_ITEM_ADDED = (jsonDictionary["NEW_ITEM_ADDED"] as? String != nil) ? (jsonDictionary["NEW_ITEM_ADDED"] as! String) : ConstantStrings.NEW_ITEM_ADDED
            ConstantStrings.SEND_ORDER_TO_KITCHEN = (jsonDictionary["SEND_ORDER_TO_KITCHEN"] as? String != nil) ? (jsonDictionary["SEND_ORDER_TO_KITCHEN"] as! String) : ConstantStrings.SEND_ORDER_TO_KITCHEN
            ConstantStrings.YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW = (jsonDictionary["YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW"] as? String != nil) ? (jsonDictionary["YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW"] as! String) : ConstantStrings.YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW
            ConstantStrings.YOUR_LANGUAGE_HAS_BEEN_CHANGED = (jsonDictionary["YOUR_LANGUAGE_HAS_BEEN_CHANGED"] as? String != nil) ? (jsonDictionary["YOUR_LANGUAGE_HAS_BEEN_CHANGED"] as! String) : ConstantStrings.YOUR_LANGUAGE_HAS_BEEN_CHANGED
            ConstantStrings.PLEASE_SELECT_OPTION = (jsonDictionary["PLEASE_SELECT_OPTION"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_OPTION"] as! String) : ConstantStrings.PLEASE_SELECT_OPTION
            
            ConstantStrings.ORDER_TYPE_DELIVERY_STRING = (jsonDictionary["Delivery"] as? String != nil) ? (jsonDictionary["Delivery"] as! String) : ConstantStrings.ORDER_TYPE_DELIVERY_STRING
            ConstantStrings.ORDER_TYPE_PICKUP_STRING = (jsonDictionary["Pickup"] as? String != nil) ? (jsonDictionary["Pickup"] as! String) : ConstantStrings.ORDER_TYPE_PICKUP_STRING
            ConstantStrings.ORDER_TYPE_DINING_STRING = (jsonDictionary["EAT_IN"] as? String != nil) ? (jsonDictionary["EAT_IN"] as! String) : ConstantStrings.ORDER_TYPE_DINING_STRING
            ConstantStrings.ORDER_STATUS_CANCELLED = (jsonDictionary["Cancelled"] as? String != nil) ? (jsonDictionary["Cancelled"] as! String) : ConstantStrings.ORDER_STATUS_CANCELLED
            ConstantStrings.PLEASE_SELECT_RESTAURANT_BRANCH = (jsonDictionary["PLEASE_SELECT_RESTAURANT_BRANCH"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_RESTAURANT_BRANCH"] as! String) : ConstantStrings.PLEASE_SELECT_RESTAURANT_BRANCH
            ConstantStrings.CUSTOMER_NAME_IS_REQUIRED = (jsonDictionary["please_enter_customer_name"] as? String != nil) ? (jsonDictionary["please_enter_customer_name"] as! String) : ConstantStrings.CUSTOMER_NAME_IS_REQUIRED
            ConstantStrings.CUSTOMER_MOBILE_NUMBER_IS_REQUIRED = (jsonDictionary["please_enter_customer_mobile"] as? String != nil) ? (jsonDictionary["please_enter_customer_mobile"] as! String) : ConstantStrings.CUSTOMER_MOBILE_NUMBER_IS_REQUIRED
            ConstantStrings.BOOKING_TIME_IS_REQUIRED = (jsonDictionary["please_enter_booking_time"] as? String != nil) ? (jsonDictionary["please_enter_booking_time"] as! String) : ConstantStrings.BOOKING_TIME_IS_REQUIRED
            ConstantStrings.BOOKING_DATE_IS_REQUIRED = (jsonDictionary["please_enter_booting_date"] as? String != nil) ? (jsonDictionary["please_enter_booting_date"] as! String) : ConstantStrings.BOOKING_DATE_IS_REQUIRED
            ConstantStrings.PLEASE_SELECT_TABLE_NUMBER = (jsonDictionary["please_select_table"] as? String != nil) ? (jsonDictionary["please_select_table"] as! String) : ConstantStrings.PLEASE_SELECT_TABLE_NUMBER
            ConstantStrings.YOUR_ORDER_COUNT_NOT_CANCEL = (jsonDictionary["YOUR_ORDER_COUNT_NOT_CANCEL"] as? String != nil) ? (jsonDictionary["YOUR_ORDER_COUNT_NOT_CANCEL"] as! String) : ConstantStrings.YOUR_ORDER_COUNT_NOT_CANCEL
            ConstantStrings.WE_COULD_NOT_TRACK_ORDER = (jsonDictionary["WE_COULD_NOT_TRACK_ORDER"] as? String != nil) ? (jsonDictionary["WE_COULD_NOT_TRACK_ORDER"] as! String) : ConstantStrings.WE_COULD_NOT_TRACK_ORDER
            ConstantStrings.NO_ANY_COMPLAINT = (jsonDictionary["NO_ANY_COMPLAINT"] as? String != nil) ? (jsonDictionary["NO_ANY_COMPLAINT"] as! String) : ConstantStrings.NO_ANY_COMPLAINT
            ConstantStrings.SIZE_NOT_AVAILABLE = (jsonDictionary["SIZE_NOT_AVAILABLE"] as? String != nil) ? (jsonDictionary["SIZE_NOT_AVAILABLE"] as! String) : ConstantStrings.SIZE_NOT_AVAILABLE
            ConstantStrings.ORDER_SENT_TO_THE_KITCHEN = (jsonDictionary["Your_order_has_been_sent_to_kitchen_successfully"] as? String != nil) ? (jsonDictionary["Your_order_has_been_sent_to_kitchen_successfully"] as! String) : ConstantStrings.ORDER_SENT_TO_THE_KITCHEN
            ConstantStrings.CANCEL_STRING = (jsonDictionary["Cancel"] as? String != nil) ? (jsonDictionary["Cancel"] as! String) : ConstantStrings.CANCEL_STRING
            ConstantStrings.OK_STRING = (jsonDictionary["Ok"] as? String != nil) ? (jsonDictionary["Ok"] as! String) : ConstantStrings.OK_STRING
            ConstantStrings.YOUR_PROFILE_COULD_NOT_UPDATED = (jsonDictionary["YOUR_PROFILE_COULD_NOT_UPDATED"] as? String != nil) ? (jsonDictionary["YOUR_PROFILE_COULD_NOT_UPDATED"] as! String) : ConstantStrings.YOUR_PROFILE_COULD_NOT_UPDATED
            
            for i in 0..<self.arrayLanguageList.count {
                var dictionaryLanguage = self.arrayLanguageList[i]
                dictionaryLanguage["isDefaultLanguage"] = false
                self.arrayLanguageList[i] = dictionaryLanguage
            }
            var selectedLanguageDetails = self.arrayLanguageList[self.selectedIndex.row]
            selectedLanguageDetails["isDefaultLanguage"] = true
            self.arrayLanguageList[self.selectedIndex.row] = selectedLanguageDetails
            WebApi.LANGUAGE_CODE = self.selectedLanguageCode
            self.tableView.reloadData()
            self.showToastWithMessage(self.view, ConstantStrings.YOUR_LANGUAGE_HAS_BEEN_CHANGED)
        }
    }
}
