//
//  ReferViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 02/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class ReferViewController: BaseViewController {

    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var labelRefer: UILabel!
    @IBOutlet weak var viewReferCode: UIView!
    @IBOutlet weak var buttonReferCode: UIButton!
    @IBOutlet weak var labelReferCode: UILabel!
    @IBOutlet weak var viewReferBg: UIView!
//    @IBOutlet weak var labelFirst: UILabel!
    @IBOutlet weak var labelRefered: UILabel!
    @IBOutlet weak var labelReferedTitle: UILabel!
    @IBOutlet weak var buttonGotoMenu: UIButton!
    @IBOutlet weak var labelReferralCodeMessage: UILabel!
    @IBOutlet weak var labelFriendShare: UILabel!
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["Refer_a_Friend"] as? String != nil) ? (self.appDelegate.languageData["Refer_a_Friend"] as! String).trim() : "Refer a Friend"
        
        let friend = (self.appDelegate.languageData["Friend"] as? String != nil) ? (self.appDelegate.languageData["Friend"] as! String).trim() : "Friend"
        self.labelRefer.text = (self.appDelegate.languageData["referral_code"] as? String != nil) ? (self.appDelegate.languageData["referral_code"] as! String).trim() : "Referral Code"
        self.labelRefered.text = (self.appDelegate.languageData["You_have_referred"] as? String != nil) ? (self.appDelegate.languageData["You_have_referred"] as! String).trim() : "You have referred"
        self.labelReferedTitle.text = self.labelRefered.text!
        
        self.setupBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        
        UtilityMethods.addBorderAndShadow(self.viewReferBg, 5.0)
        UtilityMethods.addBorderAndShadow(viewReferCode, 5.0)
        self.buttonGotoMenu.setTitle(ConstantStrings.GO_TO_MENU, for: .normal)
        
        self.labelReferCode.text = UserDefaultOperations.getStringObject(ConstantStrings.REFERRAL_CODE)
        self.labelReferralCodeMessage.text = UserDefaultOperations.getStringObject(ConstantStrings.REFERRAL_CODE_MESSAGE)
        self.labelFriendShare.text = UserDefaultOperations.getStringObject(ConstantStrings.REFERRAL_CODE_SHARE_FRIEND) + " \(friend)"
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) != nil {
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        self.imageViewLogo.sd_setImage(with: URL(string: self.restaurantInfo.logoImageUrl), placeholderImage: UIImage(named: ""))
    }
    
    //    MARK:- Button Action
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
        self.moveOnMenuPage()
    }
    
//    Button Action for share
    @IBAction func buttonShareAppAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
//            For setup WhatsApp
            self.shareTextOnApp()
        }else if sender.tag == 2 {
            
//            For setup Facebook
            self.shareTextOnApp()
        }else if sender.tag == 3 {
            
//            For setup Twitter
            self.shareTextOnApp()
        }else if sender.tag == 4 {
            
//            For setup Share
            self.shareTextOnApp()
        }
    }
    
    @IBAction func buttonCopyReferralCodeAction(_ sender: UIButton) {
        
//        UIPasteboard.general.string = self.labelReferCode.text!
//        self.showToastWithMessage(self.view, "Referral code copied to clipboard.")
    }
    
//    Func setup Share text to device
    func shareTextOnApp() -> Void {
        
        let text = UserDefaultOperations.getStringObject(ConstantStrings.REFERRAL_STRING)
        let textShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
