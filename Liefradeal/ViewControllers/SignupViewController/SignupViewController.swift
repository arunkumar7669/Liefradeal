//
//  SignupViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import RPFloatingPlaceholders

protocol MovedFromCartPageDelegate : class {
    
    func setupMovedFromCartDelegate(_ isMovedFromCart : Bool)
}

class SignupViewController: BaseViewController {

//    @IBOutlet weak var labelLoginTitle: UILabel!
//    @IBOutlet weak var labelSignupTitle: UILabel!
//    @IBOutlet weak var viewLogin: UIView!
//    @IBOutlet weak var viewSignup: UIView!
    
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var textFieldUesrName: RPFloatingPlaceholderTextField!
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var textFieldEmail: RPFloatingPlaceholderTextField!
    
    @IBOutlet weak var viewPhoneNo: UIView!
    @IBOutlet weak var textFieldPhoneNo: RPFloatingPlaceholderTextField!
    
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var textFieldPassword: RPFloatingPlaceholderTextField!
    
    @IBOutlet weak var buttonSignup: UIButton!
//    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var imageViewUsername: UIImageView!
    @IBOutlet weak var imageViewPhone: UIImageView!
    
    var isMovedFromOptionPage = Bool()
    var isMoveFromLoginPage = Bool()
    var deviceID = String()
    var isMoveFromMenuOrCart = Bool()
    var locationInfo = UserLocationInfo()
    weak var delegate : MovedFromCartPageDelegate?
    var restaurantInfo = RestaurantInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["SIGN_UP"] as? String != nil) ? (self.appDelegate.languageData["SIGN_UP"] as! String).trim() : "Sign Up"
        self.textFieldUesrName.placeholder = (self.appDelegate.languageData["Full_Name"] as? String != nil) ? (self.appDelegate.languageData["Full_Name"] as! String).trim() : "Full Name"
        self.textFieldPhoneNo.placeholder = (self.appDelegate.languageData["Mobile_No"] as? String != nil) ? (self.appDelegate.languageData["Mobile_No"] as! String).trim() : "Mobile Number"
        self.textFieldEmail.placeholder = (self.appDelegate.languageData["Enter_your_email"] as? String != nil) ? (self.appDelegate.languageData["Enter_your_email"] as! String).trim() : "Enter your email address"
        self.textFieldPassword.placeholder = (self.appDelegate.languageData["Password"] as? String != nil) ? (self.appDelegate.languageData["Password"] as! String).trim() : "Password"
        let buttonSignUpTitle = (self.appDelegate.languageData["SIGN_UP"] as? String != nil) ? (self.appDelegate.languageData["SIGN_UP"] as! String).trim() : "Sign Up"
        self.buttonSignup.setTitle(buttonSignUpTitle, for: .normal)
        
        self.setupBackBarButton()
        self.viewUserName.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewEmail.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewPhoneNo.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewPassword.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewUserName.layer.cornerRadius = 5.0
        self.viewEmail.layer.cornerRadius = 5.0
        self.viewPhoneNo.layer.cornerRadius = 5.0
        self.viewPassword.layer.cornerRadius = 5.0
        UtilityMethods.changeImageColor(self.imageViewUsername, Colors.colorWithHexString(Colors.APP_COLOR))
        UtilityMethods.changeImageColor(self.imageViewPhone, Colors.colorWithHexString(Colors.APP_COLOR))
        
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.deviceID = UIDevice.current.identifierForVendor!.uuidString
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) != nil {
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        
//        self.imageViewLogo.sd_setImage(with: URL(string: self.restaurantInfo.logoImageUrl), placeholderImage: UIImage(named: ""))
        UtilityMethods.addBorderAndShadow(self.buttonSignup, 5.0)
        self.buttonSignup.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_LOCATION_INFO) != nil {
            self.locationInfo = UserDefaultOperations.getStoredObject(ConstantStrings.USER_LOCATION_INFO) as! UserLocationInfo
        }
    }
    
    //    MARK:- Button Action
    @IBAction func buttonLoginPageAction(_ sender: UIButton) {
        
        if self.isMoveFromLoginPage {
            
            self.navigationController?.popViewController(animated: false)
        }else {
            
            let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
            loginVC.isMoveFromSignupPage = true
            loginVC.isMoveFromMenuOrCart = self.isMoveFromMenuOrCart
            self.navigationController?.pushViewController(loginVC, animated: false)
        }
    }
    
//    Button Signup Action
    @IBAction func buttonSignupAction(_ sender: UIButton) {
        
        if self.checkValidation() {
            
            self.webApiSignupNewUser()
        }
    }
    
//    Button Skip Login/signup and move in as guest user Action
    @IBAction func buttonSkipAction(_ sender: UIButton) {
        
        UserDefaultOperations.setBoolObject(ConstantStrings.IS_GUEST_USER, true)
        UserDefaultOperations.setBoolObject(ConstantStrings.IS_USER_LOGGED_IN, false)
        self.setupDrawerController()
    }
    
