//
//  OrderDetailsViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class OrderDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonTrackOrder: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelOrderNo: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    @IBOutlet weak var viewDeliveryValue: UIView!
    @IBOutlet weak var heightDeliveryView: NSLayoutConstraint!
    @IBOutlet weak var viewPackageFees: UIView!
    @IBOutlet weak var heightPackageFeesView: NSLayoutConstraint!
    @IBOutlet weak var viewServiceFees: UIView!
    @IBOutlet weak var heightServiceFeesView: NSLayoutConstraint!
    @IBOutlet weak var viewSaleTax: UIView!
    @IBOutlet weak var heightSaleTaxView: NSLayoutConstraint!
    @IBOutlet weak var viewVatTax: UIView!
    @IBOutlet weak var heightVatTaxView: NSLayoutConstraint!
    @IBOutlet weak var viewRiderTip: UIView!
    @IBOutlet weak var heightRiderTip: NSLayoutConstraint!
    
    @IBOutlet weak var labelSubTotal: UILabel!
    @IBOutlet weak var labelSubTotalAmount: UILabel!
    @IBOutlet weak var labelDeliveryCost: UILabel!
    @IBOutlet weak var labelDeliveryCostAmount: UILabel!
    @IBOutlet weak var labelPackageFees: UILabel!
    @IBOutlet weak var labelPackageFeesAmount: UILabel!
    @IBOutlet weak var labelServiceFees: UILabel!
    @IBOutlet weak var labelServiceFeesAmount: UILabel!
    @IBOutlet weak var labelSaleTax: UILabel!
    @IBOutlet weak var labelSaleTaxAmount: UILabel!
    @IBOutlet weak var labelVatTax: UILabel!
    @IBOutlet weak var labelVatTaxAmount: UILabel!
    @IBOutlet weak var labelRiderTip: UILabel!
    @IBOutlet weak var labelRiderTipAmount: UILabel!
    @IBOutlet weak var buttonTrackOrderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var labelFoodTax: UILabel!
    @IBOutlet weak var labelFoodTaxAmount: UILabel!
    @IBOutlet weak var labelDrinkTax: UILabel!
    @IBOutlet weak var labelDrinkTaxAmount: UILabel!
    @IBOutlet weak var heightDrinkTax: NSLayoutConstraint!
    @IBOutlet weak var heightFoodTax: NSLayoutConstraint!
    @IBOutlet weak var viewDrinkTax: UIView!
    @IBOutlet weak var viewFoodTax: UIView!
    
    let VIEW_BILL_VALUE_MIN_HEIGHT : CGFloat = 0
    let VIEW_BILL_VALUE_MAX_HEIGHT : CGFloat = 28
    
