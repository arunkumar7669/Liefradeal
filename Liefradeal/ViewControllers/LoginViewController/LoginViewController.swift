//
//  LoginViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import CNPPopupController
import RPFloatingPlaceholders

var isFirstTimeOnHomePage = Bool()
var firstMessage = String()
var isRememberMe = Bool()

class LoginViewController: BaseViewController, MovedFromCartPageDelegate {
    
    func setupMovedFromCartDelegate(_ isMovedFromCart: Bool) {
        self.isSkipablePage = true
    }
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var textFieldEmail: RPFloatingPlaceholderTextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var textFieldPassword: RPFloatingPlaceholderTextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var buttonNewRegister: UIButton!
    @IBOutlet weak var buttonForgotPassword: UIButton!
    @IBOutlet var viewForgotPasswordPopup: UIView!
    @IBOutlet weak var textFieldEmailForgotPassword: RPFloatingPlaceholderTextField!
    @IBOutlet weak var labelForgotPasswodTitle: UILabel!
    @IBOutlet weak var buttonSendMail: UIButton!
    
    var isMovedFromOptionPage = Bool()
    var isMovedFromMyProfile = Bool()
    var isMoveFromSignupPage = Bool()
    var isSkipablePage = Bool()
    var isRememberMeClicked = Bool()
    var isMoveFromMenuOrCart = Bool()
    var restaurantInfo = RestaurantInfo()
    var popupViewController:CNPPopupController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Login"] as? String != nil) ? (self.appDelegate.languageData["Login"] as! String).trim() : "Login"
        self.textFieldEmail.placeholder = (self.appDelegate.languageData["Enter_your_email"] as? String != nil) ? (self.appDelegate.languageData["Enter_your_email"] as! String).trim() : "Enter your email address"
        self.textFieldPassword.placeholder = (self.appDelegate.languageData["Password"] as? String != nil) ? (self.appDelegate.languageData["Password"] as! String).trim() : "Password"
        let buttonLoginTitle = (self.appDelegate.languageData["Login"] as? String != nil) ? (self.appDelegate.languageData["Login"] as! String).trim() : "Login"
        self.buttonLogin.setTitle(buttonLoginTitle, for: .normal)
//        self.labelDonotHaveAccount.text = (self.appDelegate.languageData["Donts_have_an_account"] as? String != nil) ? (self.appDelegate.languageData["Donts_have_an_account"] as! String).trim() : "Don't have an account?"
        let buttonNewRegisterTitle = (self.appDelegate.languageData["Create_a_New_Account"] as? String != nil) ? (self.appDelegate.languageData["Create_a_New_Account"] as! String).trim() : "Create a New Account"
        self.buttonNewRegister.setTitle(buttonNewRegisterTitle, for: .normal)
        
        let buttonForgotPasswordTitle = (self.appDelegate.languageData["Forgort_Password"] as? String != nil) ? (self.appDelegate.languageData["Forgort_Password"] as! String).trim() : "Forgot Password"
        self.buttonForgotPassword.setTitle(buttonForgotPasswordTitle, for: .normal)
        self.labelForgotPasswodTitle.text = buttonForgotPasswordTitle
        self.textFieldEmailForgotPassword.placeholder = (self.appDelegate.languageData["Enter_your_email"] as? String != nil) ? (self.appDelegate.languageData["Enter_your_email"] as! String).trim() : "Enter your email address"
        let sendTitle = (self.appDelegate.languageData["Send"] as? String != nil) ? (self.appDelegate.languageData["Send"] as! String).trim() : "Send"
        self.buttonSendMail.setTitle(sendTitle, for: .normal)
        
