//
//  ReviewViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class ReviewViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoReview: UILabel!
    
    
    var userDetails = UserDetails()
    var orderIDString = String()
    var arrayCustomerReviewList = Array<Dictionary<String, String>>()
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["My_Review"] as? String != nil) ? (self.appDelegate.languageData["My_Review"] as! String).trim() : "My Review"
        self.orderIDString = (self.appDelegate.languageData["Order_ID"] as? String != nil) ? (self.appDelegate.languageData["Order_ID"] as! String).trim() : "Order ID"
        
        self.setupBackBarButton()
        self.labelNoReview.isHidden = true
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        self.setupTableViewDelegateAndDatasource()
        self.webApiGetCustomerReviewList()
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
        
        return self.arrayCustomerReviewList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ReviewTableViewCell", owner: self, options: nil)?.first as! ReviewTableViewCell
        cell.selectionStyle = .none
        
        let dictionaryReview = self.arrayCustomerReviewList[indexPath.row]
        cell.labelOrderID.text = "\(self.orderIDString) - \(dictionaryReview[JSONKey.RESTAURANT_ORDER_ID] ?? " ")"
        cell.labelReview.text = dictionaryReview[JSONKey.RESTAURANT_REVIEW_COMMENT]
        cell.viewRating.rating = Double(dictionaryReview[JSONKey.RESTAURANT_REVIEW_RATING]!)!
        cell.labelTime.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    //    MARK:- Button Action
    @IBAction func buttonWriteReviewAction(_ sender: UIButton) {
        
        let writeReviewVC = WriteReviewViewController.init(nibName: "WriteReviewViewController", bundle: nil)
        self.navigationController?.pushViewController(writeReviewVC, animated: true)
    }
    
    //    MARK:- Web Api Code start
//    Api for get Customer review List
    func webApiGetCustomerReviewList() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = WebApi.BASE_URL + "phpexpert_CustomerReview.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&CustomerId=\(self.userDetails.userID)"
        
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupCustomerReviewList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup Customer Review List
    func setupCustomerReviewList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 0 {
                
                if jsonDictionary[JSONKey.RESTAURANT_REVIEW_DATA] as? Dictionary<String, Any> != nil {
                    
                    let dictionaryReview = jsonDictionary[JSONKey.RESTAURANT_REVIEW_DATA] as! Dictionary<String, Any>
                    
                    if dictionaryReview[JSONKey.RESTAURANT_REVIEW_LIST] as? Array<Dictionary<String, Any>> != nil {
                        
                        let arrayReviewDic = dictionaryReview[JSONKey.RESTAURANT_REVIEW_LIST] as! Array<Dictionary<String, Any>>
                        
                        for reviewDetails in arrayReviewDic {
                            
                            var dictionaryReviewDetails = Dictionary<String, String>()
                            dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_ID] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_ID] as? Int != nil) ? String(reviewDetails[JSONKey.RESTAURANT_REVIEW_ID] as! Int) : "0"
                            dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_COMMENT] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_COMMENT] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_COMMENT] as! String) : ""
                            dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_DATE] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_DATE] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_DATE] as! String) : ""
                            dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_NAME] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_NAME] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_NAME] as! String) : ""
                            dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_IMAGE] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_IMAGE] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_IMAGE] as! String) : ""
                            dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_RATING] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_RATING] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_RATING] as! String) : ""
                            dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_FRIEND_RATING] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_FRIEND_RATING] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_FRIEND_RATING] as! String) : ""
                            dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_DELIVERY_RATING] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_DELIVERY_RATING] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_DELIVERY_RATING] as! String) : ""
                            dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_CUSTOMER_NAME] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_CUSTOMER_NAME] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_CUSTOMER_NAME] as! String) : ""
                            dictionaryReviewDetails[JSONKey.RESTAURANT_ORDER_ID] = (reviewDetails[JSONKey.RESTAURANT_ORDER_ID] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_ORDER_ID] as! String) : ""
                            
                            if !dictionaryReviewDetails.isEmpty {
                                
                                self.arrayCustomerReviewList.append(dictionaryReviewDetails)
                            }
                        }
                    }
                }
                
                if self.arrayCustomerReviewList.count > 0 {
                    
                    self.labelNoReview.isHidden = true
                    self.tableView.reloadData()
                }else {
                    
                    self.labelNoReview.isHidden = false
                    self.labelNoReview.text = (self.appDelegate.languageData["NO_REVIEW_AVAILABLE"] as? String != nil) ? (self.appDelegate.languageData["NO_REVIEW_AVAILABLE"] as! String).trim() : "No review availabel."
                }
            }else {
                
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                 
                    self.labelNoReview.isHidden = false
                    self.labelNoReview.text = (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String)
                }
            }
        }
    }
}