//    var isOrderCancelled = Bool()
    var orderIDString = String()
    var orderDetails = Dictionary<String, String>()
    var orderBillDetails = Dictionary<String, String>()
    var arrayOrderList = Array<Dictionary<String, String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        let height = self.tableView.contentSize.height
        self.heightTableView.constant = height
        self.view.layoutIfNeeded()
        
        UtilityMethods.addBorderAndShadow(self.viewContainer, 5.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST)
        self.setupCartButtonWithBadge(arrayCartItems.count)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["My_Order"] as? String != nil) ? (self.appDelegate.languageData["My_Order"] as! String).trim() : "My Order"
        self.orderIDString = (self.appDelegate.languageData["Order_ID"] as? String != nil) ? (self.appDelegate.languageData["Order_ID"] as! String).trim() : "Order ID"
        
        self.labelSubTotal.text = (self.appDelegate.languageData["Subtotal"] as? String != nil) ? (self.appDelegate.languageData["Subtotal"] as! String).trim() : "Subtotal"
        self.labelDeliveryCost.text = (self.appDelegate.languageData["Delivery_Cost"] as? String != nil) ? (self.appDelegate.languageData["Delivery_Cost"] as! String).trim() : "Delivery Fees"
        self.labelPackageFees.text = (self.appDelegate.languageData["Package_Fees"] as? String != nil) ? (self.appDelegate.languageData["Package_Fees"] as! String).trim() : "Package Fees"
        self.labelServiceFees.text = (self.appDelegate.languageData["Service_Fees"] as? String != nil) ? (self.appDelegate.languageData["Service_Fees"] as! String).trim() : "Service Fees"
        self.labelSaleTax.text = (self.appDelegate.languageData["Sale_Tax"] as? String != nil) ? (self.appDelegate.languageData["Sale_Tax"] as! String).trim() : "Service Tax"
        self.labelVatTax.text = (self.appDelegate.languageData["Vat_Tax"] as? String != nil) ? (self.appDelegate.languageData["Vat_Tax"] as! String).trim() : "Vat Tax"
        self.labelFoodTax.text = (self.appDelegate.languageData["Food_Tax"] as? String != nil) ? (self.appDelegate.languageData["Food_Tax"] as! String).trim() : "Inclusive Food Tax"
        self.labelDrinkTax.text = (self.appDelegate.languageData["Drink_Tax"] as? String != nil) ? (self.appDelegate.languageData["Drink_Tax"] as! String).trim() : "Inclusive Drink Tax"
        
        self.labelRiderTip.text = (self.appDelegate.languageData["Rider_Tip"] as? String != nil) ? (self.appDelegate.languageData["Rider_Tip"] as! String).trim() : "Rider Tip"
        self.labelTotal.text = (self.appDelegate.languageData["Total"] as? String != nil) ? (self.appDelegate.languageData["Total"] as! String).trim() : "Total"
        let buttonTrackOrderTitle = (self.appDelegate.languageData["Track"] as? String != nil) ? (self.appDelegate.languageData["Track"] as! String).trim() : "Track"
        self.buttonTrackOrder.setTitle(buttonTrackOrderTitle, for: .normal)
        
        self.setupBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.buttonTrackOrder.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.viewContainer.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.labelOrderNo.text = "\(self.orderIDString) : \(self.orderDetails[JSONKey.ORDER_ID]!)"
        self.labelFoodTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + "0.00"
        self.labelDrinkTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + "0.00"
        self.setupAllBillDetailsView()
        self.webApiFetchOrderDetails()
        self.setupTableViewDelegateAndDatasource()
        
        if (self.orderDetails[JSONKey.ORDER_STATUS_MESSAGE]! == ConstantStrings.ORDER_STATUS_CANCELLED) || (self.orderDetails[JSONKey.ORDER_TYPE]! == ConstantStrings.ORDER_TYPE_DINING_STRING) {
            
            self.buttonTrackOrderHeight.constant = 0.5
            self.buttonTrackOrder.isHidden = true
            self.labelStatus.isHidden = true
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("OrderDetailsTableViewCell", owner: self, options: nil)?.first as! OrderDetailsTableViewCell
        cell.selectionStyle = .none
        
        let dictionary = self.arrayOrderList[indexPath.row]
        cell.labelItemName.text = dictionary[JSONKey.ORDER_ITEM_NAME]
        cell.labelDescription.text = dictionary[JSONKey.ORDER_ITEM_SIZE]
        cell.labelQuantity.text = "\(ConstantStrings.RUPEES_SYMBOL + dictionary[JSONKey.ORDER_ITEM_PRICE]!) x \(dictionary[JSONKey.ORDER_ITEM_QUANTITY]!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    //    MARK:- Button Action
    @IBAction func buttonTrackOrderClickAction(_ sender: UIButton) {
        
        let trackOrderVC = TrackOrderViewController.init(nibName: "TrackOrderViewController", bundle: nil)
        trackOrderVC.isMovedFromOrderDetails = true
        trackOrderVC.totalAmount = self.labelTotalAmount.text!
        trackOrderVC.orderDetails = self.orderDetails
        trackOrderVC.arrayOrderList = self.arrayOrderList
        trackOrderVC.orderBillDetails = self.orderBillDetails
        self.navigationController?.pushViewController(trackOrderVC, animated: true)
    }
    
    //    MARK:- Web Code Start
//    Web api for fetch order details
    func webApiFetchOrderDetails() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_Order_DetailsDisplay.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&order_identifyno=\(self.orderDetails[JSONKey.ORDER_ID] ?? "0")"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
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
        
        if jsonDictionary[JSONKey.ORDER_DETAIL_ITEM] as? Array<Dictionary<String, Any>> != nil {
            
            let arrayOrderDictionary = jsonDictionary[JSONKey.ORDER_DETAIL_ITEM] as! Array<Dictionary<String, Any>>
            
            if arrayOrderDictionary.count > 0 {
                
                let orderDictionary = arrayOrderDictionary[0]
                print(orderDictionary)
                
                self.orderBillDetails[JSONKey.ORDER_SERVICE_AMOUNT] = (orderDictionary[JSONKey.ORDER_SERVICE_AMOUNT] as? String != nil) ? (orderDictionary[JSONKey.ORDER_SERVICE_AMOUNT] as! String) : "0.00"
                self.orderBillDetails[JSONKey.ORDER_PACKAGE_AMOUNT] = (orderDictionary[JSONKey.ORDER_PACKAGE_AMOUNT] as? String != nil) ? (orderDictionary[JSONKey.ORDER_PACKAGE_AMOUNT] as! String) : "0.00"
                self.orderBillDetails[JSONKey.ORDER_DELIVERY_AMOUNT] = (orderDictionary[JSONKey.ORDER_DELIVERY_AMOUNT] as? String != nil) ? (orderDictionary[JSONKey.ORDER_DELIVERY_AMOUNT] as! String) : "0.00"
                self.orderBillDetails[JSONKey.ORDER_TIP_AMOUNT] = (orderDictionary[JSONKey.ORDER_TIP_AMOUNT] as? String != nil) ? String(orderDictionary[JSONKey.ORDER_TIP_AMOUNT] as! String) : "0.00"
                self.orderBillDetails[JSONKey.ORDER_SALE_TAX] = (orderDictionary[JSONKey.ORDER_SALE_TAX] as? String != nil) ? (orderDictionary[JSONKey.ORDER_SALE_TAX] as! String) : "0.00"
                self.orderBillDetails[JSONKey.ORDER_VAT_TAX] = (orderDictionary[JSONKey.ORDER_VAT_TAX] as? String != nil) ? (orderDictionary[JSONKey.ORDER_VAT_TAX] as! String) : ""
                self.orderBillDetails[JSONKey.ORDER_SUBTOTAL] = (orderDictionary[JSONKey.ORDER_SUBTOTAL] as? String != nil) ? (orderDictionary[JSONKey.ORDER_SUBTOTAL] as! String) : ""
                self.orderBillDetails[JSONKey.ORDER_STATUS] = (orderDictionary[JSONKey.ORDER_STATUS] as? String != nil) ? (orderDictionary[JSONKey.ORDER_STATUS] as! String) : ""
                self.orderBillDetails[JSONKey.ORDER_FOOD_TAX_7] = (orderDictionary[JSONKey.ORDER_FOOD_TAX_7] as? String != nil) ? (orderDictionary[JSONKey.ORDER_FOOD_TAX_7] as! String) : ""
                self.orderBillDetails[JSONKey.ORDER_DRINK_TAX_19] = (orderDictionary[JSONKey.ORDER_DRINK_TAX_19] as? String != nil) ? (orderDictionary[JSONKey.ORDER_DRINK_TAX_19] as! String) : ""
//                self.orderBillDetails[JSONKey.ORDER_STATUS] = (orderDictionary[JSONKey.ORDER_STATUS] as? String != nil) ? "Delivered" : ""
                
                self.labelSubTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_SUBTOTAL]!
                self.labelDeliveryCostAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_DELIVERY_AMOUNT]!
                self.labelPackageFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_PACKAGE_AMOUNT]!
                self.labelServiceFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_SERVICE_AMOUNT]!
                self.labelSaleTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_SALE_TAX]!
                self.labelVatTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_VAT_TAX]!
                self.labelRiderTipAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_TIP_AMOUNT]!
                self.labelStatus.text = self.orderBillDetails[JSONKey.ORDER_STATUS]
                self.labelFoodTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_FOOD_TAX_7]!
                self.labelDrinkTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_DRINK_TAX_19]!
                self.calculateAndSetupTotalAmount()
                self.setupAllBillDetailsView()
            }
        }
        
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
                
                self.arrayOrderList.append(itemDetails)
            }
            
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                self.view.setNeedsLayout()
            }
        }
    }
    
