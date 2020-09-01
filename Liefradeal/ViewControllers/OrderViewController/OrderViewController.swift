
//
//  OrderViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class OrderViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, LiveOrderOptionDelegate {
    
//    Live Order Delegate
    func trackOrderWithIndexPath(_ indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        let dictionary = self.arrayOrderList[indexPath.row]
        self.webApiFetchOrderDetails(dictionary[JSONKey.ORDER_ID]!)
    }
    
    func cancelOrderWithIndexPath(_ indexPath: IndexPath) {
        
        let dictionaryOrder = self.arrayOrderList[indexPath.row]
        let orderID = dictionaryOrder[JSONKey.ORDER_ID]!
        self.setupAlertControllerActionSheet(orderID)
    }
    

//    @IBOutlet weak var viewTopButton: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonGotoMenu: UIButton!
//    @IBOutlet weak var buttonLiveOrder: UIButton!
//    @IBOutlet weak var buttonPastOrder: UIButton!
    @IBOutlet weak var labelNoOrder: UILabel!
    @IBOutlet weak var heightButtonGotoMenu: NSLayoutConstraint!
    
    let LIVE_ORDER = 1
    let PAST_ORDER = 2
    let BUTTON_HEIGHT : CGFloat = 45.0
    
    var orderStatus = Int()
    var trackString = String()
    var cancelString = String()
    var orderIDString = String()
    var userDetails = UserDetails()
    var selectedIndexPath = IndexPath()
    var arrayOrderList = Array<Dictionary<String, String>>()
    var arrayOrderItemList = Array<Dictionary<String, String>>()
    
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
        self.navigationItem.title = (self.appDelegate.languageData["My_Order"] as? String != nil) ? (self.appDelegate.languageData["My_Order"] as! String).trim() : "My Order"
        self.orderIDString = (self.appDelegate.languageData["Order_ID"] as? String != nil) ? (self.appDelegate.languageData["Order_ID"] as! String).trim() : "Order ID"
        self.trackString = (self.appDelegate.languageData["Track"] as? String != nil) ? (self.appDelegate.languageData["Track"] as! String).trim() : "TRACK"
        self.cancelString = (self.appDelegate.languageData["Cancel"] as? String != nil) ? (self.appDelegate.languageData["Cancel"] as! String).trim() : "CANCEL"
        self.buttonGotoMenu.setTitle(ConstantStrings.GO_TO_MENU, for: .normal)
        
        self.setupBackBarButton()
        self.orderStatus = self.LIVE_ORDER
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        self.labelNoOrder.isHidden = true
        self.setupTableViewDelegateAndDatasource()
        self.webApiFetchOrderList()
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
        
        return self.arrayOrderList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    let DELIVERY_STRING = "Delivery"
    let PICKUP_STRING = "Pickup"
    let DINING_STRING = "EAT-IN"
    let STATUS_CANCELLED = "Cancelled"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.orderStatus == self.LIVE_ORDER {
            
            let cell = Bundle.main.loadNibNamed("LiveOrderTableViewCell", owner: self, options: nil)?.first as! LiveOrderTableViewCell
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            cell.delegate = self
            cell.contentView.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
            
            let dictionaryOrder = self.arrayOrderList[indexPath.row]
            cell.labelOrderID.text = "\(self.orderIDString) : " + dictionaryOrder[JSONKey.ORDER_ID]!
            cell.labelAmount.text = ConstantStrings.RUPEES_SYMBOL + dictionaryOrder[JSONKey.ORDER_PRICE]!
            cell.labelStatus.text = dictionaryOrder[JSONKey.ORDER_TYPE]
            cell.labelDate.text = "\(dictionaryOrder[JSONKey.ORDER_DATE]!) \(dictionaryOrder[JSONKey.ORDER_TIME]!)"
            if cell.labelStatus.text! == self.DINING_STRING {
                cell.buttonCancelHeight.constant = 0.5
                cell.buttonCancel.isHidden = true
                cell.buttonReorder.isHidden = true
            }else {
                cell.buttonCancelHeight.constant = 25
                cell.buttonCancel.isHidden = false
                cell.buttonReorder.isHidden = false
            }
            
            if dictionaryOrder[JSONKey.ORDER_STATUS_MESSAGE] == self.STATUS_CANCELLED {
                
                cell.labelStatus.text = dictionaryOrder[JSONKey.ORDER_STATUS_MESSAGE]
                cell.labelStatus.textColor = Colors.colorWithHexString(Colors.RED_COLOR)
                cell.buttonCancel.isHidden = true
                cell.buttonReorder.isHidden = true
            }else {
                
                cell.labelStatus.text = dictionaryOrder[JSONKey.ORDER_TYPE]
                cell.labelStatus.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
                cell.buttonCancel.isHidden = false
            }
            cell.buttonReorder.setTitle(self.trackString, for: .normal)
            cell.buttonCancel.setTitle(self.cancelString, for: .normal)
            
            return cell
        }else {
            
            let cell = Bundle.main.loadNibNamed("PastOrderTableViewCell", owner: self, options: nil)?.first as! PastOrderTableViewCell
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
            
            let dictionaryOrder = self.arrayOrderList[indexPath.row]
            cell.labelOrderID.text = "\(self.orderIDString) : " + dictionaryOrder[JSONKey.ORDER_ID]!
            cell.labelAmount.text = ConstantStrings.RUPEES_SYMBOL + dictionaryOrder[JSONKey.ORDER_PRICE]!
            cell.labelStatus.text = dictionaryOrder[JSONKey.ORDER_TYPE]
            cell.labelDate.text = "\(dictionaryOrder[JSONKey.ORDER_DATE]!) \(dictionaryOrder[JSONKey.ORDER_TIME]!)"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dictionaryOrder = self.arrayOrderList[indexPath.row]
        if self.orderStatus == self.LIVE_ORDER {
            
            let orderDetailsVC = OrderDetailsViewController.init(nibName: "OrderDetailsViewController", bundle: nil)
            orderDetailsVC.orderDetails = dictionaryOrder
            self.navigationController?.pushViewController(orderDetailsVC, animated: true)
        }else {
            
            let orderDetailsVC = OrderDetailsViewController.init(nibName: "OrderDetailsViewController", bundle: nil)
            orderDetailsVC.orderDetails = dictionaryOrder
            self.navigationController?.pushViewController(orderDetailsVC, animated: true)
        }
    }
    
    func setupAlertControllerActionSheet(_ orderID : String) -> Void {
        
        let cancelOrderString =  (self.appDelegate.languageData["YOU_WANT_TO_CANCEL_ADDRESS"] as? String != nil) ? (self.appDelegate.languageData["YOU_WANT_TO_CANCEL_ADDRESS"] as! String).trim() : "Are you sure you want cancel this order?"
        let alrtctrl = UIAlertController.init(title: ConstantStrings.ALERT, message: cancelOrderString, preferredStyle: .alert)
        let actionOK = UIAlertAction.init(title: ConstantStrings.OK_STRING, style: .default) { (alert) in
            
            self.webApiCancelOrder(orderID)
        }
        
        let actionCancel = UIAlertAction.init(title: ConstantStrings.CANCEL_STRING, style: .default, handler: nil)
        
        alrtctrl.addAction(actionOK)
        alrtctrl.addAction(actionCancel)
        self.present(alrtctrl, animated: true, completion: nil)
    }
    
    //    MARK:- Button Action
    @IBAction func buttonLiveOrderAction(_ sender: UIButton) {
        
        if sender.tag == self.LIVE_ORDER {
            
            self.orderStatus = self.LIVE_ORDER
            
//            self.buttonLiveOrder.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
//            self.buttonLiveOrder.setTitleColor(.white, for: .normal)
//            self.buttonPastOrder.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
//            self.buttonPastOrder.setTitleColor(.darkGray, for: .normal)
        }else {
            
//            self.orderStatus = self.PAST_ORDER
//            self.buttonPastOrder.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
//            self.buttonPastOrder.setTitleColor(.white, for: .normal)
//            self.buttonLiveOrder.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
//            self.buttonLiveOrder.setTitleColor(.darkGray, for: .normal)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
        self.moveOnMenuPage()
    }
    
    //    MARK:- Web Code Start
//    Web api for fetch order list
    func webApiFetchOrderList() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_OrderDisplay.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&CustomerId=\(self.userDetails.userID)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupOrderList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    setup order list
    func setupOrderList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ORDER_DATA] as? Dictionary<String, Any> != nil {
            
            let orderDictionary = jsonDictionary[JSONKey.ORDER_DATA] as! Dictionary<String, Any>
            
            if orderDictionary[JSONKey.ORDER_LIST] as? Array<Dictionary<String, Any>> != nil {
                
                self.arrayOrderList.removeAll()
                let arrayOrderDetails = orderDictionary[JSONKey.ORDER_LIST] as! Array<Dictionary<String, Any>>
                
                for orderData in arrayOrderDetails {
                    
                    var orderDetils = Dictionary<String, String>()
                    if orderData[JSONKey.PAYMENT_MODE] as? String != nil {
                        if (orderData[JSONKey.PAYMENT_MODE] as! String) == "payLater" {
                            continue
                        }else {
                            orderDetils[JSONKey.PAYMENT_MODE] = (orderData[JSONKey.PAYMENT_MODE] as! String)
                        }
                    }
                    if orderData[JSONKey.ORDER_ID] as? String != nil {
                        orderDetils[JSONKey.ORDER_ID] = (orderData[JSONKey.ORDER_ID] as! String)
                    }
                    if orderData[JSONKey.ORDER_TIME] as? String != nil {
                        orderDetils[JSONKey.ORDER_TIME] = self.convertTimeTo24Hours(orderData[JSONKey.ORDER_TIME] as! String)
                    }
                    if orderData[JSONKey.ORDER_RESTAURANT_ID] as? String != nil {
                        orderDetils[JSONKey.ORDER_RESTAURANT_ID] = (orderData[JSONKey.ORDER_RESTAURANT_ID] as! String)
                    }
                    if orderData[JSONKey.ORDER_TYPE] as? String != nil {
                        orderDetils[JSONKey.ORDER_TYPE] = (orderData[JSONKey.ORDER_TYPE] as! String)
                    }
                    if orderData[JSONKey.ORDER_PRICE] as? String != nil {
                        orderDetils[JSONKey.ORDER_PRICE] = (orderData[JSONKey.ORDER_PRICE] as! String)
                    }
                    if orderData[JSONKey.ORDER_DATE] as? String != nil {
                        orderDetils[JSONKey.ORDER_DATE] = (orderData[JSONKey.ORDER_DATE] as! String)
                    }
                    if orderData[JSONKey.ORDER_CUTOMER_ADDRESS] as? String != nil {
                        let customerAddress = (orderData[JSONKey.ORDER_CUTOMER_ADDRESS] as! String)
                        let arrayAddress = customerAddress.components(separatedBy : "|")
                        if arrayAddress.count > 1 {
                            let deliveredTo = (self.appDelegate.languageData["delivered_to"] as? String != nil) ? (self.appDelegate.languageData["delivered_to"] as! String).trim() : "Delivered to"
                            let address = arrayAddress[1].replacingOccurrences(of: deliveredTo, with: "").trim()
                            orderDetils[JSONKey.ORDER_CUTOMER_ADDRESS] = address
                        }else {
                            orderDetils[JSONKey.ORDER_CUTOMER_ADDRESS] = ""
                        }
                    }
                    orderDetils[JSONKey.ORDER_RESTAURANT_NAME] = (orderData[JSONKey.ORDER_RESTAURANT_NAME] as? String != nil) ? (orderData[JSONKey.ORDER_RESTAURANT_NAME] as! String) : " "
                    orderDetils[JSONKey.ORDER_RESTAURANT_ADDRESS] = (orderData[JSONKey.ORDER_RESTAURANT_ADDRESS] as? String != nil) ? (orderData[JSONKey.ORDER_RESTAURANT_ADDRESS] as! String) : " "
                    orderDetils[JSONKey.ORDER_STATUS_MESSAGE] = (orderData[JSONKey.ORDER_STATUS_MESSAGE] as? String != nil) ? (orderData[JSONKey.ORDER_STATUS_MESSAGE] as! String) : " "
                    
                    if !orderDetils.isEmpty {
                        self.arrayOrderList.append(orderDetils)
                    }
                }
                
                if self.arrayOrderList.count == 0 {
                    self.labelNoOrder.text = (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil) ? (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String) : "Sorry! You have not placed any order yet"
                    self.labelNoOrder.isHidden = false
                }else {
                    self.labelNoOrder.isHidden = true
                    self.tableView.reloadData()
                }
            }
        }
        
        if self.arrayOrderList.count == 0 {
            self.labelNoOrder.text = (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil) ? (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String) : "Sorry! You have not placed any order yet"
            self.labelNoOrder.isHidden = false
        }
    }
    
    
    //    Web api for fetch order list
    func webApiCancelOrder(_ orderID : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_Customer_Order_Cancelled.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&order_identifyno=\(orderID)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            if json.isEmpty {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupCancelOrderDetails(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup Cancel order details
    func setupCancelOrderDetails(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int == 0 {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    self.webApiFetchOrderList()
                    self.showToastWithMessage(self.view, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }else {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showToastWithMessage(self.view, ConstantStrings.YOUR_ORDER_COUNT_NOT_CANCEL)
                }
            }else {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showToastWithMessage(self.view, ConstantStrings.YOUR_ORDER_COUNT_NOT_CANCEL)
            }
        }else {
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showToastWithMessage(self.view, ConstantStrings.YOUR_ORDER_COUNT_NOT_CANCEL)
        }
    }
    
//    Web api for fetch order details
    func webApiFetchOrderDetails(_ orderID : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_Order_DetailsDisplay.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&order_identifyno=\(orderID)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupOrderItemList(json.dictionaryObject!)
                }
            }
        }
    }
    
    //    setup order list
    func setupOrderItemList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ORDER_FOOD_ITEM_LIST] as? Array<Dictionary<String, Any>> != nil {
            let arrayFoodOrderList = jsonDictionary[JSONKey.ORDER_FOOD_ITEM_LIST] as! Array<Dictionary<String, Any>>
            for foodDetails in arrayFoodOrderList {
                var itemDetails = Dictionary<String, String>()
                itemDetails[JSONKey.ORDER_ITEM_NAME] = (foodDetails[JSONKey.ORDER_ITEM_NAME] as? String != nil) ? (foodDetails[JSONKey.ORDER_ITEM_NAME] as! String) : ""
                itemDetails[JSONKey.ORDER_ITEM_EXTRATOPING] = (foodDetails[JSONKey.ORDER_ITEM_EXTRATOPING] as? String != nil) ? (foodDetails[JSONKey.ORDER_ITEM_EXTRATOPING] as! String) : ""
                itemDetails[JSONKey.ORDER_ITEM_PRICE] = (foodDetails[JSONKey.ORDER_ITEM_PRICE] as? String != nil) ? (foodDetails[JSONKey.ORDER_ITEM_PRICE] as! String) : ""
                itemDetails[JSONKey.ORDER_ITEM_QUANTITY] = (foodDetails[JSONKey.ORDER_ITEM_QUANTITY] as? Int != nil) ? String(foodDetails[JSONKey.ORDER_ITEM_QUANTITY] as! Int) : ""
                itemDetails[JSONKey.ORDER_ITEM_CURRENCY] = (foodDetails[JSONKey.ORDER_ITEM_CURRENCY] as? String != nil) ? (foodDetails[JSONKey.ORDER_ITEM_CURRENCY] as! String) : ""
                itemDetails[JSONKey.ORDER_ITEM_SIZE] = (foodDetails[JSONKey.ORDER_ITEM_SIZE] as? String != nil) ? (foodDetails[JSONKey.ORDER_ITEM_SIZE] as! String) : ""
                
                self.arrayOrderItemList.append(itemDetails)
            }
            let dictionaryOrder = self.arrayOrderList[self.selectedIndexPath.row]
            let orderDetailsVC = TrackOrderViewController.init(nibName: "TrackOrderViewController", bundle: nil)
            orderDetailsVC.orderDetails = dictionaryOrder
            orderDetailsVC.arrayOrderList = self.arrayOrderItemList
            self.navigationController?.pushViewController(orderDetailsVC, animated: true)
        }
    }
}

