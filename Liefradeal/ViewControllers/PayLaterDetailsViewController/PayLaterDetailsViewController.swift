//
//  PayLaterDetailsViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 25/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

var payLaterGlobalOrderID = String()
var selectedPayLaterGlobalOrderID = String()
var isMovedFromPayLaterDetailsPage = Bool()
var arrayGlobalPayLaterList = Array<Dictionary<String, String>>()

class PayLaterDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ModifyCartItemCountDelegate {
    
    func updateCartItemQuantity(_ count : String, _ indexPath : IndexPath, _ buttonTag : Int) {
        
        var arrayNewItemList = self.arrayOrderList[indexPath.section]
        var dictionary = arrayNewItemList[indexPath.row]

        if Int(count)! == 0 {

            dictionary[JSONKey.ITEM_QUANTITY] = count
            dictionary[JSONKey.ITEM_CART_PRICE] = "0"
            dictionary[JSONKey.ITEM_CART_ORIGINAL_PRICE] = "0"
            dictionary[JSONKey.ITEM_UPDATED_PRICE] = dictionary[JSONKey.ITEM_OFFER_PRICE]
            dictionary[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE] = dictionary[JSONKey.ITEM_ORIGINAL_PRICE]
            dictionary[JSONKey.ITEM_IS_ADDED_TO_CART] = ConstantStrings.ITEM_NOT_ADDED_TO_CART
            arrayNewItemList.remove(at: indexPath.row)
            if arrayNewItemList.count == 0 {
                
                self.arrayOrderList.remove(at: indexPath.section)
            }
            self.reloadTableView()
        }else {

            dictionary[JSONKey.ITEM_QUANTITY] = count

            let totalAmount = (Double(dictionary[JSONKey.ITEM_UPDATED_PRICE]!)!) * (Double(count)!)
            dictionary[JSONKey.ITEM_CART_PRICE] = String(format: "%.2f", totalAmount)
            let totalOriginalAmount = (Double(dictionary[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE]!)!) * (Double(count)!)
            dictionary[JSONKey.ITEM_CART_ORIGINAL_PRICE] = String(format: "%.2f", totalOriginalAmount)
            arrayNewItemList[indexPath.row] = dictionary
        }
        arrayGlobalPayLaterList = arrayNewItemList
        if arrayNewItemList.count > 0 {
            
            self.arrayOrderList[indexPath.section] = arrayNewItemList
        }
        self.callGetRestaurantService()
        self.reloadTableView()
    }

    @IBOutlet weak var buttonConfirmAndPay: UIButton!
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
    
    @IBOutlet weak var viewRestaurantDiscount: UIView!
    @IBOutlet weak var labelRestaurantDiscount: UILabel!
    @IBOutlet weak var labelRestaurantDiscountAmount: UILabel!
    @IBOutlet weak var heightRestaurantDiscountView: NSLayoutConstraint!
    
    @IBOutlet weak var viewNewFoodItem: UIView!
    @IBOutlet weak var labelNewFoodItem: UILabel!
    @IBOutlet weak var labelNewFoodItemAmount: UILabel!
    @IBOutlet weak var heightViewNewFoodItem: NSLayoutConstraint!
    
    @IBOutlet weak var viewNewFoodDiscount: UIView!
    @IBOutlet weak var labelNewFoodDiscount: UILabel!
    @IBOutlet weak var labelNewFoodDiscountAmount: UILabel!
    @IBOutlet weak var heightViewNewFoodDiscount: NSLayoutConstraint!
    
    let VIEW_BILL_VALUE_MIN_HEIGHT : CGFloat = 0
    let VIEW_BILL_VALUE_MAX_HEIGHT : CGFloat = 28
    
//    var isOrderCancelled = Bool()
    var newFoodItemAmount = String()
    var newSubTotalAmount = String()
    var newFoodItemDiscount = String()
    var userDetails = UserDetails()
    var newFoodTax = String()
    var newDrinkTax = String()
    var selectedOrderID = String()
    var isMovedFromThankyouPage = Bool()
    var orderDetails = Dictionary<String, String>()
    var orderBillDetails = Dictionary<String, String>()
    var arrayOrderList = Array<Array<Dictionary<String, String>>>()
    
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
        