//    Hide All view of bill details
    func setupAllBillDetailsView() -> Void {
        
        if self.labelDeliveryCostAmount.text!.isEmpty || self.labelDeliveryCostAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelDeliveryCostAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelDeliveryCostAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewDeliveryValue, self.labelDeliveryCost, self.labelDeliveryCostAmount, self.heightDeliveryView)
        }else {
            
            self.showViewWith(self.viewDeliveryValue, self.labelDeliveryCost, self.labelDeliveryCostAmount, self.heightDeliveryView)
        }
        if self.labelServiceFeesAmount.text!.isEmpty || self.labelServiceFeesAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelServiceFeesAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelServiceFeesAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewServiceFees, self.labelServiceFees, self.labelServiceFeesAmount, self.heightServiceFeesView)
        }else {
            
            self.showViewWith(self.viewServiceFees, self.labelServiceFees, self.labelServiceFeesAmount, self.heightServiceFeesView)
        }
        if self.labelPackageFeesAmount.text!.isEmpty || self.labelPackageFeesAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelPackageFeesAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelPackageFeesAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewPackageFees, self.labelPackageFees, self.labelPackageFeesAmount, self.heightPackageFeesView)
        }else {
            
            self.showViewWith(self.viewPackageFees, self.labelPackageFees, self.labelPackageFeesAmount, self.heightPackageFeesView)
        }
        if self.labelSaleTaxAmount.text!.isEmpty || self.labelSaleTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelSaleTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelSaleTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewSaleTax, self.labelSaleTax, self.labelSaleTaxAmount, self.heightSaleTaxView)
        }else {
            
            self.showViewWith(self.viewSaleTax, self.labelSaleTax, self.labelSaleTaxAmount, self.heightSaleTaxView)
        }
        if self.labelVatTaxAmount.text!.isEmpty || self.labelVatTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelVatTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelVatTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewVatTax, self.labelVatTax, self.labelVatTaxAmount, self.heightVatTaxView)
        }else {
            
            self.showViewWith(self.viewVatTax, self.labelVatTax, self.labelVatTaxAmount, self.heightVatTaxView)
        }
        if self.labelRiderTipAmount.text!.isEmpty || self.labelRiderTipAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelRiderTipAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelRiderTipAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewRiderTip, self.labelRiderTip, self.labelRiderTipAmount, self.heightRiderTip)
        }else {
            
            self.showViewWith(self.viewRiderTip, self.labelRiderTip, self.labelRiderTipAmount, self.heightRiderTip)
        }
        if self.labelFoodTaxAmount.text!.isEmpty || self.labelFoodTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelFoodTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelFoodTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewFoodTax, self.labelFoodTax, self.labelFoodTaxAmount, self.heightFoodTax)
        }else {
            
            self.showViewWith(self.viewFoodTax, self.labelFoodTax, self.labelFoodTaxAmount, self.heightFoodTax)
        }
        if self.labelDrinkTaxAmount.text!.isEmpty || self.labelDrinkTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelDrinkTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelDrinkTaxAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewDrinkTax, self.labelDrinkTax, self.labelDrinkTaxAmount, self.heightDrinkTax)
        }else {
            
            self.showViewWith(self.viewDrinkTax, self.labelDrinkTax, self.labelDrinkTaxAmount, self.heightDrinkTax)
        }
    }
    