//    Check validation
    func checkValidation() -> Bool {
        
        self.view.endEditing(true)
        if self.textFieldUesrName.text!.isEmpty {
            
            self.textFieldUesrName.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.USERNAME_FIELD_IS_REQUIRED)
            return false
        }
        
        if self.textFieldEmail.text!.isEmpty {
            
            self.textFieldEmail.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.EMAIL_FIELD_IS_REQUIRED)
            return false
        }
        
        if !RegularExpression.validateEmail(self.textFieldEmail.text!) {
            
            self.textFieldEmail.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PLEASE_ENTER_VALID_EMAIL)
            return false
        }
        
        if self.textFieldPhoneNo.text!.isEmpty {
            
            self.textFieldPhoneNo.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.MOBILE_NO_FIELD_IS_REQUIRED)
            return false
        }
        
        if self.textFieldPhoneNo.text!.count > 14 {
            
            self.textFieldPhoneNo.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PLEASE_ENTER_VALID_MOBILE)
            return false
        }
        
        if self.textFieldPassword.text!.isEmpty {
            
            self.textFieldPassword.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PASSWORD_FIELD_IS_REQUIRED)
            return false
        }
        
        return true
    }
    
    //    MARK:- Web Api Code
//    Web Api for get language code
    func webApiSignupNewUser() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var arrayName = self.textFieldUesrName.text!.split(separator: " ")
        var firstName = String()
        var lastName = String()
        if arrayName.count > 0 {
            
            firstName = String(arrayName[0])
            arrayName.remove(at: 0)
        }
        if arrayName.count > 0 {
            
            lastName = arrayName.joined(separator: " ")
        }
        
        if lastName.isEmpty {
            
            lastName = " "
        }
        
        let url = WebApi.BASE_URL + "phpexpert_customer_account_register.php?first_name=\(firstName)&last_name=\(lastName)&user_email=\(self.textFieldEmail.text!)&user_pass=\(self.textFieldPassword.text!)&device_id=\(self.deviceID)&customer_country=\(locationInfo.countryName)&device_platform=\(ConstantStrings.DEVICE_VERSION)&referral_code&user_phone=\(self.textFieldPhoneNo.text!)&api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        WebApi.webApiForGetRequest(updatedUrl) { (json : JSON) in