        if isMovedFromPayLaterDetailsPage {
            isMovedFromPayLaterDetailsPage = false
//            if payLaterGlobalOrderID == self.orderDetails[JSONKey.ORDER_ID]! {
                if arrayGlobalPayLaterList.count > 0 {
                    let arrayFiltered = self.filterArrayAccordingToOrderID()
                    if self.arrayOrderList.count > 1 {
                        self.arrayOrderList[1] = arrayFiltered
                    }else {
                        self.arrayOrderList.append(arrayFiltered)
                    }
                    self.reloadTableView()
                    self.callGetRestaurantService()
                }
//            }
        }
    }
    
    func callGetRestaurantService() -> Void {
        self.newFoodItemAmount = String(format : "%.2f", self.calculateTotalFoodAmountWithExtraTopping())
        self.newFoodItemDiscount = String(format : "%.2f", self.calculateTotalFoodDiscount())
        self.newFoodTax = self.calculate7PercentTax()
        self.newDrinkTax = self.calculate19PercentTax()
        self.webApiGetRestaurantDiscount(self.newFoodItemAmount)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = "My Order"
        self.setupNavBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.buttonConfirmAndPay.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.viewContainer.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.buttonConfirmAndPay.setTitle(ConstantStrings.CONFIRM_AND_PAY, for: .normal)
        self.labelOrderNo.text = "Order Id : \(self.selectedOrderID)"
        self.labelNewFoodItemAmount.text = ConstantStrings.RUPEES_SYMBOL + "0.00"
        self.labelNewFoodDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + "0.00"
        self.labelRestaurantDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + "0.00"
        self.labelFoodTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + "0.00"
        self.labelDrinkTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + "0.00"
        self.setupAllBillDetailsView()
        self.webApiFetchOrderDetails()
        self.setupTableViewDelegateAndDatasource()
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
    }
    
    //    Setup Back Bar Button
        func setupNavBackBarButton() -> Void {
            
            let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(buttonNavBackBarAction(_:)))
            self.navigationItem.leftBarButtonItem = leftBarButton
        }
        
    //    Back Bar Button Action
        @objc func buttonNavBackBarAction(_ sender : UIButton) -> Void {
            
            if self.isMovedFromThankyouPage {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: HomeViewController.self) {
                        controller.navigationController?.setNavigationBarHidden(false, animated: false)
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    
//    filter items list according to the current orderID
    func filterArrayAccordingToOrderID() -> Array<Dictionary<String, String>> {
        var arrayFiltered = Array<Dictionary<String, String>>()
        for item in arrayGlobalPayLaterList {
            if item[JSONKey.ORDER_ID]! == self.selectedOrderID {
                arrayFiltered.append(item)
            }
        }
        return arrayFiltered
    }
    
//    setup Footer view
    func setupTableViewFooter() -> UIView {
        
        let viewFooter = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.screenWidth, height: 45))
        viewFooter.backgroundColor = .clear
        
        let xposition = (self.screenWidth / 2) - 75
        let buttonAddMore = UIButton.init(frame: CGRect.init(x: xposition, y: 5.0, width: 150, height: 35))
        buttonAddMore.setTitleColor(Colors.colorWithHexString(Colors.GREEN_COLOR), for: .normal)
        buttonAddMore.setTitle("Add More", for: .normal)
        buttonAddMore.addTarget(self, action: #selector(self.buttonAddMoreAction(_:)), for: .touchUpInside)
        UtilityMethods.addBorder(buttonAddMore, Colors.colorWithHexString(Colors.GREEN_COLOR), 5.0)
        viewFooter.addSubview(buttonAddMore)
        
        return viewFooter
    }
    
//    Func calculate the tax for  7%
    func calculate7PercentTax() -> String {
        
        if self.arrayOrderList.count == 1 {
            return "0.00"
        }
        var total7PercentAmount = Double()
        let arrayCartItems = self.arrayOrderList[1]
        for cartItem in arrayCartItems {
            if cartItem[JSONKey.ITEM_FOOD_TAX_APPLICABLE] == ConstantStrings.FOOD_TAX_7 {
                
                total7PercentAmount += (Double(cartItem[JSONKey.ITEM_CART_PRICE]!) != nil) ? Double(cartItem[JSONKey.ITEM_CART_PRICE]!)! : 0.00
            }
        }
        
        let percentage = (Double(ConstantStrings.FOOD_TAX_7) != nil) ? Double(ConstantStrings.FOOD_TAX_7)! : 0.00
        let calculatedValue = (total7PercentAmount * percentage) / 100.0
        
        print("Total\(total7PercentAmount) value \(percentage)% amount of \(calculatedValue)")
        return String(format: "%.2f", calculatedValue)
    }
    
//    Calculate total food offer amount without any discount
    func calculateTotalOfferFoodAmount() -> Double {
        
        if self.arrayOrderList.count == 1 {
            return 0.00
        }
        var totalAmount = Double()
        let arrayCartItems = self.arrayOrderList[1]
        for itemDetails in arrayCartItems {
            
            totalAmount += Double(itemDetails[JSONKey.ITEM_CART_PRICE]!)!
        }
        
        return totalAmount
    }
    
//    Calculate the total food amount with extra topping
    func calculateTotalFoodAmountWithExtraTopping() -> Double {
        
        if self.arrayOrderList.count == 1 {
            return 0.00
        }
        var totalAmount = Double()
        let arrayCartItems = self.arrayOrderList[1]
        for itemDetails in arrayCartItems {
            
            totalAmount += (Double(itemDetails[JSONKey.ITEM_CART_PRICE]!)! + (Double(itemDetails[JSONKey.ITEM_EXTRA_PRICE]!)! * Double(itemDetails[JSONKey.ITEM_QUANTITY]!)!))
        }
        
        return totalAmount
    }
    
//    Calculate total food original amount without any discount
    func calculateTotalOriginalFoodAmount() -> Double {
        
        if self.arrayOrderList.count == 1 {
            return 0.00
        }
        var totalOriginalAmount = Double()
        let arrayCartItems = self.arrayOrderList[1]
        for itemDetails in arrayCartItems {
            
            totalOriginalAmount += Double(itemDetails[JSONKey.ITEM_CART_ORIGINAL_PRICE]!)!
        }
        
        return totalOriginalAmount
    }
    
//    Calculate the total food discount
    func calculateTotalFoodDiscount() -> Double {
        
        let totalOfferAmount = self.calculateTotalOfferFoodAmount()
        let totalOriginalPrice = self.calculateTotalOriginalFoodAmount()
        
        if totalOfferAmount < totalOriginalPrice {
            
            return totalOriginalPrice - totalOfferAmount
        }else {
            
            return 0.00
        }
    }
    
//    Func calculate the tax for  19%
    func calculate19PercentTax() -> String {
        
        if self.arrayOrderList.count == 1 {
            return "0.00"
        }
        var total19PercentAmount = Double()
        let arrayCartItems = self.arrayOrderList[1]
        for cartItem in arrayCartItems {
            if cartItem[JSONKey.ITEM_FOOD_TAX_APPLICABLE] == ConstantStrings.FOOD_TAX_19 {
                
                total19PercentAmount += (Double(cartItem[JSONKey.ITEM_CART_PRICE]!) != nil) ? Double(cartItem[JSONKey.ITEM_CART_PRICE]!)! : 0.00
            }
        }
        
        let percentage = (Double(ConstantStrings.FOOD_TAX_19) != nil) ? Double(ConstantStrings.FOOD_TAX_19)! : 0.00
        let calculatedValue = (total19PercentAmount * percentage) / 100.0
        
        print(print("Total\(total19PercentAmount) value \(percentage)% amount of \(calculatedValue)"))
        return String(format: "%.2f", calculatedValue)
    }
    
//    button Add More Action
    @objc func buttonAddMoreAction(_ sender : UIButton) -> Void {
        
        print("Footer button clicked...")
        isMovedFromPayLaterDetailsPage = true
        selectedPayLaterGlobalOrderID = self.selectedOrderID
        self.moveOnMenuPage()
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
        
        return self.arrayOrderList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayOrderList[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 0
        }else {
            
            return 20.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            return UIView()
        }else {
            
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.screenWidth, height: 20))
            headerView.backgroundColor = .white
            
            let label = UILabel.init(frame: CGRect.init(x: 25, y: 0, width: self.screenWidth - 50, height: 20))
            label.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
            label.text = ConstantStrings.NEW_ITEM_ADDED
            label.textColor = .black
            headerView.addSubview(label)
            
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = Bundle.main.loadNibNamed("OrderDetailsTableViewCell", owner: self, options: nil)?.first as! OrderDetailsTableViewCell
            cell.selectionStyle = .none
            
            let arrayProductList = self.arrayOrderList[indexPath.section]
            let dictionary = arrayProductList[indexPath.row]
            cell.labelItemName.text = dictionary[JSONKey.ORDER_ITEM_NAME]
            cell.labelDescription.text = dictionary[JSONKey.ORDER_ITEM_SIZE]
            cell.labelQuantity.text = "\(ConstantStrings.RUPEES_SYMBOL + dictionary[JSONKey.ORDER_ITEM_PRICE]!) x \(dictionary[JSONKey.ORDER_ITEM_QUANTITY]!)"
            
            return cell
        }else {
            let cell = Bundle.main.loadNibNamed("CartTableViewCell", owner: self, options: nil)?.first as! CartTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.indexPath = indexPath
            
            let arrayNewItemList = self.arrayOrderList[indexPath.section]
            let dictionary = arrayNewItemList[indexPath.row]
            cell.labelCount.text = dictionary[JSONKey.ITEM_QUANTITY]
            cell.labelMenuName.text = dictionary[JSONKey.ITEM_NAME]?.trim()
            cell.labelMenuDescription.text = dictionary[JSONKey.ITEM_DESCRIPTION]?.trim()
            let totalFoodAmount = Double(dictionary[JSONKey.ITEM_CART_PRICE]!)! + (Double(dictionary[JSONKey.ITEM_EXTRA_PRICE]!)! * Double(dictionary[JSONKey.ITEM_QUANTITY]!)!)
            cell.labelPrice.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", totalFoodAmount)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
//    func reload tableView
    func reloadTableView() -> Void {
        
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.setNeedsLayout()
        }
    }
    
    //    MARK:- Button Action
    @IBAction func buttonConfirmAndPayClickAction(_ sender: UIButton) {
        let paymentVC = PayNowPaymentViewController.init(nibName: "PayNowPaymentViewController", bundle: nil)
        paymentVC.orderPlaceUrl = self.setupUrlAndValueForOrderPlace()
        paymentVC.orderDetails = self.orderDetails
        paymentVC.selectedOrderID = self.selectedOrderID
        paymentVC.totalAmount = String(self.labelTotalAmount.text!.dropFirst(1))
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    //    Setup Url and Value for order place
    func setupUrlAndValueForOrderPlace() -> String {
        
        var itemID = String()
        var itemQuantity = String()
        var itemPrice = String()
        var itemSizeID = String()
        var itemExtraID = String()
        let serviceFeesAmount = String(self.labelServiceFeesAmount.text!.dropFirst(1))
        let packageFeesAmount = String(self.labelPackageFeesAmount.text!.dropFirst(1))
        let saleTaxAmount = String(self.labelSaleTaxAmount.text!.dropFirst(1))
        let vatTaxAmount = String(self.labelVatTaxAmount.text!.dropFirst(1))
        let tipAmount = String(self.labelRiderTipAmount.text!.dropFirst(1))
        let subTotalAmount = String(self.labelSubTotalAmount.text!.dropFirst(1))
        let restaurantDiscountAmount = String(self.labelRestaurantDiscountAmount.text!.dropFirst(1))
        let deliveryChargeAmount = String(self.labelRestaurantDiscountAmount.text!.dropFirst(1))
        var customerID = self.userDetails.userID
        let totalAmount = String(self.labelTotalAmount.text!.dropFirst(1))
        var couponAmount = ""
        let paymentProcessigFees = "0"
        var loyaltyPoints = String()
        var loyaltyPointsAmount = String()
        let foodCost = ""
        let getTotalItemDiscount = ""
        let getFoodTaxTotal7 = self.calculate7PercentTax()
        let getFoodTaxTotal19 = self.calculate19PercentTax()
        let discountOfferFreeItems = "0"
        let totalSavedDiscount = ""
        
        loyaltyPoints = ""
        loyaltyPointsAmount = ""
        couponAmount = ""
        let tableID = ""
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "hh:mm a"
        let currentTime = dateFormatter.string(from: date)
        var arrayCartItems = Array<Dictionary<String, String>>()
        if self.arrayOrderList.count > 1 {
            
            arrayCartItems = self.arrayOrderList[1]
        }else {
            
            return ""
        }
        for itemDetails in arrayCartItems {
            
            if itemID.isEmpty {
                
                itemID = itemDetails[JSONKey.ITEM_ID]!
                itemQuantity = itemDetails[JSONKey.ITEM_QUANTITY]!
                itemPrice = itemDetails[JSONKey.ITEM_OFFER_PRICE]!
                if !(itemDetails[JSONKey.ITEM_SIZE_ID]?.isEmpty)! {
                    
                    if itemSizeID.isEmpty {
                        
                        itemSizeID = "\(itemID)_\(itemDetails[JSONKey.ITEM_SIZE_ID]!)"
                    }else {
                        
                        itemSizeID.append(",\(itemID)_\(itemDetails[JSONKey.ITEM_SIZE_ID]!)")
                    }
                }
                if !(itemDetails[JSONKey.ITEM_EXTRA_ID]?.isEmpty)! {
                    
                    let arrayExtraIDs = itemDetails[JSONKey.ITEM_EXTRA_ID]!.components(separatedBy: "|")
                    for extraID in arrayExtraIDs {
                        
                        if itemExtraID.isEmpty {
                            
                            itemExtraID = "\(itemID)_\(extraID)"
                        }else {
                            
                            itemExtraID.append(",\(itemID)_\(extraID)")
                        }
                    }
                }
            }else {
                
                let selectedItemId = itemDetails[JSONKey.ITEM_ID]!
                itemID.append(",\(selectedItemId)")
                itemQuantity.append(",\(itemDetails[JSONKey.ITEM_QUANTITY]!)")
                itemPrice.append(",\(itemDetails[JSONKey.ITEM_OFFER_PRICE]!)")
                if !(itemDetails[JSONKey.ITEM_SIZE_ID]?.isEmpty)! {
                    
                    if itemSizeID.isEmpty {
                        
                        itemSizeID = "\(selectedItemId)_\(itemDetails[JSONKey.ITEM_SIZE_ID]!)"
                    }else {
                        
                        itemSizeID.append(",\(selectedItemId)_\(itemDetails[JSONKey.ITEM_SIZE_ID]!)")
                    }
                }
                if !(itemDetails[JSONKey.ITEM_EXTRA_ID]?.isEmpty)! {
                    
                    let arrayExtraIDs = itemDetails[JSONKey.ITEM_EXTRA_ID]!.components(separatedBy: "|")
                    for extraID in arrayExtraIDs {
                        
                        if itemExtraID.isEmpty {
                            
                            itemExtraID = "\(selectedItemId)_\(extraID)"
                        }else {
                            
                            itemExtraID.append(",\(selectedItemId)_\(extraID)")
                        }
                    }
                }
            }
        }
        
        if userDetails.userID.isEmpty {
            
            if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
                
                self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
                customerID = self.userDetails.userID
            }
        }
        
        let url = WebApi.BASE_URL + "phpexpert_payment_pay_later.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&payment_transaction_paypal=&mealID=&mealquqntity=&mealPrice=&itemId=\(itemID)&Quantity=\(itemQuantity)&Price=\(itemPrice)&strsizeid=\(itemSizeID)&extraItemID=\(itemExtraID)&CustomerId=\(customerID)&CustomerAddressId=&payment_type=PAYMENT_TYPE_STRING&order_price=\(totalAmount)&subTotalAmount=\(subTotalAmount)&delivery_date=\(currentDate)&delivery_time=\(currentTime)&instructions=&deliveryCharge=\(deliveryChargeAmount)&CouponCode=&CouponCodePrice=\(couponAmount)&couponCodeType=&SalesTaxAmount=\(saleTaxAmount)&order_type=\(ConstantStrings.ORDER_TYPE_DINING_STRING)&SpecialInstruction=&extraTipAddAmount=\(tipAmount)&RestaurantNameEstimate=&discountOfferDescription=&discountOfferPrice=\(restaurantDiscountAmount)&RestaurantoffrType=&ServiceFees=\(serviceFeesAmount)&PaymentProcessingFees=\(paymentProcessigFees)&deliveryChargeValueType=&ServiceFeesType=&PackageFeesType=&PackageFees=\(packageFeesAmount)&WebsiteCodePrice=&WebsiteCodeType=&WebsiteCodeNo=&preorderTime=&VatTax=\(vatTaxAmount)&GiftCardPay=&WalletPay=&loyptamount=\(loyaltyPointsAmount)&table_number_assign=\(tableID)&customer_country=&group_member_id=&loyltPnts=\(loyaltyPoints)&branch_id=&FoodCosts=\(foodCost)&getTotalItemDiscount=\(getTotalItemDiscount)&getFoodTaxTotal7=\(getFoodTaxTotal7)&getFoodTaxTotal19=\(getFoodTaxTotal19)&TotalSavedDiscount=\(totalSavedDiscount)&discountOfferFreeItems=\(discountOfferFreeItems)&order_identifyno=\(self.selectedOrderID)"
        print("Url for place order : ", url)
        return url
    }
    
    //    MARK:- Web Code Start