//    Common hide View Method
    func hideViewWith(_ view : UIView, _ labelTitle : UILabel, _ labelAmount : UILabel, _ viewHeight : NSLayoutConstraint) -> Void {
        
        viewHeight.constant = self.VIEW_BILL_VALUE_MIN_HEIGHT
        view.isHidden = true
        labelTitle.isHidden = true
        labelAmount.isHidden = true
    }
    
//    Common show View Method
    func showViewWith(_ view : UIView, _ labelTitle : UILabel, _ labelAmount : UILabel, _ viewHeight : NSLayoutConstraint) -> Void {
        
        viewHeight.constant = self.VIEW_BILL_VALUE_MAX_HEIGHT
        view.isHidden = false
        labelTitle.isHidden = false
        labelAmount.isHidden = false
    }
    
//    Calculate and setup total paid amount
    func calculateAndSetupTotalAmount() -> Void {
        
        let subtotal = (Double(self.labelSubTotalAmount.text!.dropFirst(1)) != nil) ? Double(self.labelSubTotalAmount.text!.dropFirst(1))! : 0.0
        let deliveryCost = (Double(self.labelDeliveryCostAmount.text!.dropFirst(1)) != nil) ? Double(self.labelDeliveryCostAmount.text!.dropFirst(1))! : 0.0
        let packageFees = (Double(self.labelPackageFeesAmount.text!.dropFirst(1)) != nil) ? Double(self.labelPackageFeesAmount.text!.dropFirst(1))! : 0.0
        let serviceFees = (Double(self.labelServiceFeesAmount.text!.dropFirst(1)) != nil) ? Double(self.labelServiceFeesAmount.text!.dropFirst(1))! : 0.0
        let saleTax = (Double(self.labelSaleTaxAmount.text!.dropFirst(1)) != nil) ? Double(self.labelSaleTaxAmount.text!.dropFirst(1))! : 0.0
        let vatTax = (Double(self.labelVatTaxAmount.text!.dropFirst(1)) != nil) ? Double(self.labelVatTaxAmount.text!.dropFirst(1))! : 0.0
        let tipAmount = (Double(self.labelRiderTipAmount.text!.dropFirst(1)) != nil) ? Double(self.labelRiderTipAmount.text!.dropFirst(1))! : 0.0
        
        let foodTaxAmount = (Double(self.labelFoodTaxAmount.text!.dropFirst(1)) != nil) ? Double(self.labelFoodTaxAmount.text!.dropFirst(1))! : 0.0
        let drinkTaxAmount = (Double(self.labelDrinkTaxAmount.text!.dropFirst(1)) != nil) ? Double(self.labelDrinkTaxAmount.text!.dropFirst(1))! : 0.0
        
        let totalPayableAmount = subtotal + deliveryCost + packageFees + serviceFees + saleTax + vatTax + tipAmount + foodTaxAmount + drinkTaxAmount
        self.labelTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", totalPayableAmount)
    }
}