//            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {

                MBProgressHUD.hide(for: self.view, animated: true)
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{

                if json[JSONKey.ERROR_CODE] == true {

                    MBProgressHUD.hide(for: self.view, animated: true)
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
            
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int == 1 {
                
                if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
                    
                    if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 1 {
                        
                        if jsonDictionary[JSONKey.CUSTOMER_ID] as? String != nil {
                            
                            let userID = jsonDictionary[JSONKey.CUSTOMER_ID] as! String
                            
                            if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                                
                                isFirstTimeOnHomePage = true
                                if !self.isMoveFromMenuOrCart {
                                    
                                    firstMessage = jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String
                                }
                            }
                            self.webApiGetUserDetails(userID)
                        }
                    }else {
                        
                        if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.showAlertWithMessage(ConstantStrings.ALERT, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                        }
                    }
                }
            }else {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showAlertWithMessage(ConstantStrings.ALERT, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }
        }
    }
    
    func webApiGetUserDetails(_ userID : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_profile_inform.php?CustomerId=\(userID)"
        
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        WebApi.webApiForGetRequest(updatedUrl) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupExistingUserDetails(json.dictionaryObject!)
                }
            }
        }
    }
    
    //    func for setup user details
    func setupExistingUserDetails(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int != 0 {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }
        }else {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
                
                if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 0 {
                    
                    if jsonDictionary[JSONKey.CUSTOMER_ID] as? String != nil {
                        
                        let userID = jsonDictionary[JSONKey.CUSTOMER_ID] as! String
                        var userName = String()
                        var userEmail = String()
                        var userPhone = String()
                        var userAddress = String()
                        var userFirstName = String()
                        var userLastName = String()
                        var userPostalCode = String()
                        var userPhotoUrl = String()
                        var userFlatName = String()
                        var userStreetName = String()
                        var userHouseNumber = String()
                        var userCityName = String()
                        var referralString = String()
                        var referralCode = String()
                        var referralCodeMessage = String()
                        var referralCodeShareFriend = String()
                        
                        if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                            
                            isFirstTimeOnHomePage = true
                            firstMessage = ConstantStrings.SUCCESSFULLY_LOGGED_IN
                        }
                        
                        if jsonDictionary[JSONKey.USER_NAME] as? String != nil {
                            
                            userName = jsonDictionary[JSONKey.USER_NAME] as! String
                        }
                        if jsonDictionary[JSONKey.USER_EMAIL] as? String != nil {
                            
                            userEmail = jsonDictionary[JSONKey.USER_EMAIL] as! String
                        }
                        if jsonDictionary[JSONKey.USER_PHONE] as? String != nil {
                            
                            userPhone = jsonDictionary[JSONKey.USER_PHONE] as! String
                        }
                        if jsonDictionary[JSONKey.USER_PROFILE_ADDRESS] as? String != nil {
                            
                            userAddress = jsonDictionary[JSONKey.USER_PROFILE_ADDRESS] as! String
                        }
                        if jsonDictionary[JSONKey.USER_POSTALCODE] as? String != nil {
                            
                            userPostalCode = jsonDictionary[JSONKey.USER_POSTALCODE] as! String
                        }
                        if jsonDictionary[JSONKey.USER_FIRST_NAME] as? String != nil {
                            
                            userFirstName = jsonDictionary[JSONKey.USER_FIRST_NAME] as! String
                        }
                        if jsonDictionary[JSONKey.USER_LAST_NAME] as? String != nil {
                            
                            userLastName = jsonDictionary[JSONKey.USER_LAST_NAME] as! String
                        }
                        if jsonDictionary[JSONKey.USER_PHOTO_URL] as? String != nil {
                            
                            userPhotoUrl = jsonDictionary[JSONKey.USER_PHOTO_URL] as! String
                            userPhotoUrl = userPhotoUrl.replacingOccurrences(of: " ", with: "%20")
                        }
                        if jsonDictionary[JSONKey.USER_FLAT_NAME] as? String != nil {
                            
                            userFlatName = jsonDictionary[JSONKey.USER_FLAT_NAME] as! String
                        }
                        if jsonDictionary[JSONKey.USER_STREET_NAME] as? String != nil {
                            
                            userStreetName = jsonDictionary[JSONKey.USER_STREET_NAME] as! String
                        }
                        if jsonDictionary[JSONKey.USER_HOUSE_NUMBER] as? String != nil {
                            
                            userHouseNumber = jsonDictionary[JSONKey.USER_HOUSE_NUMBER] as! String
                        }
                        if jsonDictionary[JSONKey.USER_CITY_NAME] as? String != nil {
                            
                            userCityName = jsonDictionary[JSONKey.USER_CITY_NAME] as! String
                        }
                        
                        referralCode = (jsonDictionary["referral_code"] as? String != nil) ? (jsonDictionary["referral_code"] as! String) : "0"
                        referralString = (jsonDictionary["referral_sharing_Message"] as? String != nil) ? (jsonDictionary["referral_sharing_Message"] as! String) : ""
                        referralCodeMessage = (jsonDictionary["referral_codeMessage"] as? String != nil) ? (jsonDictionary["referral_codeMessage"] as! String) : "0"
                        referralCodeShareFriend = (jsonDictionary["referral_join_friends"] as? String != nil) ? (jsonDictionary["referral_join_friends"] as! String) : "0"
                        UserDefaultOperations.setStringObject(ConstantStrings.REFERRAL_CODE, referralCode)
                        UserDefaultOperations.setStringObject(ConstantStrings.REFERRAL_STRING, referralString)
                        UserDefaultOperations.setStringObject(ConstantStrings.REFERRAL_CODE_MESSAGE, referralCodeMessage)
                        UserDefaultOperations.setStringObject(ConstantStrings.REFERRAL_CODE_SHARE_FRIEND, referralCodeShareFriend)
                        
                        let userInfo = UserDetails.init(userID: userID, userName: userName, userEmail: userEmail, userPhone: userPhone, userAddress: userAddress, postalCode: userPostalCode, userPhotoUrl: userPhotoUrl, userFirstName: userFirstName, userLastName: userLastName, userFlatName: userFlatName, userStreetName: userStreetName, userHouseNumber: userHouseNumber, userCityName: userCityName)
                        UserDefaultOperations.setStoredObject(ConstantStrings.USER_DETAILS, userInfo)
                        UserDefaultOperations.setBoolObject(ConstantStrings.IS_USER_LOGGED_IN, true)
                        UserDefaultOperations.setBoolObject(ConstantStrings.IS_GUEST_USER, false)
                        
                        if self.isMoveFromMenuOrCart {
                            
                            self.delegate?.setupMovedFromCartDelegate(self.isMoveFromMenuOrCart)
                            for controller in self.navigationController!.viewControllers as Array {
                                
                                controller.navigationController?.setNavigationBarHidden(false, animated: false)
                                if controller.isKind(of: CartViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }else if self.isMovedFromOptionPage {
                            
                            for controller in self.navigationController!.viewControllers as Array {
                                
                                if controller.isKind(of: OptionViewController.self) {
                                    controller.navigationController?.setNavigationBarHidden(false, animated: false)
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }else {
                            
                            self.setupDrawerController()
                        }
                    }
                }else {
                    
                    if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                        
                        self.showToastWithMessage(self.view, jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String)
                    }
                }
            }
        }
    }
}
