//
//  MyProfileViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 08/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import CNPPopupController
import RPFloatingPlaceholders

class MyProfileViewController: BaseViewController, ProfileUpdatedDelegate {
    
    func setupProfileDetails() {
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        self.labelProfileName.text = self.userDetails.userName
        self.imageViewProfile.sd_setImage(with: URL(string: self.userDetails.userPhotoUrl), placeholderImage: UIImage(named: "profile_pic"))
    }

    @IBOutlet weak var viewMyProfile: UIView!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var labelMyProfile: UILabel!
    @IBOutlet weak var viewYourOrder: UIView!
    @IBOutlet weak var labelYourOrder: UILabel!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var viewMyAddress: UIView!
    @IBOutlet weak var labelMyAddress: UILabel!
    @IBOutlet weak var viewLoyaltyPoints: UIView!
    @IBOutlet weak var labelLoyaltyPoints: UILabel!
    @IBOutlet weak var viewMyTicket: UIView!
    @IBOutlet weak var labelMyTicket: UILabel!
    @IBOutlet weak var viewLogout: UIView!
    @IBOutlet weak var labelLogout: UILabel!
    @IBOutlet weak var imageViewEdit: UIImageView!
    @IBOutlet weak var imageViewOrder: UIImageView!
    @IBOutlet weak var imageViewPassword: UIImageView!
    @IBOutlet weak var imageViewLocation: UIImageView!
    @IBOutlet weak var imageViewLoyalty: UIImageView!
    @IBOutlet weak var imageViewTicket: UIImageView!
    @IBOutlet weak var imageViewLogout: UIImageView!
    @IBOutlet weak var labelChangePassword: UILabel!
    
    @IBOutlet var viewChangePasswordPopup: UIView!
    @IBOutlet weak var textFieldOldPassword: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldNewPassword: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldReTypePassword: RPFloatingPlaceholderTextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonShowOldPassword: UIButton!
    @IBOutlet weak var buttonShowNewPassword: UIButton!
    @IBOutlet weak var buttonShowReTyepPassword: UIButton!
    