//    Web api for fetch order details
    func webApiFetchOrderDetails() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_Order_DetailsDisplay.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&order_identifyno=\(self.selectedOrderID)"
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
                
                self.labelSubTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_SUBTOTAL]!
                self.labelDeliveryCostAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_DELIVERY_AMOUNT]!
                self.labelPackageFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_PACKAGE_AMOUNT]!
                self.labelServiceFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_SERVICE_AMOUNT]!
                self.labelSaleTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_SALE_TAX]!
                self.labelVatTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_VAT_TAX]!
                self.labelRiderTipAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_TIP_AMOUNT]!
                self.labelStatus.text = ""
                self.labelFoodTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_FOOD_TAX_7]!
                self.labelDrinkTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_DRINK_TAX_19]!
                self.calculateAndSetupTotalAmount()
                self.setupAllBillDetailsView()
            }
        }
        
        if jsonDictionary[JSONKey.ORDER_FOOD_ITEM_LIST] as? Array<Dictionary<String, Any>> != nil {
            
            let arrayFoodOrderList = jsonDictionary[JSONKey.ORDER_FOOD_ITEM_LIST] as! Array<Dictionary<String, Any>>
            
            var arrayProductList = Array<Dictionary<String, String>>()
            for foodDetails in arrayFoodOrderList {
                
                var itemDetails = Dictionary<String, String>()
                itemDetails[JSONKey.ORDER_ITEM_NAME] = (foodDetails[JSONKey.ORDER_ITEM_NAME] as? String != nil) ? (foodDetails[JSONKey.ORDER_ITEM_NAME] as! String) : ""
                itemDetails[JSONKey.ORDER_ITEM_EXTRATOPING] = (foodDetails[JSONKey.ORDER_ITEM_EXTRATOPING] as? String != nil) ? (foodDetails[JSONKey.ORDER_ITEM_EXTRATOPING] as! String) : ""
                itemDetails[JSONKey.ORDER_ITEM_PRICE] = (foodDetails[JSONKey.ORDER_ITEM_PRICE] as? String != nil) ? (foodDetails[JSONKey.ORDER_ITEM_PRICE] as! String) : ""
                itemDetails[JSONKey.ORDER_ITEM_QUANTITY] = (foodDetails[JSONKey.ORDER_ITEM_QUANTITY] as? Int != nil) ? String(foodDetails[JSONKey.ORDER_ITEM_QUANTITY] as! Int) : ""
                itemDetails[JSONKey.ORDER_ITEM_CURRENCY] = (foodDetails[JSONKey.ORDER_ITEM_CURRENCY] as? String != nil) ? (foodDetails[JSONKey.ORDER_ITEM_CURRENCY] as! String) : ""
                itemDetails[JSONKey.ORDER_ITEM_SIZE] = (foodDetails[JSONKey.ORDER_ITEM_SIZE] as? String != nil) ? (foodDetails[JSONKey.ORDER_ITEM_SIZE] as! String) : ""
                
                arrayProductList.append(itemDetails)
            }
            self.arrayOrderList.append(arrayProductList)
//            if payLaterGlobalOrderID == self.orderDetails[JSONKey.ORDER_ID]! {
                if arrayGlobalPayLaterList.count > 0 {
                    let arrayFiltered = self.filterArrayAccordingToOrderID()
                    if self.arrayOrderList.count > 1 {
                        self.arrayOrderList[1] = arrayFiltered
                    }else {
                        self.arrayOrderList.append(arrayFiltered)
                    }
                }
//            }
            self.tableView.tableFooterView = self.setupTableViewFooter()
            if self.arrayOrderList.count > 1 {
                self.callGetRestaurantService()
            }
            self.reloadTableView()
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
        if self.labelRestaurantDiscountAmount.text!.isEmpty || self.labelRestaurantDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelRestaurantDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelRestaurantDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewRestaurantDiscount, self.labelRestaurantDiscount, self.labelRestaurantDiscountAmount, self.heightRestaurantDiscountView)
        }else {
            
            self.showViewWith(self.viewRestaurantDiscount, self.labelRestaurantDiscount, self.labelRestaurantDiscountAmount, self.heightRestaurantDiscountView)
        }
        if self.labelNewFoodItemAmount.text!.isEmpty || self.labelNewFoodItemAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelNewFoodItemAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelNewFoodItemAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewNewFoodItem, self.labelNewFoodItem, self.labelNewFoodItemAmount, self.heightViewNewFoodItem)
        }else {
            
            self.showViewWith(self.viewNewFoodItem, self.labelNewFoodItem, self.labelNewFoodItemAmount, self.heightViewNewFoodItem)
        }
        if self.labelNewFoodDiscountAmount.text!.isEmpty || self.labelNewFoodDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelNewFoodDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelNewFoodDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewNewFoodDiscount, self.labelNewFoodDiscount, self.labelNewFoodDiscountAmount, self.heightViewNewFoodDiscount)
        }else {
            
            self.showViewWith(self.viewNewFoodDiscount, self.labelNewFoodDiscount, self.labelNewFoodDiscountAmount, self.heightViewNewFoodDiscount)
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
        let foodTax = (Double(self.labelFoodTaxAmount.text!.dropFirst(1)) != nil) ? Double(self.labelFoodTaxAmount.text!.dropFirst(1))! : 0.0
        let drinkTax = (Double(self.labelDrinkTaxAmount.text!.dropFirst(1)) != nil) ? Double(self.labelDrinkTaxAmount.text!.dropFirst(1))! : 0.0
        
        let totalPayableAmount = subtotal + deliveryCost + packageFees + serviceFees + saleTax + vatTax + tipAmount + foodTax + drinkTax
        self.labelTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", totalPayableAmount)
    }
    
