//
//  DrawerViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 03/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class DrawerViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelPhone: UILabel!
    
    var arrayMenuName = Array<String>()
    var arrayMenuImage = Array<String>()
    var userDetails = UserDetails()
    var languageData = Dictionary<String, Any>()
    
//    For Guest user
    let LOGIN_PAGE = 0
    let SIGN_UP_PAGE = 1
    let CONTACT_PAGE = 2
    let ABOUT_US_PAGE = 3
    let TERM_AND_SERVICES_PAGE = 4
    let PRIVACY_POLICY_PAGE = 5
    let RATE_US_GUEST = 6
    let LANGUAGE_SETTING = 7
    
//    For Existing user
    let MY_ACCOUNT_PAGE = 0
    let MY_ORDER_PAGE = 1
    let MY_ADDRESS_PAGE = 2
    let MY_REVIEW_PAGE = 3
    let MANAGE_TICKET = 4
    let LOYALTY_POINTS = 5
    let CHANGE_PASSWORD = 6
    let REFER_A_FRIEND = 7
    let CONTACT_US_PAGE = 8
    let RATE_US_PAGE = 9
    let LOGOUT_PAGE = 10
    let LANGUAGE_SETTING_USER = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.languageData = self.appDelegate.languageData
        let myAccount = (self.languageData["My_Account"] as? String != nil) ? (self.languageData["My_Account"] as! String).trim() : "My Account"
        let myOrder = (self.languageData["My_Order"] as? String != nil) ? (self.languageData["My_Order"] as! String).trim() : "My Order"
        let myAddress = (self.languageData["My_Address"] as? String != nil) ? (self.languageData["My_Address"] as! String).trim() : "My Address"
        let myReview = (self.languageData["My_Review"] as? String != nil) ? (self.languageData["My_Review"] as! String).trim() : "My Reviews"
        let myTicket = (self.languageData["My_Ticket"] as? String != nil) ? (self.languageData["My_Ticket"] as! String).trim() : "My Ticket"
        let myLoyaltyPoints = (self.languageData["My_Loyalty_Points"] as? String != nil) ? (self.languageData["My_Loyalty_Points"] as! String).trim() : "My Loyalty Points"
        let changePassword = (self.languageData["Change_Password"] as? String != nil) ? (self.languageData["Change_Password"] as! String).trim() : "Change Password"
        let referFriends = (self.languageData["Refer_a_Friends"] as? String != nil) ? (self.languageData["Refer_a_Friends"] as! String).trim() : "Refer a Friends"
        let languageSettings = (self.languageData["LANGUAGE_SETTINGS"] as? String != nil) ? (self.languageData["LANGUAGE_SETTINGS"] as! String).trim() : "Language Settings"
        let contactUs = (self.languageData["Contact_Us_Help"] as? String != nil) ? (self.languageData["Contact_Us_Help"] as! String).trim() : "Contact Us/Help"
        let rateApp = (self.languageData["Rate_Us"] as? String != nil) ? (self.languageData["Rate_Us"] as! String).trim() : "Rate Us"
        let logout = (self.languageData["Logout"] as? String != nil) ? (self.languageData["Logout"] as! String).trim() : "Logout"
        let Login = (self.languageData["Login"] as? String != nil) ? (self.languageData["Login"] as! String).trim() : "Login"
        let register = (self.languageData["Register"] as? String != nil) ? (self.languageData["Register"] as! String).trim() : "Register"
        let termsSerices = (self.languageData["Terms_of_Service"] as? String != nil) ? (self.languageData["Terms_of_Service"] as! String).trim() : "Terms of Service"
        let privacyPolicy = (self.languageData["Privacy_Policy"] as? String != nil) ? (self.languageData["Privacy_Policy"] as! String).trim() : "Privacy & Policy"
        let aboutUs =  (self.languageData["About_Us"] as? String != nil) ? (self.languageData["About_Us"] as! String).trim() : "About Us"
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        self.labelUserName.text = self.userDetails.userName
        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
            self.labelUserName.text = self.userDetails.userName
            self.labelPhone.text = self.userDetails.userPhone
            self.imageViewUser.sd_setImage(with: URL(string: self.userDetails.userPhotoUrl), placeholderImage: UIImage(named: "profile_pic"))
        }else {
            self.labelUserName.text = (self.appDelegate.languageData["Welcome_Guest"] as? String != nil) ? (self.appDelegate.languageData["Welcome_Guest"] as! String).trim() : ConstantStrings.WELCOME_GUEST_STRING
            self.labelPhone.text = ""
            self.imageViewUser.image = UIImage.init(named: "user")
        }
        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
            self.arrayMenuName = [myAccount, myOrder, myAddress, myReview, myTicket, myLoyaltyPoints, changePassword, referFriends, contactUs, rateApp, logout, languageSettings]
            self.arrayMenuImage = ["me", "my_order", "my_address", "my_review", "my_ticket", "loyalty", "change_password", "refer_friend", "contactus", "rate_us", "logout", "language"]
        }else {
            self.arrayMenuName = [Login, register, contactUs, aboutUs, termsSerices, privacyPolicy, rateApp, languageSettings]
            self.arrayMenuImage = ["login", "signup", "contactus", "aboutus", "terms_service", "privacy_policy", "rate_us", "language"]
        }
        self.tableView.reloadData()
        self.tableView.scrollToTop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.imageViewUser.layer.cornerRadius = self.imageViewUser.bounds.height / 2
        self.imageViewUser.layer.masksToBounds = false
        self.imageViewUser.image = UIImage.init(named: "user")
        UtilityMethods.changeImageColor(self.imageViewUser, .lightGray)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.imageViewUser.layer.cornerRadius = self.imageViewUser.bounds.height / 2
        self.imageViewUser.layer.masksToBounds = true
        self.setupTableViewDelegateAndDatasource()
        UtilityMethods.addBorder(self.tableView, Colors.colorWithHexString("#C6EAFA"), 5.0)
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
        
        return self.arrayMenuName.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("DrawerTableViewCell", owner: self, options: nil)?.first as! DrawerTableViewCell
        cell.selectionStyle = .none
        
        cell.labelMenu.text = self.arrayMenuName[indexPath.row]
        
        if indexPath.row > (self.arrayMenuImage.count - 1) {
            
            cell.imageViewMenu.image = UIImage.init(named: "home")
        }else {
            
            cell.imageViewMenu.image = UIImage.init(named: self.arrayMenuImage[indexPath.row])
        }
        UtilityMethods.changeImageColor(cell.imageViewMenu, .darkGray)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        if !UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {

            switch indexPath.row {

            case self.LOGIN_PAGE:
                self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
                self.moveOnLoginPage()
                break
                
            case self.SIGN_UP_PAGE:
                self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
                self.moveOnSignupPage()
                break
                
            case self.CONTACT_PAGE:
                self.moveOnContactPage()
                break
                
            case self.ABOUT_US_PAGE:
                self.moveOnAboutUsPage()
                break
                
            case self.LANGUAGE_SETTING:
                self.moveOnLanguageSettingPage()
                break
                
            case self.TERM_AND_SERVICES_PAGE:
                self.moveOnTermAndService()
                break
                
            case self.PRIVACY_POLICY_PAGE:
                self.moveOnPrivacyPolicy()
                break

            default:
                self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
            }
        }else {
            
            switch indexPath.row {
            
            case self.MY_ACCOUNT_PAGE:
                self.moveOnMyAccountPage()
                break
                
            case self.MY_ORDER_PAGE:
                self.moveOnMyOrderPage()
                break
                
            case self.MY_ADDRESS_PAGE:
                self.moveOnAddressPage()
                break
                
            case self.MY_REVIEW_PAGE:
                self.moveOnRatingReviewPage()
                break
                
            case self.MANAGE_TICKET:
                self.moveOnManageTicketPage()
                break
                
            case self.LOYALTY_POINTS:
                self.moveOnLoyaltyPage()
                break
                
            case self.CHANGE_PASSWORD:
                self.moveOnChangePasswordPage()
                break
                
            case self.REFER_A_FRIEND:
                self.moveOnReferPage()
                break
                
            case self.LANGUAGE_SETTING_USER:
                self.moveOnLanguageSettingPage()
                break
                
            case self.CONTACT_US_PAGE:
                self.moveOnContactPage()
                break
                
//            case self.PAY_LATER_PAGE:
//                self.moveOnPayLaterPage()
//                break
                
            case self.RATE_US_PAGE:
//                Rate App
                self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
                break
                
            case self.LOGOUT_PAGE:
                self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
                self.setupLogoutPage()
                break
                
            default:
                self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
            }
        }
    }
    
    //    MARK:- Setup Drawer Section