        self.setupNavigationBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        
//        self.viewLogin.layer.cornerRadius = self.viewLogin.bounds.height / 2
//        self.viewSignup.layer.cornerRadius = self.viewLogin.bounds.height / 2
        self.buttonForgotPassword.setTitleColor(Colors.colorWithHexString(Colors.RED_COLOR), for: .normal)
        self.viewEmail.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewPassword.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        
        UtilityMethods.addBorderAndShadow(self.buttonLogin, 5.0)
//        UtilityMethods.addBorderAndShadow(self.viewEmail, self.viewEmail.bounds.height / 2)
//        UtilityMethods.addBorderAndShadow(self.viewPassword, self.viewPassword.bounds.height / 2)
        self.viewEmail.layer.cornerRadius = 5.0
        self.viewPassword.layer.cornerRadius = 5.0
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) != nil {
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        
//        self.imageViewLogo.sd_setImage(with: URL(string: self.restaurantInfo.logoImageUrl), placeholderImage: UIImage(named: ""))
        self.viewContainer.backgroundColor = .white
        self.view.backgroundColor = .white
//        self.buttonLogin.layer.cornerRadius = self.buttonLogin.bounds.height / 2
//        self.buttonLogin.layer.masksToBounds = true
//        self.buttonLogin.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
//        self.labelLoginTitle.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
//        self.viewLogin.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
//        self.labelSignupTitle.textColor = Colors.colorWithHexString(Colors.DARK_GRAY_COLOR)
//        self.viewSignup.backgroundColor = Colors.colorWithHexString(Colors.DARK_GRAY_COLOR)
        
        if self.isMovedFromOptionPage {
            self.showToastWithMessage(self.view, ConstantStrings.YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.createGradientLayer(self.view)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if self.isSkipablePage {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //    Setup Back Bar Button
    func setupNavigationBackBarButton() -> Void {
        
        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(buttonNavigationBackBarAction(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //    Back Bar Button Action
    @objc func buttonNavigationBackBarAction(_ sender : UIButton) -> Void {
        
        if self.isMovedFromMyProfile {
            
            for controller in self.navigationController!.viewControllers as Array {
                
                if controller.isKind(of: HomeViewController.self) {
                    controller.navigationController?.setNavigationBarHidden(false, animated: false)
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }else {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //    MARK:- Button Action
    @IBAction func buttonSignupPageAction(_ sender: UIButton) {
        
        if self.isMoveFromSignupPage {
            
            self.navigationController?.popViewController(animated: false)
        }else {
            
            let signupVC = SignupViewController.init(nibName: "SignupViewController", bundle: nil)
            signupVC.delegate = self
            signupVC.isMovedFromOptionPage = self.isMovedFromOptionPage
            signupVC.isMoveFromMenuOrCart = self.isMoveFromMenuOrCart
            self.navigationController?.pushViewController(signupVC, animated: false)
        }
    }
    
//    Button Remember me action
    @IBAction func buttonRememberMeAction(_ sender: UIButton) {
        
        if self.isRememberMeClicked {
            
            self.isRememberMeClicked = false
//            self.imageViewCheckBox.image = UIImage.init(named: ConstantStrings.UNSELECTED_CHECK_BOX)
        }else {
            
            self.isRememberMeClicked = true
//            self.imageViewCheckBox.image = UIImage.init(named: ConstantStrings.SELECTED_CHECK_BOX)
        }
    }
    
//    Button Login Action
    @IBAction func buttonLoginAction(_ sender: UIButton) {
        if self.checkValidation() {
            self.webApiLoginExistingUser()
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
        
        if self.textFieldPassword.text!.isEmpty {
            
            self.textFieldPassword.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PASSWORD_FIELD_IS_REQUIRED)
            return false
        }
        
        return true
    }
    
    @IBAction func buttonForgotPasswordAction(_ sender: UIButton) {
        self.setupForgotPasswordView()
    }
    
    @IBAction func buttonSendMailAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if self.textFieldEmailForgotPassword.text!.isEmpty {
            self.textFieldEmailForgotPassword.becomeFirstResponder()
            self.showToastWithMessage(self.viewForgotPasswordPopup, ConstantStrings.EMAIL_FIELD_IS_REQUIRED)
            return
        }
        if !RegularExpression.validateEmail(self.textFieldEmailForgotPassword.text!) {
            self.textFieldEmailForgotPassword.becomeFirstResponder()
            self.showToastWithMessage(self.viewForgotPasswordPopup, ConstantStrings.PLEASE_ENTER_VALID_EMAIL)
            return
        }
        self.popupViewController?.dismiss(animated: true)
        self.webApiSendForgotPasswordMail()
    }
    
    @IBAction func buttonRemoveForgotPasswordViewAction(_ sender: UIButton) {
        self.popupViewController?.dismiss(animated: true)
    }
    
    func setupForgotPasswordView() -> Void {
        
        UtilityMethods.addBorderAndShadow(self.viewForgotPasswordPopup, 5.0)
        UtilityMethods.addBorderAndShadow(self.buttonSendMail, 5.0)
        self.viewForgotPasswordPopup.backgroundColor = .clear
        self.textFieldEmailForgotPassword.text = ""
        self.viewForgotPasswordPopup.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewForgotPasswordPopup.frame = CGRect.init(x: 15, y: 0, width: self.screenWidth - 30, height: 192.0)
        
        let popupController = CNPPopupController(contents:[self.viewForgotPasswordPopup])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = CNPPopupStyle.centered
        // LFL added settings for custom color and blur
        popupController.theme.backgroundColor = .clear
        popupController.theme.maskType = .dimmed
        self.popupViewController = popupController
        popupController.present(animated: true)
    }
    
    //    MARK:- Web Api Code
//    Web Api for login
    func webApiLoginExistingUser() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_login.php?user_email=\(self.textFieldEmail.text!)&user_pass=\(self.textFieldPassword.text!)&api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&device_id&device_platform"
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        WebApi.webApiForGetRequest(updatedUrl) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
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
                            
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: CartViewController.self) {
                                    controller.navigationController?.setNavigationBarHidden(false, animated: false)
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
    
//    Send Mail for ForgotPasssword
    func webApiSendForgotPasswordMail() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_forgot_password.php?user_email=\(self.textFieldEmailForgotPassword.text!)&api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&device_id&device_platform"
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        WebApi.webApiForGetRequest(updatedUrl) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupForgotPasswordMail(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupForgotPasswordMail(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int == 0 {
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    self.showAlertWithMessage(ConstantStrings.ALERT, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }else {
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    self.showAlertWithMessage(ConstantStrings.ALERT, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }
        }
    }
}


extension UIView {
    
    func layerGradient(startPoint : CAGradientPoint, endPoint : CAGradientPoint ,colorArray : [CGColor], type : CAGradientLayerType ) {
        let gradient = CAGradientLayer(start: .topLeft, end: .topRight, colors: colorArray, type: type)
        gradient.frame.size = self.frame.size
        self.layer.insertSublayer(gradient, at: 0)
    }
}


extension CAGradientLayer {
    
    convenience init(start: CAGradientPoint, end: CAGradientPoint, colors: [CGColor], type: CAGradientLayerType) {
        self.init()
        self.frame.origin = CGPoint.zero
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.locations = (0..<colors.count).map(NSNumber.init)
        self.type = type
    }
}

public enum CAGradientPoint {
    case topLeft
    case centerLeft
    case bottomLeft
    case topCenter
    case center
    case bottomCenter
    case topRight
    case centerRight
    case bottomRight
    var point: CGPoint {
        switch self {
        case .topLeft:
            return CGPoint(x: 0, y: 0)
        case .centerLeft:
            return CGPoint(x: 0, y: 0.5)
        case .bottomLeft:
            return CGPoint(x: 0, y: 1.0)
        case .topCenter:
            return CGPoint(x: 0.5, y: 0)
        case .center:
            return CGPoint(x: 0.5, y: 0.5)
        case .bottomCenter:
            return CGPoint(x: 0.5, y: 1.0)
        case .topRight:
            return CGPoint(x: 1.0, y: 0.0)
        case .centerRight:
            return CGPoint(x: 1.0, y: 0.5)
        case .bottomRight:
            return CGPoint(x: 1.0, y: 1.0)
        }
    }
}