//    Get Restaurant discount the price
    func webApiGetRestaurantDiscount(_ subTotal : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        let url = WebApi.BASE_URL + "discountGet.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&subTotal=\(subTotal)&Order_Type=\(ConstantStrings.ORDER_TYPE_DINING_STRING)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupARestaurantDiscount(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup And restaurant discount
    func setupARestaurantDiscount(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int != 0 {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    self.showToastWithMessage(self.view, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }
        }else {
            
            if jsonDictionary["discountOfferPrice"] as? String != nil {
                
                let stringRestaurantDiscount = (Double(jsonDictionary["discountOfferPrice"] as! String) != nil) ? Double(jsonDictionary["discountOfferPrice"] as! String)! : 0.00
//                let stringRestaurantDiscount = jsonDictionary["discountOfferPrice"] as! String
                self.labelRestaurantDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", stringRestaurantDiscount)
//                self.calculateAndSetupBillDetails()
                print("Restaurant Discount : ", self.labelRestaurantDiscountAmount.text!)
                let calculatedNewSubTotal = Double(self.newFoodItemAmount)! - stringRestaurantDiscount
                self.newSubTotalAmount = String(format : "%.2f", calculatedNewSubTotal)
                let totalSubTotal = Double(self.orderBillDetails[JSONKey.ORDER_SUBTOTAL]!)! + calculatedNewSubTotal
                self.labelSubTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", totalSubTotal)
                self.webApiGetServiceCharge(self.newSubTotalAmount)
            }
        }
    }
    
//    Get service charge of the price
    func webApiGetServiceCharge(_ subTotal : String) -> Void {
        
        //        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "ServiceChargetGet.php?subTotal=\(subTotal)&api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&restaurant_locality&Order_Type=\(ConstantStrings.ORDER_TYPE_DINING_STRING)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupServiceCharges(json.dictionaryObject!)
                }
            }
        }
    }
    