//    Move on Language Setting Page
    func moveOnLanguageSettingPage() -> Void {
        
        let languageSVC = LanguageSettingViewController.init(nibName: "LanguageSettingViewController", bundle: nil)
        self.setupMainViewController(languageSVC)
    }
    
//    Move on Pay Later Button
    func moveOnPayLaterPage() -> Void {
        
        let paylaterVC = PayLaterViewController.init(nibName: "PayLaterViewController", bundle: nil)
        self.setupMainViewController(paylaterVC)
    }
    
//    Move on Manage Ticket Page
    func moveOnManageTicketPage() -> Void {
        
        let manageTicketVC = ManageTicketViewController.init(nibName: "ManageTicketViewController", bundle: nil)
        self.setupMainViewController(manageTicketVC)
    }
    
//    Move on My Profile Page for change the password
    func moveOnChangePasswordPage() -> Void {
        
        let myProfilePage = MyProfileViewController.init(nibName: "MyProfileViewController", bundle: nil)
        myProfilePage.isChangePasswordEnable = true
        self.setupMainViewController(myProfilePage)
    }
    
//    Move on Terms and Service
    func moveOnTermAndService() -> Void {
        
        let mainVC = TermsConditionViewController.init(nibName: "TermsConditionViewController", bundle: nil)
        self.setupMainViewController(mainVC)
    }
    