    let EDIT_PROFILE = 1
    let YOUR_ORDER = 2
    let PASSWORD = 3
    let MY_ADDRESS = 4
    let LOYALTY_POINT = 5
    let MY_TICKET = 6
    let LOGOUT = 7
    var userDetails = UserDetails()
    var isChangePasswordEnable = Bool()
    var isOldPasswordShowing = Bool()
    var isNewPasswordShowing = Bool()
    var isReTypePasswordShowing = Bool()
    var popupViewController : CNPPopupController?
    let CHANGE_PASSWORD_VIEW_HEIGHT : CGFloat = 297.5
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["My_Profile"] as? String != nil) ? (self.appDelegate.languageData["My_Profile"] as! String).trim() : "My Profile"
        self.labelMyProfile.text = (self.appDelegate.languageData["My_Profile"] as? String != nil) ? (self.appDelegate.languageData["My_Profile"] as! String).trim() : "My Profile"
        self.labelYourOrder.text = (self.appDelegate.languageData["My_Order"] as? String != nil) ? (self.appDelegate.languageData["My_Order"] as! String).trim() : "My Order"
        self.labelPassword.text =  (self.appDelegate.languageData["Password_Security"] as? String != nil) ? (self.appDelegate.languageData["Password_Security"] as! String).trim() : "Password Security"
        
        self.labelMyAddress.text = (self.appDelegate.languageData["My_Address"] as? String != nil) ? (self.appDelegate.languageData["My_Address"] as! String).trim() : "My Address"
        self.labelLoyaltyPoints.text = (self.appDelegate.languageData["Loyalty_Points"] as? String != nil) ? (self.appDelegate.languageData["Loyalty_Points"] as! String).trim() : "Loyalty Points"
        self.labelMyTicket.text = (self.appDelegate.languageData["My_Ticket"] as? String != nil) ? (self.appDelegate.languageData["My_Ticket"] as! String).trim() : "My Ticket"
        self.labelLogout.text = (self.appDelegate.languageData["Logout"] as? String != nil) ? (self.appDelegate.languageData["Logout"] as! String).trim() : "Logout"
        
        self.textFieldOldPassword.placeholder = (self.appDelegate.languageData["Enter_Old_Password"] as? String != nil) ? (self.appDelegate.languageData["Enter_Old_Password"] as! String).trim() : "Enter Old Password"
        self.textFieldNewPassword.placeholder = (self.appDelegate.languageData["Enter_New_Password"] as? String != nil) ? (self.appDelegate.languageData["Enter_New_Password"] as! String).trim() : "Enter New Password"
        self.textFieldReTypePassword.text = (self.appDelegate.languageData["Enter_Re_Type_Password"] as? String != nil) ? (self.appDelegate.languageData["Enter_Re_Type_Password"] as! String).trim() : "Enter Retype Password"
        self.labelChangePassword.text = (self.appDelegate.languageData["Change_Password"] as? String != nil) ? (self.appDelegate.languageData["Change_Password"] as! String).trim() : "Change Password"
        let buttonSubmitTitle = (self.appDelegate.languageData["Submit"] as? String != nil) ? (self.appDelegate.languageData["Submit"] as! String).trim() : "Submit"
        self.buttonSubmit.setTitle(buttonSubmitTitle, for: .normal)
        
        self.setupBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewLogout.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewMyTicket.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewPassword.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewMyProfile.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewMyAddress.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewYourOrder.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewLoyaltyPoints.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        
        UtilityMethods.changeImageColor(self.imageViewEdit, .darkGray)
        UtilityMethods.changeImageColor(self.imageViewOrder, .darkGray)
        UtilityMethods.changeImageColor(self.imageViewTicket, .darkGray)
        UtilityMethods.changeImageColor(self.imageViewLoyalty, .darkGray)
        UtilityMethods.changeImageColor(self.imageViewLocation, .darkGray)
        UtilityMethods.changeImageColor(self.imageViewPassword, .darkGray)
        UtilityMethods.changeImageColor(self.imageViewLogout, .darkGray)
        
        UtilityMethods.addBorder(self.viewMyProfile, Colors.colorWithHexString("#DCDCDC"), 5.0)
        UtilityMethods.addBorder(self.viewMyAddress, Colors.colorWithHexString("#DCDCDC"), 5.0)
        UtilityMethods.addBorder(self.viewMyTicket, Colors.colorWithHexString("#DCDCDC"), 5.0)
        UtilityMethods.addBorder(self.viewPassword, Colors.colorWithHexString("#DCDCDC"), 5.0)
        UtilityMethods.addBorder(self.viewYourOrder, Colors.colorWithHexString("#DCDCDC"), 5.0)
        UtilityMethods.addBorder(self.viewLogout, Colors.colorWithHexString("#DCDCDC"), 5.0)
        UtilityMethods.addBorder(self.viewLoyaltyPoints, Colors.colorWithHexString("#DCDCDC"), 5.0)
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        self.labelProfileName.text = self.userDetails.userName
        self.imageViewProfile.sd_setImage(with: URL(string: self.userDetails.userPhotoUrl), placeholderImage: UIImage(named: "profile_pic"))
        
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.bounds.height / 2
        self.imageViewProfile.layer.masksToBounds = true
