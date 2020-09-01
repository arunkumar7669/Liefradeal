//
//  ThankyouViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 19/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class ThankyouViewController: BaseViewController {

    @IBOutlet weak var labelOrderNumber: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var buttonWriteAReview: UIButton!
    @IBOutlet weak var buttonBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var buttonTopMargin: NSLayoutConstraint!
    @IBOutlet weak var buttonContinueShopping: UIButton!
    @IBOutlet weak var buttonGotoHome: UIButton!
    @IBOutlet weak var labelPaymentComplete: UILabel!
    @IBOutlet weak var labelYourOrderNo: UILabel!
    @IBOutlet weak var labelSuccessMessage: UILabel!
    
    var orderID = String()
    var isMovableOnPayLaterDetailsPage = Bool()
    var isMovedFromPayNow = Bool()
    
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
        
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Order_Complete"] as? String != nil) ? (self.appDelegate.languageData["Order_Complete"] as! String).trim() : "Order Complete"
        let buttonGotoHomeTitle = (self.appDelegate.languageData["GO_TO_HOME"] as? String != nil) ? (self.appDelegate.languageData["GO_TO_HOME"] as! String).trim() : "Go to Home"
        self.labelPaymentComplete.text = (self.appDelegate.languageData["Payment_Completed"] as? String != nil) ? (self.appDelegate.languageData["Payment_Completed"] as! String).trim() : "Payment Completed"
        self.labelSuccessMessage.text = (self.appDelegate.languageData["We_have_sent_you_email"] as? String != nil) ? (self.appDelegate.languageData["We_have_sent_you_email"] as! String).trim() : "We`ve sent you an email with all the \n details of your order & remember you \n can track your order using this app!"
        self.labelYourOrderNo.text = (self.appDelegate.languageData["You_re_Order_Number"] as? String != nil) ? (self.appDelegate.languageData["You_re_Order_Number"] as! String).trim() : "Your Order Number"
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        self.viewContainer.layer.cornerRadius = 5.0
        self.viewContainer.layer.borderWidth = 0.5
        self.viewContainer.layer.borderColor = UIColor.lightGray.cgColor
        self.buttonGotoHome.setTitle(buttonGotoHomeTitle, for: .normal)
        self.buttonContinueShopping.isHidden = true
        self.buttonWriteAReview.backgroundColor = Colors.colorWithHexString(Colors.RED_COLOR)
        self.labelOrderNumber.text = self.orderID
        if self.isMovedFromPayNow {
            self.buttonWriteAReview.setTitle(ConstantStrings.WRITE_A_REVIEW, for: .normal)
        }else {
            if self.isMovableOnPayLaterDetailsPage {
            }else {
                self.buttonWriteAReview.isHidden = true
                self.buttonTopMargin.constant = 0.5
                self.buttonBottomMargin.constant = 0.5
            }
            self.buttonWriteAReview.setTitle(ConstantStrings.CONTINUE_ORDER, for: .normal)
        }
    }
    
    //    MARK:- Button Action
//    Button Continue Shopping Action
    @IBAction func buttonContinueShoppingAction(_ sender: UIButton) {
        
        let homeVC = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func buttonWriteAReviewAction(_ sender: UIButton) {
        if self.isMovableOnPayLaterDetailsPage {
            let orderDetailsVC = PayLaterDetailsViewController.init(nibName: "PayLaterDetailsViewController", bundle: nil)
            orderDetailsVC.isMovedFromThankyouPage = true
            orderDetailsVC.selectedOrderID = self.orderID
            self.navigationController?.pushViewController(orderDetailsVC, animated: true)
        }else {
            let writeRVC = WriteReviewViewController.init(nibName: "WriteReviewViewController", bundle: nil)
            writeRVC.orderID = self.orderID
            writeRVC.isMovedFromThankyou = true
            self.navigationController?.pushViewController(writeRVC, animated: true)
        }
    }
}
