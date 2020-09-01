//
//  TrackOrderViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON
import MBProgressHUD

class TrackOrderViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelOrderID: UILabel!
    @IBOutlet weak var labelOrderDate: UILabel!
    @IBOutlet weak var labelFoodItem: UILabel!
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDeliveredTo: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var labelWriteReview: UILabel!
    @IBOutlet weak var viewReview: UIView!
    @IBOutlet weak var heightViewReview: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var arrayStatusList = Array<Dictionary<String, String>>()
    var orderStatusString = String()
    var isMovedFromOrderDetails = Bool()
    var orderStatus = Int()
    let DELIVERED_STATUS = "Delivered"
    var totalAmount = String()
    var orderIDString = String()
    let MAX_VIEW_REVIEW_HEIGHT : CGFloat = 50.5
    var orderDetails = Dictionary<String, String>()
    var arrayOrderList = Array<Dictionary<String, String>>()
    var orderBillDetails = Dictionary<String, String>()
    
    let STATUS_MESSAGE = "order_status"
    let STATUS_DATE = "status_data"
    
    let DELIVER_STRING = "Delivery"
    let PICKUP_STRING = "Pickup"
    let DINING_STRING = "EAT-IN"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        let height = self.tableView.contentSize.height
        self.tableViewHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST)
        self.setupCartButtonWithBadge(arrayCartItems.count)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["My_Order"] as? String != nil) ? (self.appDelegate.languageData["My_Order"] as! String).trim() : "My Order"
        self.orderIDString = (self.appDelegate.languageData["Order_ID"] as? String != nil) ? (self.appDelegate.languageData["Order_ID"] as! String).trim() : "Order ID"
        self.labelWriteReview.text = (self.appDelegate.languageData["write_a_review"] as? String != nil) ? (self.appDelegate.languageData["write_a_review"] as! String).trim() : "Write a review"
        let foodItemTitle = (self.appDelegate.languageData["Food_Items"] as? String != nil) ? (self.appDelegate.languageData["Food_Items"] as! String).trim() : "Food Items"
        self.labelFoodItem.text = foodItemTitle + " -"
        
        self.webApiTrackOrder()
        self.setupBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
//        UtilityMethods.addBorderAndShadow(self.viewFoodStatus, 5.0)
        
//        self.labelRecievedDate.text = " "
//        self.labelPreparedDate.text = " "
//        self.labelOutOfDeliveryDate.text = " "
//        self.labelDeliveredDate.text = " "
        self.orderStatus = 1
//        self.viewRating.rating = Double(orderStatus + 1)
        self.labelPrice.text = self.totalAmount
        self.labelOrderDate.text = "\(self.orderDetails[JSONKey.ORDER_DATE]!) \(self.orderDetails[JSONKey.ORDER_TIME]!)"
        self.labelOrderID.text = "\(self.orderIDString) : \(self.orderDetails[JSONKey.ORDER_ID]!)"
        self.hideReviewView()
        
        if self.isMovedFromOrderDetails {
            
            if self.orderDetails[JSONKey.ORDER_STATUS_MESSAGE] == self.DELIVERED_STATUS {
                
                self.showReviewView()
            }else {
                
                self.hideReviewView()
            }
        }
        
        var foodItemString = String()
        for orderDetails in self.arrayOrderList {
            
            if foodItemString.isEmpty {
                
                foodItemString = orderDetails[JSONKey.ORDER_ITEM_NAME]!
            }else {
                
                foodItemString.append(", \(orderDetails[JSONKey.ORDER_ITEM_NAME]!)")
            }
        }
        
        self.labelFoodName.text = foodItemString
        UtilityMethods.addBorderAndShadow(self.viewReview, 5.0)
        let deliveredTo = (self.appDelegate.languageData["delivered_to"] as? String != nil) ? (self.appDelegate.languageData["delivered_to"] as! String).trim() : "Delivered to"
        self.setupDeliveryToLabel("\(deliveredTo) - ", "\(ConstantStrings.ORDER_TYPE_PICKUP_STRING) - ", "\(ConstantStrings.ORDER_TYPE_DINING_STRING) - ")
        self.setupTableViewDelegateAndDatasource()
    }
    
    //    Setup tableView Delegate And datasource
    func setupTableViewDelegateAndDatasource() -> Void {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 40
    }
    
    func setupDeliveryToLabel(_ deliveryLabel : String, _ pickupLabel : String, _ eatInLabel : String) -> Void {
        
        if self.orderDetails[JSONKey.ORDER_TYPE] == self.DELIVER_STRING {
            self.labelAddress.text = self.orderDetails[JSONKey.ORDER_CUTOMER_ADDRESS]
            self.labelDeliveredTo.text = deliveryLabel
        }else if self.orderDetails[JSONKey.ORDER_TYPE] == self.PICKUP_STRING {
            self.labelAddress.text = "\(self.orderDetails[JSONKey.ORDER_RESTAURANT_NAME]!), \(self.orderDetails[JSONKey.ORDER_RESTAURANT_ADDRESS]!)"
            self.labelDeliveredTo.text = pickupLabel
        }else if self.orderDetails[JSONKey.ORDER_TYPE] == self.DINING_STRING {
            self.labelAddress.text = "\(self.orderDetails[JSONKey.ORDER_RESTAURANT_NAME]!), \(self.orderDetails[JSONKey.ORDER_RESTAURANT_ADDRESS]!)"
            self.labelDeliveredTo.text = eatInLabel
        }
    }
        