//    self.labelSubTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_SUBTOTAL]!
//    self.labelDeliveryCostAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_DELIVERY_AMOUNT]!
//    self.labelPackageFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_PACKAGE_AMOUNT]!
//    self.labelServiceFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_SERVICE_AMOUNT]!
//    self.labelSaleTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_SALE_TAX]!
//    self.labelVatTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.orderBillDetails[JSONKey.ORDER_VAT_TAX]!
    
    func setupServiceCharges(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary["deliveryChargeValue"] as? String != nil {
            
//            let deliveryAmount = (Double(jsonDictionary["deliveryChargeValue"] as! String) != nil) ? Double(jsonDictionary["deliveryChargeValue"] as! String)! : 0.00
//            self.labelDeliveryCostAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", deliveryAmount)
            self.labelDeliveryCostAmount.text = ConstantStrings.RUPEES_SYMBOL + "0.00"
            self.hideViewWith(self.viewDeliveryValue, self.labelDeliveryCost, self.labelDeliveryCostAmount, self.heightDeliveryView)
        }else {
            
            self.hideViewWith(self.viewDeliveryValue, self.labelDeliveryCost, self.labelDeliveryCostAmount, self.heightDeliveryView)
        }
        if jsonDictionary["SeviceFeesValue"] as? String != nil {
            
            var amount = (Double(jsonDictionary["SeviceFeesValue"] as! String) != nil) ? Double(jsonDictionary["SeviceFeesValue"] as! String)! : 0.00
            if self.arrayOrderList.count == 1 {
                
                amount = 0.00
            }
            let totalAmount = amount + Double(self.orderBillDetails[JSONKey.ORDER_SERVICE_AMOUNT]!)!
            self.labelServiceFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", totalAmount)
        }else {
            
            self.hideViewWith(self.viewServiceFees, self.labelServiceFees, self.labelServiceFeesAmount, self.heightServiceFeesView)
        }
        if jsonDictionary["PackageFeesValue"] as? String != nil {
            
            var amount = (Double(jsonDictionary["PackageFeesValue"] as! String) != nil) ? Double(jsonDictionary["PackageFeesValue"] as! String)! : 0.00
            if self.arrayOrderList.count == 1 {
                
                amount = 0.00
            }
            let totalAmount = amount + Double(self.orderBillDetails[JSONKey.ORDER_PACKAGE_AMOUNT]!)!
            self.labelPackageFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", totalAmount)
        }else {
            
            self.hideViewWith(self.viewPackageFees, self.labelPackageFees, self.labelPackageFeesAmount, self.heightPackageFeesView)
        }
        if jsonDictionary["SalesTaxAmount"] as? String != nil {
            
            var amount = (Double(jsonDictionary["SalesTaxAmount"] as! String) != nil) ? Double(jsonDictionary["SalesTaxAmount"] as! String)! : 0.00
            if self.arrayOrderList.count == 1 {
                
                amount = 0.00
            }
            let totalAmount = amount + Double(self.orderBillDetails[JSONKey.ORDER_SALE_TAX]!)!
            self.labelSaleTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", totalAmount)
        }else {
            
            self.hideViewWith(self.viewSaleTax, self.labelSaleTax, self.labelSaleTaxAmount, self.heightSaleTaxView)
        }
        if jsonDictionary["VatTax"] as? String != nil {
            
            var amount = (Double(jsonDictionary["VatTax"] as! String) != nil) ? Double(jsonDictionary["VatTax"] as! String)! : 0.00
            if self.arrayOrderList.count == 1 {
                
                amount = 0.00
            }
            let totalAmount = amount + Double(self.orderBillDetails[JSONKey.ORDER_VAT_TAX]!)!
            self.labelVatTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", totalAmount)
        }else {
            
            self.hideViewWith(self.viewVatTax, self.labelVatTax, self.labelVatTaxAmount, self.heightVatTaxView)
        }
        self.labelNewFoodItemAmount.text = ConstantStrings.RUPEES_SYMBOL + self.newFoodItemAmount
        self.labelNewFoodDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + self.newFoodItemDiscount
        self.labelFoodTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.newFoodTax
        self.labelDrinkTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.newDrinkTax
        
//        Hide Or show view for value
        self.calculateAndSetupTotalAmount()
        self.setupAllBillDetailsView()
        print("Get Service Charge Callled...")
    }
}
