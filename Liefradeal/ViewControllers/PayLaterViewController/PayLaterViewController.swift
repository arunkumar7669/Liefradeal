//
//  PayLaterViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 23/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class PayLaterViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, PayNowDelegate {
    
//    Pay now delegate Method
    func buttonContinueOrderClicked(_ indexPath: IndexPath) {
        let dictionaryOrder = self.arrayPaylaterList[indexPath.row]
        let orderDetailsVC = PayLaterDetailsViewController.init(nibName: "PayLaterDetailsViewController", bundle: nil)
        orderDetailsVC.orderDetails = dictionaryOrder
        orderDetailsVC.selectedOrderID = dictionaryOrder[JSONKey.ORDER_ID]!
        self.navigationController?.pushViewController(orderDetailsVC, animated: true)
    }
    
    func buttonPayNowAction(_ indexPath: IndexPath) {
        let dictionaryOrder = self.arrayPaylaterList[indexPath.row]
        let paymentVC = PayNowPaymentViewController.init(nibName: "PayNowPaymentViewController", bundle: nil)
        paymentVC.orderPlaceUrl = ""
        paymentVC.orderDetails = dictionaryOrder
        paymentVC.totalAmount = dictionaryOrder[JSONKey.ORDER_PRICE]!
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    @IBOutlet weak var buttonGotoMenu: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoOrder: UILabel!
    
    var userDetails = UserDetails()
    var arrayPaylaterList = Array<Dictionary<String, String>>()
    var payLaterOrderList = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = "Pay Later"
        
        self.setupBackBarButton()
        self.buttonGotoMenu.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.setupTableViewDelegateAndDatasource()
        self.labelNoOrder.isHidden = true
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {            
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        self.webApiGetPayLaterList()
    }
    
//    Setup tableView Delegate And datasource
    func setupTableViewDelegateAndDatasource() -> Void {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 40
    }
    
//    UITableView Delegate And Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayPaylaterList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("PayLaterTableViewCell", owner: self, options: nil)?.first as! PayLaterTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.indexPath = indexPath

        let dictionaryOrder = self.arrayPaylaterList[indexPath.row]
        cell.labelOrderId.text = "Order Id : " + dictionaryOrder[JSONKey.ORDER_ID]!
        cell.labelAmount.text = ConstantStrings.RUPEES_SYMBOL + dictionaryOrder[JSONKey.ORDER_PRICE]!
//        cell.labelStatus.text = dictionaryOrder[JSONKey.ORDER_TYPE]
        cell.labelDate.text = "\(dictionaryOrder[JSONKey.ORDER_DATE]!) \(dictionaryOrder[JSONKey.ORDER_TIME]!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dictionaryOrder = self.arrayPaylaterList[indexPath.row]
        let orderDetailsVC = PayLaterDetailsViewController.init(nibName: "PayLaterDetailsViewController", bundle: nil)
        orderDetailsVC.orderDetails = dictionaryOrder
        orderDetailsVC.selectedOrderID = dictionaryOrder[JSONKey.ORDER_ID]!
        self.navigationController?.pushViewController(orderDetailsVC, animated: true)
    }
    
//    MARK:- Button Action
//    Button Goto Menu Action
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
//        self.moveOnMenuPage()
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.view.setNeedsLayout()
        }
    }
    
//    MARK:- Web Api Code Start
//    func Web Api for get paylater order list
    func webApiGetPayLaterList() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_OrderDisplayPayLater.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&CustomerId=\(self.userDetails.userID)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupPayLaterList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Func setup PayLater Order List
    func setupPayLaterList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ORDER_DATA] as? Dictionary<String, Any> != nil {
            
            let orderDictionary = jsonDictionary[JSONKey.ORDER_DATA] as! Dictionary<String, Any>
            
            if orderDictionary[JSONKey.ORDER_LIST] as? Array<Dictionary<String, Any>> != nil {
                
                self.arrayPaylaterList.removeAll()
                let arrayOrderDetails = orderDictionary[JSONKey.ORDER_LIST] as! Array<Dictionary<String, Any>>
                
                for orderData in arrayOrderDetails {
                    
                    var orderDetils = Dictionary<String, String>()
                    if orderData[JSONKey.PAYMENT_MODE] as? String != nil {
                        if (orderData[JSONKey.PAYMENT_MODE] as! String) != "payLater" {
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
                            
                            let address = arrayAddress[1].replacingOccurrences(of: "Delivered to", with: "").trim()
                            orderDetils[JSONKey.ORDER_CUTOMER_ADDRESS] = address
                        }else {
                            
                            orderDetils[JSONKey.ORDER_CUTOMER_ADDRESS] = ""
                        }
                    }
                    orderDetils[JSONKey.ORDER_RESTAURANT_NAME] = (orderData[JSONKey.ORDER_RESTAURANT_NAME] as? String != nil) ? (orderData[JSONKey.ORDER_RESTAURANT_NAME] as! String) : " "
                    orderDetils[JSONKey.ORDER_RESTAURANT_ADDRESS] = (orderData[JSONKey.ORDER_RESTAURANT_ADDRESS] as? String != nil) ? (orderData[JSONKey.ORDER_RESTAURANT_ADDRESS] as! String) : " "
                    orderDetils[JSONKey.ORDER_STATUS_MESSAGE] = (orderData[JSONKey.ORDER_STATUS_MESSAGE] as? String != nil) ? (orderData[JSONKey.ORDER_STATUS_MESSAGE] as! String) : " "
                    
                    if !orderDetils.isEmpty {
                        
                        self.arrayPaylaterList.append(orderDetils)
                    }
                }
                
                if self.arrayPaylaterList.count == 0 {
                    
                    self.labelNoOrder.isHidden = false
                }else {
                    
                    self.labelNoOrder.isHidden = true
                    self.tableView.reloadData()
                }
            }
        }
        
        if self.arrayPaylaterList.count == 0 {
            
            self.labelNoOrder.isHidden = false
        }
    }
}