//        UtilityMethods.changeImageColor(self.imageViewProfile, .lightGray)
        
        if self.isChangePasswordEnable {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                self.setupChangePasswordView()
            }
        }
    }
    
    //    MARK:- Button Action
    @IBAction func buttonProfileAction(_ sender: UIButton) {
        
        if sender.tag == self.EDIT_PROFILE {
            
            let editPVC = EditProfileViewController.init(nibName: "EditProfileViewController", bundle: nil)
            editPVC.delegate = self
            self.navigationController?.pushViewController(editPVC, animated: true)
        }else if sender.tag == self.YOUR_ORDER {
            
            let orderVC = OrderViewController.init(nibName: "OrderViewController", bundle: nil)
            self.navigationController?.pushViewController(orderVC, animated: true)
        }else if sender.tag == self.PASSWORD {
            
            self.setupChangePasswordView()
        }else if sender.tag == self.MY_ADDRESS {
            
            let addressVC = AddressViewController.init(nibName: "AddressViewController", bundle: nil)
            self.navigationController?.pushViewController(addressVC, animated: true)
        }else if sender.tag == self.LOYALTY_POINT {
            
            let loyaltyPVC = LoyaltyViewController.init(nibName: "LoyaltyViewController", bundle: nil)
            self.navigationController?.pushViewController(loyaltyPVC, animated: true)
        }else if sender.tag == self.MY_TICKET {
            
            let manageTVC = ManageTicketViewController.init(nibName: "ManageTicketViewController", bundle: nil)
            self.navigationController?.pushViewController(manageTVC, animated: true)
        }else if sender.tag == self.LOGOUT {
            
            self.setupLogoutPage()
        }
    }
    
    //    Setup logout page
    func setupLogoutPage() -> Void {
        
        let alrtctrl = UIAlertController.init(title: ConstantStrings.ALERT, message: "Are you sure you want logout?", preferredStyle: .alert)
        
        let actionOK = UIAlertAction.init(title: ConstantStrings.OK_STRING, style: .default) { (alert) in
            
            self.setupValuesBeforeLogout()
            self.moveOnLoginPage()
        }
        
        let actionCancel = UIAlertAction.init(title: ConstantStrings.CANCEL_STRING, style: .default, handler: nil)
        
        alrtctrl.addAction(actionOK)
        alrtctrl.addAction(actionCancel)
        self.present(alrtctrl, animated: true, completion: nil)
    }
    
    //    Move on Login page
    func moveOnLoginPage() -> Void {

        let login = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
        login.isMovedFromMyProfile = true
        self.setupMainViewController(login)
    }
    
    func setupMainViewController(_ viewController : UIViewController) -> Void {
        
        let navigationController = self.appDelegate.drawerController.mainViewController as! UINavigationController
        let dashboardVC = navigationController.viewControllers.first as! HomeViewController
        dashboardVC.navigationController?.setNavigationBarHidden(false, animated: false)
        dashboardVC.navigationController?.pushViewController(viewController, animated: false)
        self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
    }
    
    @IBAction func buttonSubmitNewPasswordAction(_ sender: UIButton) {
        
        if self.checkValidation() {
            
            self.webApiChangeUserPassword()
        }
        
    }
    
    func checkValidation() -> Bool {
        
        self.viewChangePasswordPopup.endEditing(true)
        if self.textFieldOldPassword.text!.isEmpty {
            
            self.textFieldOldPassword.becomeFirstResponder()
//            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.OLD_PASSWORD_IS_REQUIRED)
            self.showToastWithMessage(self.viewChangePasswordPopup, ConstantStrings.OLD_PASSWORD_IS_REQUIRED)
            return false
        }
        
        if self.textFieldNewPassword.text!.isEmpty {
            
            self.textFieldNewPassword.becomeFirstResponder()
//            self.popupViewController.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.NEW_PASSWORD_IS_REQUIRED)
            self.showToastWithMessage(self.viewChangePasswordPopup, ConstantStrings.NEW_PASSWORD_IS_REQUIRED)
            return false
        }
        
        if self.textFieldReTypePassword.text!.isEmpty {
            
            self.textFieldReTypePassword.becomeFirstResponder()
//            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.RE_TYPE_PASSWORD_IS_REQUIRED)
            self.showToastWithMessage(self.viewChangePasswordPopup, ConstantStrings.RE_TYPE_PASSWORD_IS_REQUIRED)
            return false
        }
        
        if self.textFieldNewPassword.text! != self.textFieldReTypePassword.text! {
            
//            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.BOTH_PASSWORD_SHOULD_BE_SAME)
            self.showToastWithMessage(self.viewChangePasswordPopup, ConstantStrings.BOTH_PASSWORD_SHOULD_BE_SAME)
            return false
        }
        
        return true
    }
    
    @IBAction func buttonShowOldPasswordAction(_ sender: UIButton) {
        
        if self.isOldPasswordShowing {
            
            self.textFieldOldPassword.isSecureTextEntry = true
            self.isOldPasswordShowing = false
            self.buttonShowOldPassword.setImageTintColor(.lightGray)
        }else {
            
            self.textFieldOldPassword.isSecureTextEntry = false
            self.isOldPasswordShowing = true
            self.buttonShowOldPassword.setImageTintColor(Colors.colorWithHexString(Colors.GREEN_COLOR))
        }
    }
    
    @IBAction func buttonShowNewPasswordAction(_ sender: UIButton) {
        
        if self.isNewPasswordShowing {
            
            self.textFieldNewPassword.isSecureTextEntry = true
            self.isNewPasswordShowing = false
            self.buttonShowNewPassword.setImageTintColor(.lightGray)
        }else {
            
            self.textFieldNewPassword.isSecureTextEntry = false
            self.isNewPasswordShowing = true
            self.buttonShowNewPassword.setImageTintColor(Colors.colorWithHexString(Colors.GREEN_COLOR))
        }
    }
    
    @IBAction func buttonShowReTyprPasswordAction(_ sender: UIButton) {
        
        if self.isReTypePasswordShowing {
            
            self.textFieldReTypePassword.isSecureTextEntry = true
            self.isReTypePasswordShowing = false
            self.buttonShowReTyepPassword.setImageTintColor(.lightGray)
        }else {
            
            self.textFieldReTypePassword.isSecureTextEntry = false
            self.isReTypePasswordShowing = true
            self.buttonShowReTyepPassword.setImageTintColor(Colors.colorWithHexString(Colors.GREEN_COLOR))
        }
    }
    
    @IBAction func buttonRemoveChangePasswordPopupViewAction(_ sender: UIButton) {
        
        self.popupViewController?.dismiss(animated: true)
    }
    
    func setupChangePasswordView() -> Void {
        
        UtilityMethods.addBorderAndShadow(self.viewChangePasswordPopup, 5.0)
        UtilityMethods.addBorderAndShadow(self.buttonSubmit, self.buttonSubmit.bounds.height / 2)
        self.viewChangePasswordPopup.backgroundColor = .clear
        self.textFieldOldPassword.text = ""
        self.textFieldNewPassword.text = ""
        self.textFieldReTypePassword.text = ""
        self.viewChangePasswordPopup.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewChangePasswordPopup.frame = CGRect.init(x: 15, y: 0, width: self.screenWidth - 30, height: self.CHANGE_PASSWORD_VIEW_HEIGHT)
        
        let popupController = CNPPopupController(contents:[self.viewChangePasswordPopup])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = CNPPopupStyle.centered
        // LFL added settings for custom color and blur
        popupController.theme.backgroundColor = .clear
        popupController.theme.maskType = .dimmed
        self.popupViewController = popupController
        popupController.present(animated: true)
    }
    
    //    MARK:- Web Api Code start
//    Change Password api
    func webApiChangeUserPassword() -> Void {
        
        MBProgressHUD.showAdded(to: self.viewChangePasswordPopup, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_passwordChange.php?lang_code=en&api_key=foodkey&NewCustomerPassword=\(self.textFieldNewPassword.text!)&OldCustomerPassword=\(self.textFieldOldPassword.text!)&CustomerId=\(self.userDetails.userID)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.viewChangePasswordPopup, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupChangePassword(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup On change password successfull
    func setupChangePassword(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 1 {
                
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    
                    self.popupViewController?.dismiss(animated: true)
                    self.showToastWithMessage(self.view, jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String)
                    if self.isChangePasswordEnable {
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }else {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
                
                if jsonDictionary[JSONKey.ERROR_CODE] as! Int == 1 {
                    
                    if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                        
                        self.showToastWithMessage(self.viewChangePasswordPopup, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                    }
                }
            }
        }
    }
}

extension UIButton{
    
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
    
}
