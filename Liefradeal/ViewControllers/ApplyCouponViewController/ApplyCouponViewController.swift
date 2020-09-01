//
//  ApplyCouponViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 15/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import CNPPopupController

class ApplyCouponViewController: BaseViewController, CNPPopupControllerDelegate {

    func popupControllerWillDismiss(_ controller: CNPPopupController) {
        print("Popup controller will be dismissed")
    }
    
    func popupControllerDidPresent(_ controller: CNPPopupController) {
        print("Popup controller presented")
    }
    
    @IBOutlet weak var buttonPopupp: UIButton!
    @IBOutlet var viewPostalCode: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = "Apply Coupon"
        
        self.setupBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.buttonPopupp.layer.cornerRadius = 5.0
    }
    
    @IBAction func buttonShowPopupAction(_ sender: UIButton) {
        
        self.showPopup(CNPPopupStyle.actionSheet)
    }
    
    var height : CGFloat = 250.0
    var popupController:CNPPopupController?
    func showPopup(_ popupStyle: CNPPopupStyle) -> Void {
        
        self.viewPostalCode.frame = CGRect.init(x: 15, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 30, height: self.height)
        
        //        let popupController = CNPPopupController(contents:[titleLabel, lineOneLabel, imageView, lineTwoLabel, customView, button])
        let popupController = CNPPopupController(contents:[self.viewPostalCode])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = popupStyle
        // LFL added settings for custom color and blur
        popupController.theme.maskType = .dimmed
        popupController.delegate = self
        self.popupController = popupController
        popupController.present(animated: true)
    }
}