//    Hide and show review view
    func hideReviewView() -> Void {
        
        self.heightViewReview.constant = 0.5
        self.viewReview.isHidden = true
    }
    
    func showReviewView() -> Void {
        
        self.heightViewReview.constant = self.MAX_VIEW_REVIEW_HEIGHT
        self.viewReview.isHidden = false
    }
    
    //    MARK:- UITableView Delegate And Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayStatusList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TrackTableViewCell", owner: self, options: nil)?.first as! TrackTableViewCell
        cell.selectionStyle = .none
        
        let dictionary = self.arrayStatusList[indexPath.row]
        cell.labelStatus.text = dictionary[self.STATUS_MESSAGE]
        cell.labelDate.text = dictionary[self.STATUS_DATE]
        
        if indexPath.row == 0 {
            
         cell.viewTop.backgroundColor = .clear
        }else if indexPath.row == self.arrayStatusList.count - 1 {
            
            cell.viewBottom.backgroundColor = .clear
        }
        if self.arrayStatusList.count == 1 {
            
            cell.viewBottom.backgroundColor = .clear
        }
        
        return cell
    }
    
    //    MARK:- Button Action
//    Button Action for write review when status is delivered
    @IBAction func buttonWriteReviewAction(_ sender: UIButton) {
        
        let writeReview = WriteReviewViewController.init(nibName: "WriteReviewViewController", bundle: nil)
        writeReview.orderDetails = self.orderDetails
        self.navigationController?.pushViewController(writeReview, animated: true)
    }
    
    //    MARK:- Web Code Start
//    Web Api for get order tracking information
    func webApiTrackOrder() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_Order_Track_Dettail.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&order_identifyno=\(self.orderDetails[JSONKey.ORDER_ID] ?? "0")"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupOrderTrackerSetup(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Func setup Order tracker setup
    func setupOrderTrackerSetup(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary["OrderTrackHistory"] as? Array<Dictionary<String,Any>> != nil {
            
            let arrayDictionary = jsonDictionary["OrderTrackHistory"] as! Array<Dictionary<String,Any>>
            
            self.arrayStatusList.removeAll()
            self.orderStatus = arrayDictionary.count
            for i in 0..<arrayDictionary.count {
                
                let orderDetails = arrayDictionary[i]
                let status = (orderDetails["order_status"] as? String != nil) ? (orderDetails["order_status"] as! String) : " "
                let date = (orderDetails["order_status_date"] as? String != nil) ? (orderDetails["order_status_date"] as! String) : " "
                let time = (orderDetails["order_status_time"] as? String != nil) ? (orderDetails["order_status_time"] as! String) : " "
                self.arrayStatusList.append([self.STATUS_MESSAGE : status, self.STATUS_DATE : "\(date) \(self.convertTimeTo24Hours(time))"])
            }
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                
                self.view.setNeedsLayout()
            }
        }else {
            
            self.showToastWithMessage(self.view, ConstantStrings.WE_COULD_NOT_TRACK_ORDER)
        }
    }
}