//    Move on Privacy and policy
    func moveOnPrivacyPolicy() -> Void {
        
        let mainVC = PrivacyPolicyViewController.init(nibName: "PrivacyPolicyViewController", bundle: nil)
        self.setupMainViewController(mainVC)
    }
    
//    Move on Offer page
    func moveOnOfferPage() -> Void {
        
        let offerVC = OfferViewController.init(nibName: "OfferViewController", bundle: nil)
        self.setupMainViewController(offerVC)
    }
    
//    Move On Address Page
    func moveOnAddressPage() -> Void {
        
        let addressVC = AddressViewController.init(nibName: "AddressViewController", bundle: nil)
        self.setupMainViewController(addressVC)
    }
    
//    Move on My Account page
    func moveOnMyAccountPage() -> Void {
        
        let myProfieVC = MyProfileViewController.init(nibName: "MyProfileViewController", bundle: nil)
        self.setupMainViewController(myProfieVC)
    }
    
//    Move on My Order page
    func moveOnMyOrderPage() -> Void {
        
        let orderVC = OrderViewController.init(nibName: "OrderViewController", bundle: nil)
        self.setupMainViewController(orderVC)
    }
    
//    Move on Login page
    func moveOnLoginPage() -> Void {
        
        let login = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
        self.setupMainViewController(login)
    }
    
//    Move on signup page
    func moveOnSignupPage() -> Void {
        
        let signup = SignupViewController.init(nibName: "SignupViewController", bundle: nil)
        self.setupMainViewController(signup)
    }
    
//    Move on Review & Rating Page
    func moveOnRatingReviewPage() -> Void {
        
        let reviewVC = ReviewViewController.init(nibName: "ReviewViewController", bundle: nil)
        self.setupMainViewController(reviewVC)
    }
    
//    Move on Service Page
    func moveOnOurServicePage() -> Void {
        
        let serviceVC = ServiceViewController.init(nibName: "ServiceViewController", bundle: nil)
        self.setupMainViewController(serviceVC)
    }
    
//    Move on Contact page
    func moveOnContactPage() -> Void {
        
        let contactVC = ContactViewController.init(nibName: "ContactViewController", bundle: nil)
        self.setupMainViewController(contactVC)
    }
    
//    Move on Loyalty page
    func moveOnLoyaltyPage() -> Void {
        
        let loyaltyVC = LoyaltyViewController.init(nibName: "LoyaltyViewController", bundle: nil)
        self.setupMainViewController(loyaltyVC)
    }
    
//    Move on ABout Us page
    func moveOnAboutUsPage() -> Void {
        
        let aboutUsVC = AboutUsViewController.init(nibName: "AboutUsViewController", bundle: nil)
        self.setupMainViewController(aboutUsVC)
    }
    
//    Move on Delivery page
    func moveOnDeliveryAreaPage() -> Void {
        
        let deliveryVC = DeliveryViewController.init(nibName: "DeliveryViewController", bundle: nil)
        self.setupMainViewController(deliveryVC)
    }
    
//    Move on Refer page
    func moveOnReferPage() -> Void {
        
        let referVC = ReferViewController.init(nibName: "ReferViewController", bundle: nil)
        self.setupMainViewController(referVC)
    }
    
    //    Setup MainViewController
    func setupMainViewController(_ viewController : UIViewController) -> Void {
        
        let navigationController = self.appDelegate.drawerController.mainViewController as! UINavigationController
        let dashboardVC = navigationController.viewControllers.first as! HomeViewController
        dashboardVC.navigationController?.setNavigationBarHidden(false, animated: false)
        dashboardVC.navigationController?.pushViewController(viewController, animated: false)
        self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
    }
    
    //    MARK:- Button Action
    @IBAction func buttonGotoProfilePageAction(_ sender: UIButton) {
        
        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
            
            let profileVC = MyProfileViewController.init(nibName: "MyProfileViewController", bundle: nil)
            self.setupMainViewController(profileVC)
        }
    }
    
    @IBAction func btnSignInTapped(_ sender: UIButton) {
        self.moveOnLoginPage()
    }
    
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        self.moveOnSignupPage()
    }
    
//    Setup logout page
    func setupLogoutPage() -> Void {
        
        let alrtctrl = UIAlertController.init(title: ConstantStrings.ALERT, message: ConstantStrings.ARE_YOU_SURE_YOU_WANT_TO_LOGOUT, preferredStyle: .alert)
        
        let actionOK = UIAlertAction.init(title: ConstantStrings.OK_STRING, style: .default) { (alert) in
            
            self.setupValuesBeforeLogout()
            self.moveOnLoginPage()
        }
        
        let actionCancel = UIAlertAction.init(title: ConstantStrings.CANCEL_STRING, style: .default, handler: nil)
        
        alrtctrl.addAction(actionOK)
        alrtctrl.addAction(actionCancel)
        self.present(alrtctrl, animated: true, completion: nil)
    }
    
}


extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
