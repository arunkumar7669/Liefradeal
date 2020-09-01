//
//  WriteReviewViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON
import MBProgressHUD

protocol ReviewedSubmittedDelegate : class {
    
    func showReviewSubmittedMessage(_ message : String)
}

class WriteReviewViewController: BaseViewController {

    @IBOutlet weak var labelWriteReview: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var textViewReview: UITextView!
    @IBOutlet weak var buttonSubmitReview: UIButton!
    
    var userDetails = UserDetails()
    var orderID = String()
    var isMovedFromThankyou = Bool()
    var orderDetails = Dictionary<String, String>()
    weak var delegate : ReviewedSubmittedDelegate?
    
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
        
        self.navigationItem.title = "Write a review"
        
        self.setupBackBarButton()
        self.textViewReview.placeholder = "Write your review"
        UtilityMethods.addBorderAndShadow(self.buttonSubmitReview, 5.0)
        self.viewRating.rating = 1.0
        self.buttonSubmitReview.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
    }
    
    //    MARK:- Button Action
    @IBAction func buttonSubmitReviewAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let rating = String(self.viewRating.rating)
        var orderID = String()
        if self.isMovedFromThankyou {
            orderID = self.orderID
        }else {
            orderID = self.orderDetails[JSONKey.ORDER_ID]!
        }
        print("\(rating), \(orderID)")
        
        if self.textViewReview.text!.isEmpty {
            
            self.textViewReview.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.WRITE_REVIEW_IS_REQUIRED)
        }else {
            
            self.webApiGetCustomerReviewList(rating, orderID)
        }
    }
    
    //    MARK:- Web Api Code start
    //    Api for get Customer review List
    func webApiGetCustomerReviewList(_ rating : String, _ orderID : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = WebApi.BASE_URL + "phpexpert_write_review.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&CustomerId=\(self.userDetails.userID)&RestaurantReviewRating=\(rating)&Quality_ratingN=&Service_ratingN=&Time_ratingN=&RestaurantReviewContent=\(self.textViewReview.text!)&order_identifyno=\(orderID)"
        
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupOnSuccessWriteReview(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup OnSuccess Write review
    func setupOnSuccessWriteReview(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 1 {
                
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    
                    if isMovedFromThankyou {
                        isFirstTimeOnHomePage = true
                        firstMessage = jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String
                        let homeVC = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    }else {
                        self.delegate?.showReviewSubmittedMessage(jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }else {
            
            if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                
                self.showToastWithMessage(self.view, ConstantStrings.RATING_REVIEW_COULD_NOT_SUBMITTED)
            }
        }
    }
}
