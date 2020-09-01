//
//  CartViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import MBProgressHUD
import CNPPopupController

var isAddingItemToCart = Bool()
protocol CartValueUpdatedDelegate : class {
    
    func cartValueChanged(_ itemDictionary : Dictionary<String, String>)
}

class CartViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ModifyCartItemCountDelegate, CNPPopupControllerDelegate, BookTableDelegate, CLLocationManagerDelegate {
    
    func bookSelectedTable(_ tableID : String) {
        self.labelCheckout.text = ConstantStrings.SEND_ORDER_TO_KITCHEN
        if self.kitchenOrderID.isEmpty {
            self.tableView.tableFooterView = UIView()
        }else {
            self.tableView.tableFooterView = self.setupTableViewFooter()
        }
        self.selectedTableID = tableID
        UserDefaultOperations.setStringObject(ConstantStrings.SELECTED_TABLE_NUMBER, tableID)
        self.orderType = self.DINING_TYPE
        self.collectionView.reloadData()
        UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, self.orderType)
        self.webApiGetRestaurantDiscount(String(self.labelFoodItemAmount.text!.dropFirst(1)), self.orderType)
    }
    
    @IBOutlet weak var viewEmptyCart: UIView!
    @IBOutlet weak var labelWoops: UILabel!
    @IBOutlet weak var labelEmptyCart: UILabel!
    @IBOutlet weak var labelEmptyCartDetails: UILabel!
    @IBOutlet weak var labelLoyaltyPoints: UILabel!
    
    @IBOutlet weak var labelOrderType: UILabel!
    @IBOutlet weak var labelOrderTypeTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var heightTableViewBg: NSLayoutConstraint!
    @IBOutlet weak var viewApplyCoupon: UIView!
    @IBOutlet weak var viewBillDetails: UIView!
    @IBOutlet weak var viewTip: UIView!
    
    @IBOutlet weak var button10: UIButton!
    @IBOutlet weak var button20: UIButton!
    @IBOutlet weak var button30: UIButton!
    @IBOutlet weak var button40: UIButton!
    @IBOutlet weak var button50: UIButton!
    
    @IBOutlet weak var labelApplyCoupon: UILabel!
    @IBOutlet weak var labelRedeemLoyalityPoint: UILabel!
    @IBOutlet weak var labelBillDetails: UILabel!
    @IBOutlet weak var labelFoodItem: UILabel!
    @IBOutlet weak var labelFoodItemAmount: UILabel!
    @IBOutlet weak var labelDeliveryFee: UILabel!
    @IBOutlet weak var labelDeliveryFeesAmount: UILabel!
    @IBOutlet weak var labelTotalDiscount: UILabel!
    @IBOutlet weak var labelTotalDiscountAmount: UILabel!
    @IBOutlet weak var labelRestaurantDiscount: UILabel!
    @IBOutlet weak var labelRestaurantDiscountAmount: UILabel!
    @IBOutlet weak var labelTotalFoodDiscount: UILabel!
    @IBOutlet weak var labelTotalFoodDiscountAmount: UILabel!
    @IBOutlet weak var labelTotalCouponDiscount: UILabel!
    @IBOutlet weak var labelTotalCouponDiscountAmount: UILabel!
    @IBOutlet weak var labelSubtotal: UILabel!
    @IBOutlet weak var labelSubtotalAmount: UILabel!
    @IBOutlet weak var viewRedeemLoyalityPoint: UIView!
    @IBOutlet weak var labelRiderTipAmount: UILabel!
    @IBOutlet weak var labelRiderTip: UILabel!
    @IBOutlet weak var labelServiceFees: UILabel!
    @IBOutlet weak var labelServiceFeesAmount: UILabel!
    @IBOutlet weak var labelPackageFees: UILabel!
    @IBOutlet weak var labelPackageFeesAmount: UILabel!
    @IBOutlet weak var labelSaleTax: UILabel!
    @IBOutlet weak var labelSaleTaxAmount: UILabel!
    @IBOutlet weak var labelVatTax: UILabel!
    @IBOutlet weak var labelVatTaxAmount: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    
    @IBOutlet weak var labelToPay: UILabel!
    @IBOutlet weak var labelPayableAmount: UILabel!
    @IBOutlet weak var labelRiderTipTitle: UILabel!
    @IBOutlet weak var labelTipPrice: UILabel!
    @IBOutlet weak var labelTotalPay: UILabel!
    @IBOutlet weak var labelTotalPayAmount: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewSubtotal: UIView!
    @IBOutlet weak var buttonCheckout: UIButton!
    
    @IBOutlet var viewPopupApplyCoupon: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var buttonApply: UIButton!
    @IBOutlet weak var textFieldApplyCoupon: UITextField!
    @IBOutlet weak var labelApplyCouponTitle: UILabel!
    
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
    
    @IBOutlet weak var viewRestaurantDiscount: UIView!
    @IBOutlet weak var heightRestaurantDiscountView: NSLayoutConstraint!
    @IBOutlet weak var viewFoodDiscount: UIView!
    @IBOutlet weak var heightFoodDiscountView: NSLayoutConstraint!
    @IBOutlet weak var viewCouponDiscount: UIView!
    @IBOutlet weak var heightCouponDiscountView: NSLayoutConstraint!
    @IBOutlet weak var viewTotalDiscount: UIView!
    @IBOutlet weak var heightTotalDiscountView: NSLayoutConstraint!
    @IBOutlet weak var viewRiderTip: UIView!
    @IBOutlet weak var heightRiderTipView: NSLayoutConstraint!
    @IBOutlet weak var viewLoyaltyPoints: UIView!
    @IBOutlet weak var heightLoyaltyPointView: NSLayoutConstraint!
    @IBOutlet weak var labelLoyaltyPoint: UILabel!
    @IBOutlet weak var labelLoyaltyPointAmount: UILabel!
    @IBOutlet weak var heightApplyCouponView: NSLayoutConstraint!
    @IBOutlet weak var topMarginApplyCoupon: NSLayoutConstraint!
    @IBOutlet weak var labelCheckout: UILabel!
    
    //    For Postal code popup View
    @IBOutlet var viewPostalCode: UIView!
    @IBOutlet weak var labelPostalCode: UILabel!
    @IBOutlet weak var textFieldPostalCode: UITextField!
    @IBOutlet weak var buttonSubmitPostalCode: UIButton!
    @IBOutlet weak var topMarginRedeemPoint: NSLayoutConstraint!
    @IBOutlet weak var heightRedeemPoint: NSLayoutConstraint!
    @IBOutlet weak var viewBottomPostalCode: UIView!
    @IBOutlet weak var viewPostalTextField: UIView!
    @IBOutlet weak var heightPostalTextFieldView: NSLayoutConstraint!
    @IBOutlet weak var viewPostalContainer: UIView!
    
    @IBOutlet var viewSelectTable: UIView!
    @IBOutlet weak var imageViewSelectTable: UIImageView!
    @IBOutlet weak var imageViewScanner: UIImageView!
    @IBOutlet weak var buttonSelectTableSubmit: UIButton!
    @IBOutlet weak var labelScanQRCode: UILabel!
    @IBOutlet weak var labelSelectTableNumber: UILabel!
    @IBOutlet weak var labelSelectOption: UILabel!
    
    @IBOutlet var viewLoyaltyPointsPopup: UIView!
    @IBOutlet weak var labelLoyaltyPointsCount: UILabel!
    @IBOutlet weak var textFieldLoyaltyPoints: UITextField!
    @IBOutlet weak var buttonRedeem: UIButton!
    @IBOutlet weak var labelFoodTax: UILabel!
    @IBOutlet weak var labelFoodTaxAmount: UILabel!
    @IBOutlet weak var labelDrinkTax: UILabel!
    @IBOutlet weak var labelDrinkTaxAmount: UILabel!
    @IBOutlet weak var heightDrinkTax: NSLayoutConstraint!
    @IBOutlet weak var heightFoodTax: NSLayoutConstraint!
    @IBOutlet weak var viewDrinkTax: UIView!
    @IBOutlet weak var viewFoodTax: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var collectionViewPopup: UICollectionView!
    @IBOutlet weak var labelRedeemLoyaltyPointsTitle: UILabel!
    
    var isNewItemAdded = Bool()
    var kitchenOrderID = String()
    var orderTypeString = String()
    var isMovedOutFromCart = Bool()
    var minimumOrderLimit = Double()
    var buttonPostalCode = UIButton()
    var stringDeliveryCharge = String()
    let locationManager = CLLocationManager()
    var currentLocationLatitude = Double()
    var currentLocationLongitude = Double()
    
    let POPUP_VIEW_HEIGHT : CGFloat = 186
    let DINING_VIEW_HEIGHT : CGFloat = 187.0
    let VIEW_BILL_VALUE_MIN_HEIGHT : CGFloat = 0
    let VIEW_BILL_VALUE_MAX_HEIGHT : CGFloat = 28
    let HEIGHT_POSTAL_CODE_VIEW : CGFloat = 270.0
    let POSTAL_TEXT_FIELD_VIEW_HEIGHT : CGFloat = 76.5
    let LOYALTY_POINTS_POP_UP_HEIGHT : CGFloat = 199.5
    var height : CGFloat = 230.0
    
    let SELECTED_BRANCH_ID = "SELECTED_BRANCH_ID"
    let ORDER_TYPE_STRING_VALUE = "orderTypeStringValue"
    let ORDER_TYPE_IMAGE = "orderTypeImage"
    let ORDER_TYPE_NAME = "orderTypeName"
    let ORDER_TYPE_ID = "orderTypeId"
    let DELIVERY_IMAGE = "delivery_type"
    let PICK_UP_IMAGE = "pickup"
    let EAT_IN_IMAGE = "dining"
    let ORDER_TYPE_CELL = "OrderTypeCell"
    let ORDER_TYPE_POPUP_CELL = "OrderTypePopupCell"
    let DELIVER_STRING = "Delivery"
    let PICKUP_STRING = "Pickup"
    let DINING_STRING = "EAT-IN"
    let DELIVERY_TYPE = 1
    let PICKUP_TYPE = 2
    let DINING_TYPE = 3
    var INITIAL_VALUE = "0.00"
    
    let PERCENTAGE_10 = 10.0
    let PERCENTAGE_20 = 20.0
    let PERCENTAGE_30 = 30.0
    let PERCENTAGE_40 = 40.0
    let PERCENTAGE_50 = 50.0
    
    var selectedTableID = String()
    var couponCode = String()
    var isDeletedCell = true
    var userDetails = UserDetails()
    var restaurantInfo = RestaurantInfo()
    var button = UIButton()
    var riderTip = Double()
    var orderType = 0
    var popupController:CNPPopupController?
    weak var delegate : CartValueUpdatedDelegate?
    var popDiningController : CNPPopupController?
    var popLoyaltyPointsController : CNPPopupController?
    var arrayCartItems = Array<Dictionary<String, String>>()
    var arrayOrderType = Array<Dictionary<String, Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewDidLayoutSubviews() {
        
        if self.isDeletedCell {
            
            super.viewDidLayoutSubviews()
            let height = self.tableView.contentSize.height
            self.heightTableView.constant = height
            self.view.layoutIfNeeded()
        }
        self.viewBillDetails.frame = self.viewBillDetails.frame
        UtilityMethods.addBorderAndShadow(self.viewBillDetails, 5.0)
        
        let height = self.collectionView.contentSize.height
        self.heightCollectionView.constant = height
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isAddingItemToCart {
            isAddingItemToCart = true
        }
        self.setupRedeemLoyaltyPointView()
        let arrayNewItemList = self.filterNewAddedItemInCartForSendOrder()
        if UserDefaultOperations.getIntValue(ConstantStrings.ORDER_TYPE_VALUE) == ConstantStrings.ORDER_TYPE_DINING {
            if self.isMovedOutFromCart && (arrayNewItemList.count > 0) {
                self.setupViewDidLoadMethod()
                self.tableView.reloadData()
            }
//            if (!self.kitchenOrderID.isEmpty && (arrayNewItemList.count > 0)) || ((arrayNewItemList.count == 0) && self.kitchenOrderID.isEmpty) {
            if self.kitchenOrderID.isEmpty {
                self.labelCheckout.text = ConstantStrings.SEND_ORDER_TO_KITCHEN
            }else if arrayNewItemList.count > 0 {
                self.labelCheckout.text = ConstantStrings.SEND_ORDER_TO_KITCHEN
            }else {
                self.labelCheckout.text = (self.appDelegate.languageData["Checkout"] as? String != nil) ? (self.appDelegate.languageData["Checkout"] as! String).trim() : "Checkout"
            }
        }else {
            self.labelCheckout.text = (self.appDelegate.languageData["Checkout"] as? String != nil) ? (self.appDelegate.languageData["Checkout"] as! String).trim() : "Checkout"
        }
    }
    
    func setupRedeemLoyaltyPointView() -> Void {
        
        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
            if UserDefaultOperations.getBoolObject(ConstantStrings.IS_LOYALTY_POINTS_REDEEMED) {
                self.hideRedeemLoyaltyPointsView()
            }else {
                self.showRedeemLoyaltyPointsView()
            }
        }else {
            self.hideRedeemLoyaltyPointsView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func setupViewDidLoadMethod() -> Void {
        self.navigationItem.title = (self.appDelegate.languageData["Cart"] as? String != nil) ? (self.appDelegate.languageData["Cart"] as! String).trim() : "Cart"
        self.labelOrderType.text = (self.appDelegate.languageData["Order_Type"] as? String != nil) ? (self.appDelegate.languageData["Order_Type"] as! String).trim() : "Order Type"
        self.labelOrderTypeTitle.text = self.labelOrderType.text!
        self.labelApplyCoupon.text = (self.appDelegate.languageData["Apply_Coupon"] as? String != nil) ? (self.appDelegate.languageData["Apply_Coupon"] as! String).trim() : "Apply Coupon"
        self.labelApplyCouponTitle.text = (self.appDelegate.languageData["Apply_Coupon"] as? String != nil) ? (self.appDelegate.languageData["Apply_Coupon"] as! String).trim() : "Apply Coupon"
        let couponTextFieldPlaceholder = (self.appDelegate.languageData["Coupon"] as? String != nil) ? (self.appDelegate.languageData["Coupon"] as! String).trim() : "Coupon Code"
        self.textFieldApplyCoupon.placeholder = couponTextFieldPlaceholder
        let applyButtonTitle = (self.appDelegate.languageData["Apply"] as? String != nil) ? (self.appDelegate.languageData["Apply"] as! String).trim() : "Apply"
        self.buttonApply.setTitle(applyButtonTitle, for: .normal)
        self.labelRedeemLoyalityPoint.text = (self.appDelegate.languageData["Redeem_Loyalty_Points"] as? String != nil) ? (self.appDelegate.languageData["Redeem_Loyalty_Points"] as! String).trim() : "Redeem Loyalty Points"
        self.labelTotalPoints.text = (self.appDelegate.languageData["Total_Points"] as? String != nil) ? (self.appDelegate.languageData["Total_Points"] as! String).trim() : "Total Points"
        self.labelBillDetails.text = (self.appDelegate.languageData["Bill_Details"] as? String != nil) ? (self.appDelegate.languageData["Bill_Details"] as! String).trim() : "Bill Details"
        self.labelFoodItem.text = (self.appDelegate.languageData["Food_Items"] as? String != nil) ? (self.appDelegate.languageData["Food_Items"] as! String).trim() : "Food Items"
        self.labelRestaurantDiscount.text = (self.appDelegate.languageData["Restaurant_Discount"] as? String != nil) ? (self.appDelegate.languageData["Restaurant_Discount"] as! String).trim() : "Restaurant Discount"
        self.labelTotalCouponDiscount.text = (self.appDelegate.languageData["Coupon_Discount"] as? String != nil) ? (self.appDelegate.languageData["Coupon_Discount"] as! String).trim() : "Coupon Discount"
        self.labelTotalFoodDiscount.text = (self.appDelegate.languageData["Food_Discount"] as? String != nil) ? (self.appDelegate.languageData["Food_Discount"] as! String).trim() : "Food Discount"
        self.labelLoyaltyPoint.text = (self.appDelegate.languageData["Loyalty_Points"] as? String != nil) ? (self.appDelegate.languageData["Loyalty_Points"] as! String).trim() : "Loyalty Points"
        self.labelSubtotal.text = (self.appDelegate.languageData["Subtotal"] as? String != nil) ? (self.appDelegate.languageData["Subtotal"] as! String).trim() : "Subtotal"
        self.labelDeliveryFee.text = (self.appDelegate.languageData["Delivery_Cost"] as? String != nil) ? (self.appDelegate.languageData["Delivery_Cost"] as! String).trim() : "Delivery Fees"
        self.labelPackageFees.text = (self.appDelegate.languageData["Package_Fees"] as? String != nil) ? (self.appDelegate.languageData["Package_Fees"] as! String).trim() : "Package Fees"
        self.labelServiceFees.text = (self.appDelegate.languageData["Service_Fees"] as? String != nil) ? (self.appDelegate.languageData["Service_Fees"] as! String).trim() : "Service Fees"
        self.labelSaleTax.text = (self.appDelegate.languageData["Sale_Tax"] as? String != nil) ? (self.appDelegate.languageData["Sale_Tax"] as! String).trim() : "Service Tax"
        self.labelVatTax.text = (self.appDelegate.languageData["Vat_Tax"] as? String != nil) ? (self.appDelegate.languageData["Vat_Tax"] as! String).trim() : "Vat Tax"
        self.labelFoodTax.text = (self.appDelegate.languageData["Food_Tax"] as? String != nil) ? (self.appDelegate.languageData["Food_Tax"] as! String).trim() : "Inclusive Food Tax"
        self.labelDrinkTax.text = (self.appDelegate.languageData["Drink_Tax"] as? String != nil) ? (self.appDelegate.languageData["Drink_Tax"] as! String).trim() : "Inclusive Drink Tax"
        
        self.labelRiderTip.text = (self.appDelegate.languageData["Rider_Tip"] as? String != nil) ? (self.appDelegate.languageData["Rider_Tip"] as! String).trim() : "Rider Tip"
        self.labelRiderTipTitle.text = (self.appDelegate.languageData["Rider_Tip"] as? String != nil) ? (self.appDelegate.languageData["Rider_Tip"] as! String).trim() : "Rider Tip"
        self.labelToPay.text = (self.appDelegate.languageData["To_Pay"] as? String != nil) ? (self.appDelegate.languageData["To_Pay"] as! String).trim() : "To Pay"
        self.labelSelectOption.text = (self.appDelegate.languageData["Select_Option"] as? String != nil) ? (self.appDelegate.languageData["Select_Option"] as! String).trim() : "Select Option"
        self.labelScanQRCode.text = (self.appDelegate.languageData["Scan_QR_Code"] as? String != nil) ? (self.appDelegate.languageData["Scan_QR_Code"] as! String).trim() : "Scan QR Code"
        self.labelSelectTableNumber.text = (self.appDelegate.languageData["Select_Table_Number"] as? String != nil) ? (self.appDelegate.languageData["Select_Table_Number"] as! String).trim() : "Select Table Number"
        let buttonSubmitTitle = (self.appDelegate.languageData["Submit"] as? String != nil) ? (self.appDelegate.languageData["Submit"] as! String).trim() : "Submit"
        self.buttonSubmitPostalCode.setTitle(buttonSubmitTitle, for: .normal)
        self.buttonSelectTableSubmit.setTitle(buttonSubmitTitle, for: .normal)
        let buttonRedeemTitle = (self.appDelegate.languageData["Redeem"] as? String != nil) ? (self.appDelegate.languageData["Redeem"] as! String).trim() : "Redeem"
        self.buttonRedeem.setTitle(buttonRedeemTitle, for: .normal)
        let redeemPlaceholder = (self.appDelegate.languageData["Enter_your_loyalty_points"] as? String != nil) ? (self.appDelegate.languageData["Enter_your_loyalty_points"] as! String).trim() : "Enter your loyalty points"
        self.textFieldLoyaltyPoints.placeholder = redeemPlaceholder
        self.labelRedeemLoyaltyPointsTitle.text = (self.appDelegate.languageData["Redeem_Loyalty_Points"] as? String != nil) ? (self.appDelegate.languageData["Redeem_Loyalty_Points"] as! String).trim() : "Redeem Loyalty Points"
        let postalCodePlaceholder = (self.appDelegate.languageData["Please_enter_your_postal_code_here"] as? String != nil) ? (self.appDelegate.languageData["Please_enter_your_postal_code_here"] as! String).trim() : "Please enter your postal code here"
        self.textFieldPostalCode.placeholder = postalCodePlaceholder
        self.labelPostalCode.text = (self.appDelegate.languageData["Postal_Code"] as? String != nil) ? (self.appDelegate.languageData["Postal_Code"] as! String).trim() : "Postcode"
        self.labelEmptyCart.text = (self.appDelegate.languageData["YOUR_CART_IS_EMPTY"] as? String != nil) ? (self.appDelegate.languageData["YOUR_CART_IS_EMPTY"] as! String).trim() : "Your Shopping cart is empty"
        self.labelWoops.text = (self.appDelegate.languageData["WOOPS"] as? String != nil) ? (self.appDelegate.languageData["WOOPS"] as! String).trim() : "WOOPS"
        self.labelEmptyCartDetails.text = (self.appDelegate.languageData["LOOK_LIKE_YOU_HAVE"] as? String != nil) ? (self.appDelegate.languageData["LOOK_LIKE_YOU_HAVE"] as! String).trim() : "Looks like you haven't \n made your choice yet."
        
        self.setupBackBarButton()
        self.viewEmptyCart.isHidden = true
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST) as! Array<Dictionary<String, String>>
        if self.arrayCartItems.count == 0 {
            self.viewContainer.isHidden = true
            self.viewEmptyCart.isHidden = false
            self.viewSubtotal.isHidden = true
            self.buttonCheckout.isHidden = true
        }else {
            self.setupAllBillDetailsView()
            self.setupTipPriceZero(0)
            UtilityMethods.addBorderAndShadow(self.viewApplyCoupon, 5.0)
            UtilityMethods.addBorderAndShadow(self.viewRedeemLoyalityPoint, 5.0)
            self.viewBillDetails.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            
//            Setup Initial Value
            self.hideViewWith(self.viewTotalDiscount, self.labelTotalDiscount, self.labelTotalDiscountAmount, self.heightTotalDiscountView)
            self.labelFoodItemAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", self.calculateTotalFoodAmountWithExtraTopping())
            self.labelRestaurantDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + self.INITIAL_VALUE
            self.labelTotalFoodDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", self.calculateTotalFoodDiscount())
            self.labelTotalCouponDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + self.INITIAL_VALUE
            self.calculateAndSetupSubTotal()
            self.labelDeliveryFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + self.INITIAL_VALUE
            self.labelPackageFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + self.INITIAL_VALUE
            self.labelServiceFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + self.INITIAL_VALUE
            self.labelSaleTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.INITIAL_VALUE
            self.labelVatTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.INITIAL_VALUE
            self.labelTipPrice.text = ConstantStrings.RUPEES_SYMBOL + self.INITIAL_VALUE
            self.labelRiderTipAmount.text = ConstantStrings.RUPEES_SYMBOL + self.INITIAL_VALUE
            self.kitchenOrderID = UserDefaultOperations.getStringObject(ConstantStrings.SEND_ORDER_KITCHEN_ID)
            
            self.setupRedeemLoyaltyPointView()
            if UserDefaultOperations.getBoolObject(ConstantStrings.IS_LOYALTY_POINTS_REDEEMED) {
                self.labelLoyaltyPointAmount.text = "-" + ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", Double(UserDefaultOperations.getStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS_AMOUNT))!)
            }else {
                self.labelLoyaltyPointAmount.text = ConstantStrings.RUPEES_SYMBOL + self.INITIAL_VALUE
            }
            
            if UserDefaultOperations.getBoolObject(ConstantStrings.IS_COUPON_APPLIED) {
                self.couponCode = UserDefaultOperations.getStringObject(ConstantStrings.APPLIED_COUPON_CODE)
                self.labelTotalCouponDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + UserDefaultOperations.getStringObject(ConstantStrings.APPLIED_COUPON_AMOUNT)
            }else {
                self.couponCode = ""
                self.labelTotalCouponDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + self.INITIAL_VALUE
            }
            self.setupApplyCouponView()
            self.calculateAndSetupBillDetails()
            
            let dictionaryPostalOrderDetails = UserDefaultOperations.getDictionaryObject(ConstantStrings.POSTAL_CODE_INFO)
            if !dictionaryPostalOrderDetails.isEmpty {
                self.stringDeliveryCharge = dictionaryPostalOrderDetails[JSONKey.POSTALCODE_DELIVERY_CHARGE] as! String
                if Double(dictionaryPostalOrderDetails[JSONKey.POSTALCODE_MINIMUM_ORDER] as! String) != nil {
                    self.minimumOrderLimit = Double(dictionaryPostalOrderDetails[JSONKey.POSTALCODE_MINIMUM_ORDER] as! String)!
                }
            }
            if UserDefaultOperations.getIntValue(ConstantStrings.ORDER_TYPE_VALUE) == ConstantStrings.ORDER_TYPE_DINING {
                self.selectedTableID = UserDefaultOperations.getStringObject(ConstantStrings.SELECTED_TABLE_NUMBER)
            }
            self.orderType = UserDefaultOperations.getIntValue(ConstantStrings.ORDER_TYPE_VALUE)
            if self.orderType == ConstantStrings.ORDER_TYPE_DINING {
                if self.kitchenOrderID.isEmpty {
                    self.tableView.tableFooterView = UIView()
                }else {
                    self.tableView.tableFooterView = self.setupTableViewFooter()
                }
            }else {
                self.tableView.tableFooterView = UIView()
            }
            self.buttonCheckout.isUserInteractionEnabled = false
            self.buttonCheckout.backgroundColor = .clear
            self.webApiGetRestaurantDiscount(String(self.labelFoodItemAmount.text!.dropFirst(1)), self.orderType)
            if self.orderType == ConstantStrings.ORDER_TYPE_DINING {
                let arrayNewItemList = self.filterNewAddedItemInCartForSendOrder()
                if self.kitchenOrderID.isEmpty {
                    self.labelCheckout.text = ConstantStrings.SEND_ORDER_TO_KITCHEN
                }else if arrayNewItemList.count > 0 {
                    self.labelCheckout.text = ConstantStrings.SEND_ORDER_TO_KITCHEN
                }else {
                    self.labelCheckout.text = (self.appDelegate.languageData["Checkout"] as? String != nil) ? (self.appDelegate.languageData["Checkout"] as! String).trim() : "Checkout"
                }
            }else {
                self.labelCheckout.text = (self.appDelegate.languageData["Checkout"] as? String != nil) ? (self.appDelegate.languageData["Checkout"] as! String).trim() : "Checkout"
            }
            
            self.setupTableViewDelegateAndDatasource()
            if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
                self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
            }
            if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as? RestaurantInfo != nil {
                self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
            }
            if UserDefaultOperations.getStringObject(ConstantStrings.LOYALTY_POINTS).isEmpty {
                self.webApiGetLoyaltyPoints()
            }else {
                self.labelLoyaltyPoints.text = UserDefaultOperations.getStringObject(ConstantStrings.LOYALTY_POINTS)
            }
        }
        
        self.setupOrderTypeArray()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "OrderTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.ORDER_TYPE_CELL)
        
        self.collectionViewPopup.delegate = self
        self.collectionViewPopup.dataSource = self
        self.collectionViewPopup.register(UINib.init(nibName: "OrderTypePopupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.ORDER_TYPE_POPUP_CELL)
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
    
//    button Add More Action
    @objc func buttonAddMoreAction(_ sender : UIButton) -> Void {
        self.isMovedOutFromCart = true
        isAddingItemToCart = true
        self.moveOnMenuPage()
    }
    
//    Func setup Order Type Array according to restaurant service
    func setupOrderTypeArray() -> Void {
        
        self.arrayOrderType.removeAll()
        if self.restaurantInfo.isHomeDeliveryAvailable {
            
            self.arrayOrderType.append([self.ORDER_TYPE_NAME : ConstantStrings.ORDER_TYPE_DELIVERY_STRING, self.ORDER_TYPE_IMAGE : self.DELIVERY_IMAGE, self.ORDER_TYPE_ID : self.DELIVERY_TYPE, self.ORDER_TYPE_STRING_VALUE : self.DELIVER_STRING])
        }
        
        if self.restaurantInfo.isPickupAvailable {
            
            self.arrayOrderType.append([self.ORDER_TYPE_NAME : ConstantStrings.ORDER_TYPE_PICKUP_STRING, self.ORDER_TYPE_IMAGE : self.PICK_UP_IMAGE, self.ORDER_TYPE_ID : self.PICKUP_TYPE, self.ORDER_TYPE_STRING_VALUE : self.PICKUP_STRING])
        }
        
        if self.restaurantInfo.isDineAvailable {
            
            self.arrayOrderType.append([self.ORDER_TYPE_NAME : ConstantStrings.ORDER_TYPE_DINING_STRING, self.ORDER_TYPE_IMAGE : self.EAT_IN_IMAGE, self.ORDER_TYPE_ID : self.DINING_TYPE, self.ORDER_TYPE_STRING_VALUE : self.DINING_STRING])
        }
        
        var isMatched = Bool()
        for orderDetails in self.arrayOrderType {
            
            if self.orderType == (orderDetails[self.ORDER_TYPE_ID] as! Int) {
                
                isMatched = true
                break
            }
        }
        
        if !isMatched {
            
            self.orderType = 0
            self.orderTypeString = ""
            UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, 0)
        }
    }
    
//    Hide/Show the Redeem Loyalty Points view
    func hideRedeemLoyaltyPointsView() -> Void {
        
        self.heightRedeemPoint.constant = 0.5
        self.topMarginRedeemPoint.constant = 0.5
        self.viewRedeemLoyalityPoint.isHidden = true
    }
    
    func showRedeemLoyaltyPointsView() -> Void {
        
        if self.restaurantInfo.isLoyaltyPointAvailable {
            
            self.heightRedeemPoint.constant = 50.0
            self.topMarginRedeemPoint.constant = 10.0
            self.viewRedeemLoyalityPoint.isHidden = false
        }else {

            self.hideRedeemLoyaltyPointsView()
        }
    }
    
//    Setup Apply coupon View
    func setupApplyCouponView() -> Void {
        
        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_COUPON_APPLIED) {
            
            self.heightApplyCouponView.constant = 0.5
            self.topMarginApplyCoupon.constant = 0.5
            self.viewApplyCoupon.isHidden = true
        }else {
            
            self.heightApplyCouponView.constant = 50.0
            self.topMarginApplyCoupon.constant = 10.0
            self.viewApplyCoupon.isHidden = false
        }
    }
    
//    Hide All view of bill details
    func setupAllBillDetailsView() -> Void {
        
        if self.labelDeliveryFeesAmount.text!.isEmpty || self.labelDeliveryFeesAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelDeliveryFeesAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelDeliveryFeesAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewDeliveryValue, self.labelDeliveryFee, self.labelDeliveryFeesAmount, self.heightDeliveryView)
        }else {
            
            self.showViewWith(self.viewDeliveryValue, self.labelDeliveryFee, self.labelDeliveryFeesAmount, self.heightDeliveryView)
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
        if self.labelTotalFoodDiscountAmount.text!.isEmpty || self.labelTotalFoodDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelTotalFoodDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelTotalFoodDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewFoodDiscount, self.labelTotalFoodDiscount, self.labelTotalFoodDiscountAmount, self.heightFoodDiscountView)
        }else {
            
            self.showViewWith(self.viewFoodDiscount, self.labelTotalFoodDiscount, self.labelTotalFoodDiscountAmount, self.heightFoodDiscountView)
        }
        if self.labelRestaurantDiscountAmount.text!.isEmpty || self.labelRestaurantDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelRestaurantDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelRestaurantDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewRestaurantDiscount, self.labelRestaurantDiscount, self.labelRestaurantDiscountAmount, self.heightRestaurantDiscountView)
        }else {
            
            self.showViewWith(self.viewRestaurantDiscount, self.labelRestaurantDiscount, self.labelRestaurantDiscountAmount, self.heightRestaurantDiscountView)
        }
        if self.labelTotalCouponDiscountAmount.text!.isEmpty || self.labelTotalCouponDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelTotalCouponDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelTotalCouponDiscountAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewCouponDiscount, self.labelTotalCouponDiscount, self.labelTotalCouponDiscountAmount, self.heightCouponDiscountView)
        }else {
            
            self.showViewWith(self.viewCouponDiscount, self.labelTotalCouponDiscount, self.labelTotalCouponDiscountAmount, self.heightCouponDiscountView)
        }
        
        if self.labelRiderTipAmount.text!.isEmpty || self.labelRiderTipAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelRiderTipAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelRiderTipAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewRiderTip, self.labelRiderTip, self.labelRiderTipAmount, self.heightRiderTipView)
        }else {
            
            self.showViewWith(self.viewRiderTip, self.labelRiderTip, self.labelRiderTipAmount, self.heightRiderTipView)
        }
        if self.labelLoyaltyPointAmount.text!.isEmpty || self.labelLoyaltyPointAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0" || self.labelLoyaltyPointAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.0" || self.labelLoyaltyPointAmount.text! == "\(ConstantStrings.RUPEES_SYMBOL)0.00" {
            
            self.hideViewWith(self.viewLoyaltyPoints, self.labelLoyaltyPoint, self.labelLoyaltyPointAmount, self.heightLoyaltyPointView)
        }else {
            
            self.showViewWith(self.viewLoyaltyPoints, self.labelLoyaltyPoint, self.labelLoyaltyPointAmount, self.heightLoyaltyPointView)
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
    
//    func set tip zero
    func setupTipPriceZero(_ tip : Double) -> Void {
        
        self.riderTip = tip
        self.button10.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.button20.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.button30.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.button40.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.button50.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        
        if self.riderTip == self.PERCENTAGE_10 {
            
            self.button10.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        }else if self.riderTip == PERCENTAGE_20 {
            
            self.button20.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        }else if self.riderTip == PERCENTAGE_30 {
            
            self.button30.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        }else if self.riderTip == PERCENTAGE_40 {
            
            self.button40.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        }else if self.riderTip == PERCENTAGE_50 {
            
            self.button50.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        }
    }
    
    //    MARK:- Calculate All total and discount
//    Calculate total food offer amount without any discount
    func calculateTotalOfferFoodAmount() -> Double {
        
        var totalAmount = Double()
        
        for itemDetails in self.arrayCartItems {
            
            totalAmount += Double(itemDetails[JSONKey.ITEM_CART_PRICE]!)!
        }
        
        return totalAmount
    }
    
//    Calculate the total food amount with extra topping
    func calculateTotalFoodAmountWithExtraTopping() -> Double {
        
        var totalAmount = Double()
        
        for itemDetails in self.arrayCartItems {
            
            totalAmount += (Double(itemDetails[JSONKey.ITEM_CART_PRICE]!)! + (Double(itemDetails[JSONKey.ITEM_EXTRA_PRICE]!)! * Double(itemDetails[JSONKey.ITEM_QUANTITY]!)!))
        }
        
        return totalAmount
    }
    
//    Calculate total food original amount without any discount
    func calculateTotalOriginalFoodAmount() -> Double {
        
        var totalOriginalAmount = Double()
        
        for itemDetails in self.arrayCartItems {
            
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
    
//    Calculate the total all discount
    func calculateTotalAllDiscount() -> Double {
        
        let restaurantDiscount = (Double(self.labelRestaurantDiscountAmount.text!.dropFirst(1)) != nil) ? Double(self.labelRestaurantDiscountAmount.text!.dropFirst(1))! : 0.0
        let couponDiscount = (Double(self.labelTotalCouponDiscountAmount.text!.dropFirst(1)) != nil) ? Double(self.labelTotalCouponDiscountAmount.text!.dropFirst(1))! : 0.0
        let loyaltyPoints = (Double(self.labelLoyaltyPointAmount.text!.dropFirst(2)) != nil) ? Double(self.labelLoyaltyPointAmount.text!.dropFirst(2))! : 0.0
        let totalDiscount = restaurantDiscount + couponDiscount + loyaltyPoints
        
        return totalDiscount
    }
    
//    Calculate total all discount for show (totalDiscount = restaurantDiscount + foodDiscount + couponDiscount)
    func calculateTotalAllDiscountForShow() -> Double {
        
        let restaurantDiscount = (Double(self.labelRestaurantDiscountAmount.text!.dropFirst(1)) != nil) ? Double(self.labelRestaurantDiscountAmount.text!.dropFirst(1))! : 0.0
        let foodDiscount = (Double(self.labelTotalFoodDiscountAmount.text!.dropFirst(1)) != nil) ? Double(self.labelTotalFoodDiscountAmount.text!.dropFirst(1))! : 0.0
        let couponDiscount = (Double(self.labelTotalCouponDiscountAmount.text!.dropFirst(1)) != nil) ? Double(self.labelTotalCouponDiscountAmount.text!.dropFirst(1))! : 0.0
        let totalDiscount = restaurantDiscount + foodDiscount + couponDiscount
        
        return totalDiscount
    }
    
//    Setup Subtotal
    func calculateAndSetupSubTotal() -> Void {
        
        let totalAmount = self.calculateTotalFoodAmountWithExtraTopping()
        let totalDiscount = self.calculateTotalAllDiscount()
//        let loyaltyPoints = (Double(self.labelLoyaltyPointAmount.text!.dropFirst(2)) != nil) ? Double(self.labelLoyaltyPointAmount.text!.dropFirst(2))! : 0.0
        self.labelSubtotalAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", totalAmount - totalDiscount)
    }
    
//    Calculate tip and total with subtotal
    func calculateTipAmount() -> Void {
        
        let totalAmount = self.calculateTotalFoodAmountWithExtraTopping()
        let totalDiscount = self.calculateTotalAllDiscount()
        let subtotal = totalAmount - totalDiscount
        
        if subtotal > 0.0 {
            
            let tipAmount = UtilityMethods.calculatePercentageAmount(self.riderTip, subtotal)
            self.labelRiderTipAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", tipAmount)
            self.labelTipPrice.text = self.labelRiderTipAmount.text!
        }
    }
    
//    Calculate and setup total amount for pay
    func calculateAndSetupTotalPayableAmount() -> Void {
        
        let totalAmount = self.calculateTotalFoodAmountWithExtraTopping()
        let totalDiscount = self.calculateTotalAllDiscount()
        
        let subtotal = totalAmount - totalDiscount
        let deliveryCost = (Double(self.labelDeliveryFeesAmount.text!.dropFirst(1)) != nil) ? Double(self.labelDeliveryFeesAmount.text!.dropFirst(1))! : 0.0
        let packageFees = (Double(self.labelPackageFeesAmount.text!.dropFirst(1)) != nil) ? Double(self.labelPackageFeesAmount.text!.dropFirst(1))! : 0.0
        let serviceFees = (Double(self.labelServiceFeesAmount.text!.dropFirst(1)) != nil) ? Double(self.labelServiceFeesAmount.text!.dropFirst(1))! : 0.0
        let saleTax = (Double(self.labelSaleTaxAmount.text!.dropFirst(1)) != nil) ? Double(self.labelSaleTaxAmount.text!.dropFirst(1))! : 0.0
        let vatTax = (Double(self.labelVatTaxAmount.text!.dropFirst(1)) != nil) ? Double(self.labelVatTaxAmount.text!.dropFirst(1))! : 0.0
        let tipAmount = (Double(self.labelRiderTipAmount.text!.dropFirst(1)) != nil) ? Double(self.labelRiderTipAmount.text!.dropFirst(1))! : 0.0
        
        let totalPayableAmount = (subtotal + deliveryCost + packageFees + serviceFees + saleTax + vatTax + tipAmount)
        self.labelPayableAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", totalPayableAmount)
        self.labelTotalPayAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", totalPayableAmount)
        var stringMessage = (self.appDelegate.languageData["TOTAL_ITEM_IN_CART"] as? String != nil) ? (self.appDelegate.languageData["TOTAL_ITEM_IN_CART"] as! String).trim() : "Total $ Items"
        stringMessage = stringMessage.replacingOccurrences(of: "$", with: "\(self.arrayCartItems.count)")
        self.labelTotalPay.text = stringMessage
        self.labelFoodTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.calculate7PercentTax()
        self.labelDrinkTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + self.calculate19PercentTax()
        self.setupAllBillDetailsView()
    }
    
//    Calculate and Setup Bill Details
    func calculateAndSetupBillDetails() -> Void {
        
        self.labelFoodItemAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", self.calculateTotalFoodAmountWithExtraTopping())
        self.labelTotalFoodDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", self.calculateTotalFoodDiscount())
//        self.labelTotalDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", self.calculateTotalAllDiscountForShow())
        self.calculateAndSetupSubTotal()
        self.calculateTipAmount()
        self.calculateAndSetupTotalPayableAmount()
    }
    
//    Func calculate the tax for  7%
    func calculate7PercentTax() -> String {
        
        var total7PercentAmount = Double()
        for cartItem in self.arrayCartItems {
            if cartItem[JSONKey.ITEM_FOOD_TAX_APPLICABLE] == ConstantStrings.FOOD_TAX_7 {
                
                total7PercentAmount += (Double(cartItem[JSONKey.ITEM_CART_PRICE]!) != nil) ? Double(cartItem[JSONKey.ITEM_CART_PRICE]!)! : 0.00
            }
        }
        
        let percentage = (Double(ConstantStrings.FOOD_TAX_7) != nil) ? Double(ConstantStrings.FOOD_TAX_7)! : 0.00
        let calculatedValue = (total7PercentAmount * percentage) / 100.0
        
        print(print("Total\(total7PercentAmount) value \(percentage)% amount of \(calculatedValue)"))
        return String(format: "%.2f", calculatedValue)
    }
    
//    Func calculate the tax for  19%
    func calculate19PercentTax() -> String {
        
        var total19PercentAmount = Double()
        for cartItem in self.arrayCartItems {
            if cartItem[JSONKey.ITEM_FOOD_TAX_APPLICABLE] == ConstantStrings.FOOD_TAX_19 {
                
                total19PercentAmount += (Double(cartItem[JSONKey.ITEM_CART_PRICE]!) != nil) ? Double(cartItem[JSONKey.ITEM_CART_PRICE]!)! : 0.00
            }
        }
        
        let percentage = (Double(ConstantStrings.FOOD_TAX_19) != nil) ? Double(ConstantStrings.FOOD_TAX_19)! : 0.00
        let calculatedValue = (total19PercentAmount * percentage) / 100.0
        
        print(print("Total\(total19PercentAmount) value \(percentage)% amount of \(calculatedValue)"))
        return String(format: "%.2f", calculatedValue)
    }
    
//    Setup tableView Delegate And datasource
    func setupTableViewDelegateAndDatasource() -> Void {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 40
    }
    
    //    MARK:- Hide bill variable view like sale tax, vat tax etc.
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
    
    //    MARK:- UITableView Delegate And Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.orderType == ConstantStrings.ORDER_TYPE_DINING {
            let arrayNewItem = self.filterNewAddedItemInCartForSendOrder()
            if arrayNewItem.count > 0 {
                return 2
            }else {
                return 1
            }
        }else {
          return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.orderType == ConstantStrings.ORDER_TYPE_DINING {
            if self.kitchenOrderID.isEmpty {
                return self.arrayCartItems.count
            }else {
                let arraySentToKitchen = UserDefaultOperations.getArrayObject(ConstantStrings.SEND_ORDER_KITCHEN_LIST) as! Array<Dictionary<String, String>>
                let arrayNewItem = self.filterNewAddedItemInCartForSendOrder()
                if section == 0 {
                    return arraySentToKitchen.count
                }else {
                    return arrayNewItem.count
                }
            }
        }else {
            return self.arrayCartItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.orderType == ConstantStrings.ORDER_TYPE_DINING {
            if section == 0 {
                
                return 0
            }else {
                
                return 20.0
            }
        }else {
            return 0
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
        
        let cell = Bundle.main.loadNibNamed("CartTableViewCell", owner: self, options: nil)?.first as! CartTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.indexPath = indexPath
        var arrayCartList = Array<Dictionary<String, String>>()
        if self.orderType == ConstantStrings.ORDER_TYPE_DINING {
            if self.kitchenOrderID.isEmpty {
                arrayCartList = self.arrayCartItems
            }else {
                if indexPath.section == 0 {
                    arrayCartList = UserDefaultOperations.getArrayObject(ConstantStrings.SEND_ORDER_KITCHEN_LIST) as! Array<Dictionary<String, String>>
                }else {
                    arrayCartList = self.filterNewAddedItemInCartForSendOrder()
                }
            }
        }else {
            arrayCartList = self.arrayCartItems
        }
        let dictionary = arrayCartList[indexPath.row]
        cell.labelCount.text = dictionary[JSONKey.ITEM_QUANTITY]
        cell.labelMenuName.text = dictionary[JSONKey.ITEM_NAME]?.trim()
        cell.labelMenuDescription.text = dictionary[JSONKey.ITEM_DESCRIPTION]?.trim()
        let totalFoodAmount = Double(dictionary[JSONKey.ITEM_CART_PRICE]!)! + (Double(dictionary[JSONKey.ITEM_EXTRA_PRICE]!)! * Double(dictionary[JSONKey.ITEM_QUANTITY]!)!)
        cell.labelPrice.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", totalFoodAmount)
        
        return cell
    }
    
    let MINUS_CLICKED = 1
    let PLUS_CLICKED = 2
//    Modify Cart Item delegate Method
    func updateCartItemQuantity(_ itemCount : String, _ indexPath : IndexPath, _ buttonTag : Int) {
        
        var count = itemCount
//        var dictionary = Dictionary<String, String>()
//        if self.orderType == ConstantStrings.ORDER_TYPE_DINING {
//            if !self.kitchenOrderID.isEmpty {
//                var arrayNewItem = Array<Dictionary<String, String>>()
//                if indexPath.section == 0 {
//                    arrayNewItem = UserDefaultOperations.getArrayObject(ConstantStrings.SEND_ORDER_KITCHEN_LIST) as! Array<Dictionary<String, String>>
//                }else {
//                    arrayNewItem = self.filterNewAddedItemInCartForSendOrder()
//                }
//                dictionary = arrayNewItem[indexPath.row]
//                var cartItemIndex = Int()
//                for i in 0..<arrayCartItems.count {
//                    let cartDictionary = arrayCartItems[i]
//                    if (dictionary[JSONKey.ITEM_ID] == cartDictionary[JSONKey.ITEM_ID]) && (dictionary[JSONKey.ITEM_SIZE_ID] == cartDictionary[JSONKey.ITEM_SIZE_ID]) && (dictionary[JSONKey.ITEM_EXTRA_ID] == cartDictionary[JSONKey.ITEM_EXTRA_ID]) {
//                        cartItemIndex = i
//                        break
//                    }
//                }
//                dictionary = self.arrayCartItems[cartItemIndex]
//                var kitchenItemQuantity = Int()
//                let arrayKitchenOrderList = UserDefaultOperations.getArrayObject(ConstantStrings.SEND_ORDER_KITCHEN_LIST) as! Array<Dictionary<String, String>>
//                for kitchenItem in arrayKitchenOrderList {
//                    let cartOrderID = dictionary[JSONKey.ITEM_ID]!
//                    let kitchenOrderID = kitchenItem[JSONKey.ITEM_ID]!
//                    let cartSizeID = dictionary[JSONKey.ITEM_SIZE_ID]!
//                    let kitchenSizeID = kitchenItem[JSONKey.ITEM_SIZE_ID]!
//                    let cartExtraID = dictionary[JSONKey.ITEM_EXTRA_ID]!
//                    let kitchenExtraID = kitchenItem[JSONKey.ITEM_EXTRA_ID]!
//                    if (cartOrderID == kitchenOrderID) && (cartSizeID == kitchenSizeID) && (cartExtraID == kitchenExtraID) {
//                        kitchenItemQuantity = Int(kitchenItem[JSONKey.ITEM_QUANTITY]!)!
//                    }
//                }
//                let totalCount = Int(count)! + kitchenItemQuantity
//                count = "\(totalCount)"
//            }else {
//                dictionary = self.arrayCartItems[indexPath.row]
//            }
//        }else {
//            dictionary = self.arrayCartItems[indexPath.row]
//        }
//        if (self.orderType == ConstantStrings.ORDER_TYPE_DINING) && !self.kitchenOrderID.isEmpty {
//            var kitchenItemQuantity = Int()
//            let arrayKitchenOrderList = UserDefaultOperations.getArrayObject(ConstantStrings.SEND_ORDER_KITCHEN_LIST) as! Array<Dictionary<String, String>>
//            for kitchenItem in arrayKitchenOrderList {
//                let cartOrderID = dictionary[JSONKey.ITEM_ID]!
//                let kitchenOrderID = kitchenItem[JSONKey.ITEM_ID]!
//                let cartSizeID = dictionary[JSONKey.ITEM_SIZE_ID]!
//                let kitchenSizeID = kitchenItem[JSONKey.ITEM_SIZE_ID]!
//                let cartExtraID = dictionary[JSONKey.ITEM_EXTRA_ID]!
//                let kitchenExtraID = kitchenItem[JSONKey.ITEM_EXTRA_ID]!
//                if (cartOrderID == kitchenOrderID) && (cartSizeID == kitchenSizeID) && (cartExtraID == kitchenExtraID) {
//                    kitchenItemQuantity = Int(kitchenItem[JSONKey.ITEM_QUANTITY]!)!
//                }
//            }
//            let arrayNewItemList = self.filterNewAddedItemInCartForSendOrder()
//            if arrayNewItemList.count > 0 || self.kitchenOrderID.isEmpty {
//                self.isNewItemAdded = true
//                self.labelCheckout.text = ConstantStrings.SEND_ORDER_TO_KITCHEN
//            }else {
//                self.isNewItemAdded = false
//                self.labelCheckout.text = "Checkout"
//            }
//            self.tableView.reloadData()
//            if buttonTag == self.MINUS_CLICKED {
//                if (Int(count)! < kitchenItemQuantity) {
//                    self.showToastWithMessage(self.view, ConstantStrings.YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW)
//                    return
//                }
//            }else {
//                if (Int(count)! > kitchenItemQuantity) {
//                    self.showToastWithMessage(self.view, ConstantStrings.YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW)
//                    return
//                }
//            }
//        }
        var dictionary = Dictionary<String, String>()
        if (!self.kitchenOrderID.isEmpty) && (indexPath.section == 0) {
            self.showToastWithMessage(self.view, ConstantStrings.YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW)
            return
        }else if (!self.kitchenOrderID.isEmpty) && (indexPath.section == 1) {
            let arrayNewList = self.filterNewAddedItemInCartForSendOrder()
            dictionary = arrayNewList[indexPath.row]
        }else {
            dictionary = self.arrayCartItems[indexPath.row]
        }
        if (self.orderType == ConstantStrings.ORDER_TYPE_DINING) && (!self.kitchenOrderID.isEmpty) {
            var kitchenItemQuantity = Int()
            let arrayKitchenOrderList = UserDefaultOperations.getArrayObject(ConstantStrings.SEND_ORDER_KITCHEN_LIST) as! Array<Dictionary<String, String>>
            for kitchenItem in arrayKitchenOrderList {
                let cartOrderID = dictionary[JSONKey.ITEM_ID]!
                let kitchenOrderID = kitchenItem[JSONKey.ITEM_ID]!
                let cartSizeID = dictionary[JSONKey.ITEM_SIZE_ID]!
                let kitchenSizeID = kitchenItem[JSONKey.ITEM_SIZE_ID]!
                let cartExtraID = dictionary[JSONKey.ITEM_EXTRA_ID]!
                let kitchenExtraID = kitchenItem[JSONKey.ITEM_EXTRA_ID]!
                if (cartOrderID == kitchenOrderID) && (cartSizeID == kitchenSizeID) && (cartExtraID == kitchenExtraID) {
                    kitchenItemQuantity = Int(kitchenItem[JSONKey.ITEM_QUANTITY]!)!
                }
            }
            let totalCount = Int(count)! + kitchenItemQuantity
            count = "\(totalCount)"
        }
        if Int(count)! == 0 {
            dictionary[JSONKey.ITEM_QUANTITY] = count
            dictionary[JSONKey.ITEM_CART_PRICE] = "0"
            dictionary[JSONKey.ITEM_CART_ORIGINAL_PRICE] = "0"
            dictionary[JSONKey.ITEM_UPDATED_PRICE] = dictionary[JSONKey.ITEM_OFFER_PRICE]
            dictionary[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE] = dictionary[JSONKey.ITEM_ORIGINAL_PRICE]
            dictionary[JSONKey.ITEM_IS_ADDED_TO_CART] = ConstantStrings.ITEM_NOT_ADDED_TO_CART
            self.arrayCartItems.remove(at: indexPath.row)
        }else {
            dictionary[JSONKey.ITEM_QUANTITY] = count
            let totalAmount = (Double(dictionary[JSONKey.ITEM_UPDATED_PRICE]!)!) * (Double(count)!)
            dictionary[JSONKey.ITEM_CART_PRICE] = String(format: "%.2f", totalAmount)
            let totalOriginalAmount = (Double(dictionary[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE]!)!) * (Double(count)!)
            dictionary[JSONKey.ITEM_CART_ORIGINAL_PRICE] = String(format: "%.2f", totalOriginalAmount)
            if (self.orderType == ConstantStrings.ORDER_TYPE_DINING) && !self.kitchenOrderID.isEmpty {
                if self.arrayCartItems.count > 0 {
                    var cartItemIndex = -1
                    for i in 0..<arrayCartItems.count {
                        let cartDictionary = arrayCartItems[i]
                        if (dictionary[JSONKey.ITEM_ID] == cartDictionary[JSONKey.ITEM_ID]) && (dictionary[JSONKey.ITEM_SIZE_ID] == cartDictionary[JSONKey.ITEM_SIZE_ID]) && (dictionary[JSONKey.ITEM_EXTRA_ID] == cartDictionary[JSONKey.ITEM_EXTRA_ID]) {
                        cartItemIndex = i
                        break
                        }
                    }
                    if cartItemIndex >= 0 {
                        self.arrayCartItems[cartItemIndex] = dictionary
                    }
                }else {
                    self.arrayCartItems[indexPath.row] = dictionary
                }
            }else {
                self.arrayCartItems[indexPath.row] = dictionary
            }
        }
        self.updateCartValue(count, dictionary)
        self.delegate?.cartValueChanged(dictionary)
        self.calculateAndSetupBillDetails()
        self.webApiGetRestaurantDiscount(String(self.labelFoodItemAmount.text!.dropFirst(1)), self.orderType)
    }
    
    //    Update cart value according to item count
    func updateCartValue(_ count : String, _ dictionary : Dictionary<String, String>) -> Void {
        
        var arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST) as! Array<Dictionary<String, String>>
        
        if arrayCartItems.count > 0 {
            var cartItemIndex = Int()
            for i in 0..<arrayCartItems.count {
                let cartDictionary = arrayCartItems[i]
                if (dictionary[JSONKey.ITEM_ID] == cartDictionary[JSONKey.ITEM_ID]) && (dictionary[JSONKey.ITEM_SIZE_ID] == cartDictionary[JSONKey.ITEM_SIZE_ID]) && (dictionary[JSONKey.ITEM_EXTRA_ID] == cartDictionary[JSONKey.ITEM_EXTRA_ID]) {
                    cartItemIndex = i
                    break
                }
            }
            
            if Int(count) != nil {
                if Int(count)! <= 0 {
                    arrayCartItems.remove(at: cartItemIndex)
                }else {
                    var cartDictionary = arrayCartItems[cartItemIndex]
                    cartDictionary[JSONKey.ITEM_QUANTITY] = count
                    
                    let totalAmount = (Double(cartDictionary[JSONKey.ITEM_UPDATED_PRICE]!)!) * (Double(count)!)
                    cartDictionary[JSONKey.ITEM_CART_PRICE] = String(format: "%.2f", totalAmount)
                    let totalOriginalAmount = (Double(cartDictionary[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE]!)!) * (Double(count)!)
                    cartDictionary[JSONKey.ITEM_CART_ORIGINAL_PRICE] = String(format: "%.2f", totalOriginalAmount)
                    arrayCartItems[cartItemIndex] = cartDictionary
                }
                UserDefaultOperations.setArrayObject(ConstantStrings.CART_ITEM_LIST, arrayCartItems)
                UIView.performWithoutAnimation {
                    // Update UI that you don't want to animate
                    self.isDeletedCell = false
                    self.tableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        
                        self.isDeletedCell = true
                        self.view.setNeedsLayout()
                    }
                }
            }
        }
        
        if self.arrayCartItems.count == 0 {
            
            self.viewContainer.isHidden = true
            self.viewEmptyCart.isHidden = false
            self.viewSubtotal.isHidden = true
            self.buttonCheckout.isHidden = true
            UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS, "")
            UserDefaultOperations.setBoolObject(ConstantStrings.IS_LOYALTY_POINTS_REDEEMED, false)
            UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS_AMOUNT, "")
            
            UserDefaultOperations.setBoolObject(ConstantStrings.IS_COUPON_APPLIED, false)
            UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_COUPON_CODE, "")
            UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_COUPON_AMOUNT, "")
        }
        let arrayNewItemList = self.filterNewAddedItemInCartForSendOrder()
        if arrayNewItemList.count > 0 || self.kitchenOrderID.isEmpty {
            self.isNewItemAdded = true
            self.labelCheckout.text = ConstantStrings.SEND_ORDER_TO_KITCHEN
        }else {
            self.isNewItemAdded = false
            self.labelCheckout.text = (self.appDelegate.languageData["Checkout"] as? String != nil) ? (self.appDelegate.languageData["Checkout"] as! String).trim() : "Checkout"
        }
        self.tableView.reloadData()
    }
        
//    Remove popup apply code view
    @IBAction func buttonRemoveApplyCodeAction(_ sender: UIButton) {
        
        self.popupApplyCodeController?.dismiss(animated: true)
    }
        
    var chooseOptionTableNumber = Int()
    @IBAction func buttonQRScanCodeAction(_ sender: UIButton) {
        
        self.chooseOptionTableNumber = 1
        self.labelScanQRCode.textColor = .black
        self.labelSelectTableNumber.textColor = .darkGray
        self.imageViewScanner.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
        self.imageViewSelectTable.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
    }
    
    @IBAction func buttonSelectTableAction(_ sender: UIButton) {
        
        self.chooseOptionTableNumber = 2
        self.labelScanQRCode.textColor = .darkGray
        self.labelSelectTableNumber.textColor = .black
        self.imageViewScanner.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
        self.imageViewSelectTable.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
    }
    
    @IBAction func buttonTableSelectionAction(_ sender: UIButton) {
        
        self.popDiningController?.dismiss(animated: true)
        
        if self.chooseOptionTableNumber == 1 {
            
            let scannerVC = QRScannerController.init(nibName: "QRScannerController", bundle: nil)
            scannerVC.isMovedFromCart = true
            self.navigationController?.pushViewController(scannerVC, animated: true)
        }else {
            
            let selectTableVC = SelectTableViewController.init(nibName: "SelectTableViewController", bundle: nil)
            selectTableVC.delegate = self
            self.navigationController?.pushViewController(selectTableVC, animated: true)
        }
    }
    
    @IBAction func buttonRemoveSelectTableNumberPopupAction(_ sender: UIButton) {
        
        self.popDiningController?.dismiss(animated: true)
    }
    
    
    var selectedPostalCodeOrderType = Int()
    //    Button Action for submit the postal code
    @IBAction func buttonSubmitPostalCodeAction(_ sender: UIButton) {
        
        if self.selectedPostalCodeOrderType == 0 {
            
//            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PLEASE_SELECT_ORDER_TYPE)
            self.showToastWithMessage(self.viewPostalCode, ConstantStrings.PLEASE_SELECT_ORDER_TYPE)
        }else if self.selectedPostalCodeOrderType == ConstantStrings.ORDER_TYPE_DELIVERY {
            
            if self.textFieldPostalCode.text!.isEmpty {
                
                self.textFieldPostalCode.becomeFirstResponder()
//                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.POSTAL_CODE_FIELD_IS_REQUIRED)
                self.showToastWithMessage(self.view, ConstantStrings.POSTAL_CODE_FIELD_IS_REQUIRED)
            }else {
                
                self.webApiPostalCodeDetails(self.textFieldPostalCode.text!)
            }
        }else if self.selectedPostalCodeOrderType == self.PICKUP_TYPE {
            
            self.orderType = self.PICKUP_TYPE
            UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, self.orderType)
            self.collectionView.reloadData()
            self.popupController?.dismiss(animated: true)
        }else {
            
//            self.setupOrderType(self.selectedPostalCodeOrderType)
//            UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, self.orderType)
            self.popupController?.dismiss(animated: true)
            self.setupSelectTablePopup()
        }
    }
    
    //    MARK:- Button Action
    @IBAction func buttonOrderTypeAction(_ sender: UIButton) {
        
        let postalCodeInfo = UserDefaultOperations.getDictionaryObject(ConstantStrings.POSTAL_CODE_INFO)
        let orderType = UserDefaultOperations.getIntValue(ConstantStrings.ORDER_TYPE_VALUE)
        
        if (sender.tag == self.DELIVERY_TYPE) && (postalCodeInfo.isEmpty) && (orderType != self.DELIVERY_TYPE) {
            
//            self.setupPostalCodePopupView()
            self.setupViewPopupAnimation()
        }else if sender.tag == self.DINING_TYPE {
            
            self.setupSelectTablePopup()
        }else {
            
//            self.setupOrderType(sender.tag)
        }
    }
    
//    Func Setup functionality for popup the select table
    func setupSelectTablePopup() -> Void {
        
        self.chooseOptionTableNumber = 0
        self.labelScanQRCode.textColor = .darkGray
        self.labelSelectTableNumber.textColor = .darkGray
        self.imageViewScanner.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
        self.imageViewSelectTable.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
        self.imageViewScanner.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
        UtilityMethods.addBorderAndShadow(self.buttonSelectTableSubmit, self.buttonSelectTableSubmit.bounds.height / 2)
        self.viewSelectTable.frame = CGRect.init(x: 15, y: 0, width: UIScreen.main.bounds.width - 30, height: self.DINING_VIEW_HEIGHT)
        
        let popupController = CNPPopupController(contents:[self.viewSelectTable])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = CNPPopupStyle.actionSheet
        // LFL added settings for custom color and blur
        popupController.theme.backgroundColor = .white
        popupController.theme.maskType = .dimmed
        popupController.delegate = self
        self.popDiningController = popupController
        popupController.present(animated: true)
    }
    
    //    MARK:- Button Action
    @IBAction func buttonAddTipAction(_ sender: UIButton) {
        
        let selectedTip = Double(sender.tag)
        if (selectedTip == self.PERCENTAGE_10) || (selectedTip == self.PERCENTAGE_20) || (selectedTip == self.PERCENTAGE_30) || (selectedTip == self.PERCENTAGE_40) || (selectedTip == self.PERCENTAGE_50) {
            
            if self.riderTip == selectedTip {
                
                self.setupTipPriceZero(0)
            }else {
                
                self.setupTipPriceZero(selectedTip)
            }
        }
        self.calculateTipAmount()
        self.calculateAndSetupTotalPayableAmount()
    }
    
//
    @IBAction func buttonApplyCouponClicked(_ sender: UIButton) {
        
        self.setupApplyCodeAnimationView()
    }
    
    var popupApplyCodeController : CNPPopupController?
    func setupApplyCodeAnimationView() -> Void {
        
        UtilityMethods.addBorderAndShadow(self.viewPopupApplyCoupon, 5.0)
        UtilityMethods.addBorderAndShadow(self.buttonApply, self.buttonApply.bounds.height / 2)
        self.viewContent.backgroundColor = .clear
        self.textFieldApplyCoupon.text = ""
        self.viewPopupApplyCoupon.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewPopupApplyCoupon.frame = CGRect.init(x: 15, y: 0, width: self.screenWidth - 30, height: self.POPUP_VIEW_HEIGHT)
        
        let popupController = CNPPopupController(contents:[self.viewPopupApplyCoupon])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = CNPPopupStyle.centered
        // LFL added settings for custom color and blur
        popupController.theme.backgroundColor = .clear
        popupController.theme.maskType = .dimmed
        popupController.delegate = self
        self.popupApplyCodeController = popupController
        popupController.present(animated: true)
    }
    
//    button back action
    @objc func buttonBackAction(_ sender: UIButton) {
        
//        self.button.removeFromSuperview()
//        self.viewPopupApplyCoupon.removeFromSuperview()
    }
    
    @IBAction func buttonCheckOutAction(_ sender: UIButton) {
        
        let totalAmount = (Double(self.labelPayableAmount.text!.dropFirst(1)) != nil) ? Double(self.labelPayableAmount.text!.dropFirst(1))! : 0.0
        if totalAmount < self.minimumOrderLimit {
            var stringMessage = (self.appDelegate.languageData["MIN_DELIVERY_LIMIT"] as? String != nil) ? (self.appDelegate.languageData["MIN_DELIVERY_LIMIT"] as! String).trim() : "Sorry! Delivery is available at this address more then $ amount."
            stringMessage = stringMessage.replacingOccurrences(of: "$", with: "\(ConstantStrings.RUPEES_SYMBOL)\(minimumOrderLimit)")
            self.showToastWithMessage(self.view, stringMessage)
        }else {
            if self.orderType == 0 {
                self.showToastWithMessage(self.view, ConstantStrings.PLEASE_SELECT_ORDER_TYPE)
            }else {
                if self.orderType == self.DELIVERY_TYPE {
                    if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
                        let branchVC = BranchesViewController.init(nibName: "BranchesViewController", bundle: nil)
                        branchVC.isMovedFromCartPage = true
                        branchVC.isOrderTypeDelivery = true
                        branchVC.orderType = self.orderType
                        branchVC.orderTypeString = self.orderTypeString
                        branchVC.placeOrderUrl = self.setupUrlAndValueForOrderPlace()
                        branchVC.totalAmount = String(self.labelPayableAmount.text!.dropFirst(1))
                        self.navigationController?.pushViewController(branchVC, animated: true)
                    }else {
                        let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
                        loginVC.isMoveFromMenuOrCart = true
                        self.navigationController?.pushViewController(loginVC, animated: true)
                    }
                }else if self.orderType == self.DINING_TYPE {
                    let arrayNewItem = self.filterNewAddedItemInCartForSendOrder()
                    if self.kitchenOrderID.isEmpty && arrayNewItem.count == 0 {
                        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
                            self.webApiSendOrderToKitchen()
                        }else {
                            let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
                            loginVC.isMoveFromMenuOrCart = true
                            self.navigationController?.pushViewController(loginVC, animated: true)
                        }
                    }else if !self.kitchenOrderID.isEmpty && arrayNewItem.count > 0 {
                        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
                            self.webApiAddNewItemToKitchen()
                        }else {
                            let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
                            loginVC.isMoveFromMenuOrCart = true
                            self.navigationController?.pushViewController(loginVC, animated: true)
                        }
                    }else {
                        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
                            let branchDetials = UserDefaultOperations.getDictionaryObject(ConstantStrings.SELECTED_EAT_IN_BRANCH) as! Dictionary<String, String>
                            let branchID = branchDetials[JSONKey.BRANCH_ID]!
                            var placeOrderUrl = self.setupUrlAndValueForOrderPlace()
                            placeOrderUrl = placeOrderUrl.replacingOccurrences(of: self.SELECTED_BRANCH_ID, with: branchID)
                            let paymentVC = PaymentViewController.init(nibName: "PaymentViewController", bundle: nil)
                            paymentVC.orderTypeString = self.orderTypeString
                            paymentVC.selectedAddressID = ""
                            paymentVC.isDirectMoveFromCart = true
                            paymentVC.placeOrderUrlString = placeOrderUrl
                            paymentVC.totalAmount = String(self.labelPayableAmount.text!.dropFirst(1))
                            self.navigationController?.pushViewController(paymentVC, animated: true)
                        }else {
                            let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
                            loginVC.isMoveFromMenuOrCart = true
                            self.navigationController?.pushViewController(loginVC, animated: true)
                        }
                    }
                }else {
                    if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
                        let branchVC = BranchesViewController.init(nibName: "BranchesViewController", bundle: nil)
                        branchVC.isMovedFromCartPage = true
                        branchVC.selectedAddressID = ""
                        branchVC.orderTypeString = self.orderTypeString
                        branchVC.placeOrderUrl = self.setupUrlAndValueForOrderPlace()
                        branchVC.totalAmount = String(self.labelPayableAmount.text!.dropFirst(1))
                        self.navigationController?.pushViewController(branchVC, animated: true)
                    }else {
                        let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
                        loginVC.isMoveFromMenuOrCart = true
                        self.navigationController?.pushViewController(loginVC, animated: true)
                    }
                }
            }
        }
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
        let subTotalAmount = String(self.labelSubtotalAmount.text!.dropFirst(1))
        let restaurantDiscountAmount = String(self.labelRestaurantDiscountAmount.text!.dropFirst(1))
        let deliveryChargeAmount = String(self.labelRestaurantDiscountAmount.text!.dropFirst(1))
        var customerID = userDetails.userID
        let totalAmount = String(self.labelPayableAmount.text!.dropFirst(1))
        var couponAmount = String(self.labelTotalCouponDiscountAmount.text!.dropFirst(1))
        let paymentProcessigFees = "0"
        var loyaltyPoints = String()
        var loyaltyPointsAmount = String()
        let foodCost = String(self.labelFoodItemAmount.text!.dropFirst(1))
        let getTotalItemDiscount = String(self.labelTotalFoodDiscountAmount.text!.dropFirst(1))
        let getFoodTaxTotal7 = self.calculate7PercentTax()
        let getFoodTaxTotal19 = self.calculate19PercentTax()
        let discountOfferFreeItems = "0"
        let totalSavedDiscount = "\(self.calculateTotalAllDiscountForShow())"
        
        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_LOYALTY_POINTS_REDEEMED) {
            loyaltyPoints = UserDefaultOperations.getStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS)
            loyaltyPointsAmount = UserDefaultOperations.getStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS_AMOUNT)
        }else {
            loyaltyPoints = ""
            loyaltyPointsAmount = ""
        }
        
        if self.couponCode.isEmpty {
            couponAmount = ""
        }
        var tableID = String()
        var personCount = String()
        if self.orderType == self.DINING_TYPE {
            tableID = self.selectedTableID
            personCount = UserDefaultOperations.getStringObject(ConstantStrings.TABLE_PERSON_COUNT)
        }else {
            tableID = ""
            personCount = ""
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: date)
//        dateFormatter.dateFormat = "hh:mm a"
//        let currentTime = dateFormatter.string(from: date)
        
        for itemDetails in self.arrayCartItems {
            var sizeID = itemDetails[JSONKey.ITEM_SIZE_ID]!
            if sizeID.isEmpty {
                sizeID = "0"
            }
            if itemID.isEmpty {
                
                itemID = itemDetails[JSONKey.ITEM_ID]!
                itemQuantity = itemDetails[JSONKey.ITEM_QUANTITY]!
                itemPrice = itemDetails[JSONKey.ITEM_OFFER_PRICE]!
                if !(itemDetails[JSONKey.ITEM_SIZE_ID]?.isEmpty)! {
                    
                    if itemSizeID.isEmpty {
                        
                        itemSizeID = "\(itemID)_\(sizeID)"
                    }else {
                        
                        itemSizeID.append(",\(itemID)_\(sizeID)")
                    }
                }
                if !(itemDetails[JSONKey.ITEM_EXTRA_ID]?.isEmpty)! {
                    
                    let arrayExtraIDs = itemDetails[JSONKey.ITEM_EXTRA_ID]!.components(separatedBy: "|")
                    for extraID in arrayExtraIDs {
                        
                        if itemExtraID.isEmpty {
                            
                            itemExtraID = "\(itemID)_\(sizeID)_\(extraID)"
                        }else {
                            
                            itemExtraID.append(",\(itemID)_\(sizeID)_\(extraID)")
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
                        
                        itemSizeID = "\(selectedItemId)_\(sizeID)"
                    }else {
                        
                        itemSizeID.append(",\(selectedItemId)_\(sizeID)")
                    }
                }
                if !(itemDetails[JSONKey.ITEM_EXTRA_ID]?.isEmpty)! {
                    
                    let arrayExtraIDs = itemDetails[JSONKey.ITEM_EXTRA_ID]!.components(separatedBy: "|")
                    for extraID in arrayExtraIDs {
                        
                        if itemExtraID.isEmpty {
                            
                            itemExtraID = "\(selectedItemId)_\(sizeID)_\(extraID)"
                        }else {
                            
                            itemExtraID.append(",\(selectedItemId)_\(sizeID)_\(extraID)")
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
        
        let url = WebApi.BASE_URL + "phpexpert_payment_android_submit.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&payment_transaction_paypal=&mealID=&mealquqntity=&mealPrice=&itemId=\(itemID)&Quantity=\(itemQuantity)&Price=\(itemPrice)&strsizeid=\(itemSizeID)&extraItemID=\(itemExtraID)&CustomerId=\(customerID)&CustomerAddressId=CUSTOMER_ADDRESS_ID&payment_type=PAYMENT_TYPE_STRING&order_price=\(totalAmount)&subTotalAmount=\(subTotalAmount)&delivery_date=\(currentDate)&delivery_time=ORDER_TIME&instructions=&deliveryCharge=\(deliveryChargeAmount)&CouponCode=\(self.couponCode)&CouponCodePrice=\(couponAmount)&couponCodeType=&SalesTaxAmount=\(saleTaxAmount)&order_type=\(self.orderTypeString)&SpecialInstruction=SPECIAL_INSTRUCTION&extraTipAddAmount=\(tipAmount)&RestaurantNameEstimate=&discountOfferDescription=&discountOfferPrice=\(restaurantDiscountAmount)&RestaurantoffrType=&ServiceFees=\(serviceFeesAmount)&PaymentProcessingFees=\(paymentProcessigFees)&deliveryChargeValueType=&ServiceFeesType=&PackageFeesType=&PackageFees=\(packageFeesAmount)&WebsiteCodePrice=&WebsiteCodeType=&WebsiteCodeNo=&preorderTime=&VatTax=\(vatTaxAmount)&GiftCardPay=&WalletPay=&loyptamount=\(loyaltyPointsAmount)&table_number_assign=\(tableID)&customer_country=&group_member_id=&loyltPnts=\(loyaltyPoints)&branch_id=SELECTED_BRANCH_ID&FoodCosts=\(foodCost)&getTotalItemDiscount=\(getTotalItemDiscount)&getFoodTaxTotal7=\(getFoodTaxTotal7)&getFoodTaxTotal19=\(getFoodTaxTotal19)&TotalSavedDiscount=\(totalSavedDiscount)&discountOfferFreeItems=\(discountOfferFreeItems)&number_of_people=\(personCount)"
        print("Url for place order : ", url)
        return url
    }
    
//    Func send order to kitchen Url
    func setupSendOrderURL() -> String {
            
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
        let subTotalAmount = String(self.labelSubtotalAmount.text!.dropFirst(1))
        let restaurantDiscountAmount = String(self.labelRestaurantDiscountAmount.text!.dropFirst(1))
        let deliveryChargeAmount = String(self.labelRestaurantDiscountAmount.text!.dropFirst(1))
        var customerID = userDetails.userID
        let totalAmount = String(self.labelPayableAmount.text!.dropFirst(1))
        var couponAmount = String(self.labelTotalCouponDiscountAmount.text!.dropFirst(1))
        let paymentProcessigFees = "0"
        var loyaltyPoints = String()
        var loyaltyPointsAmount = String()
        let foodCost = String(self.labelFoodItemAmount.text!.dropFirst(1))
        let getTotalItemDiscount = String(self.labelTotalFoodDiscountAmount.text!.dropFirst(1))
        let getFoodTaxTotal7 = self.calculate7PercentTax()
        let getFoodTaxTotal19 = self.calculate19PercentTax()
        let discountOfferFreeItems = "0"
        let totalSavedDiscount = "\(self.calculateTotalAllDiscountForShow())"
        
        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_LOYALTY_POINTS_REDEEMED) {
            
            loyaltyPoints = UserDefaultOperations.getStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS)
            loyaltyPointsAmount = UserDefaultOperations.getStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS_AMOUNT)
        }else {
            
            loyaltyPoints = ""
            loyaltyPointsAmount = ""
        }
        
        if self.couponCode.isEmpty {
            
            couponAmount = ""
        }
        var tableID = String()
        var personCount = String()
        if self.orderType == self.DINING_TYPE {
            tableID = self.selectedTableID
            personCount = UserDefaultOperations.getStringObject(ConstantStrings.TABLE_PERSON_COUNT)
        }else {
            personCount = ""
            tableID = ""
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: date)
        for itemDetails in self.arrayCartItems {
            var sizeID = itemDetails[JSONKey.ITEM_SIZE_ID]!
            if sizeID.isEmpty {
                sizeID = "0"
            }
            if itemID.isEmpty {
                
                itemID = itemDetails[JSONKey.ITEM_ID]!
                itemQuantity = itemDetails[JSONKey.ITEM_QUANTITY]!
                itemPrice = itemDetails[JSONKey.ITEM_OFFER_PRICE]!
                if !(itemDetails[JSONKey.ITEM_SIZE_ID]?.isEmpty)! {
                    
                    if itemSizeID.isEmpty {
                        
                        itemSizeID = "\(itemID)_\(sizeID)"
                    }else {
                        
                        itemSizeID.append(",\(itemID)_\(sizeID)")
                    }
                }
                if !(itemDetails[JSONKey.ITEM_EXTRA_ID]?.isEmpty)! {
                    
                    let arrayExtraIDs = itemDetails[JSONKey.ITEM_EXTRA_ID]!.components(separatedBy: "|")
                    for extraID in arrayExtraIDs {
                        
                        if itemExtraID.isEmpty {
                            
                            itemExtraID = "\(itemID)_\(sizeID)_\(extraID)"
                        }else {
                            
                            itemExtraID.append(",\(itemID)_\(sizeID)_\(extraID)")
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
                        
                        itemSizeID = "\(selectedItemId)_\(sizeID)"
                    }else {
                        
                        itemSizeID.append(",\(selectedItemId)_\(sizeID)")
                    }
                }
                if !(itemDetails[JSONKey.ITEM_EXTRA_ID]?.isEmpty)! {
                    
                    let arrayExtraIDs = itemDetails[JSONKey.ITEM_EXTRA_ID]!.components(separatedBy: "|")
                    for extraID in arrayExtraIDs {
                        
                        if itemExtraID.isEmpty {
                            
                            itemExtraID = "\(selectedItemId)_\(sizeID)_\(extraID)"
                        }else {
                            
                            itemExtraID.append(",\(selectedItemId)_\(sizeID)_\(extraID)")
                        }
                    }
                }
            }
        }
        let branchDetails = UserDefaultOperations.getDictionaryObject(ConstantStrings.SELECTED_EAT_IN_BRANCH)
        let branchID = (branchDetails[JSONKey.BRANCH_ID] as? Int != nil) ? String(branchDetails[JSONKey.BRANCH_ID] as! Int) : "0"
        if userDetails.userID.isEmpty {
            
            if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
                
                self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
                customerID = self.userDetails.userID
            }
        }
        dateFormatter.dateFormat = "hh:mm a"
        let currentTime = dateFormatter.string(from: Date())
        
        let url = WebApi.BASE_URL + "phpexpert_payment_Eat_In_Order.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&payment_transaction_paypal=&mealID=&mealquqntity=&mealPrice=&itemId=\(itemID)&Quantity=\(itemQuantity)&Price=\(itemPrice)&strsizeid=\(itemSizeID)&extraItemID=\(itemExtraID)&CustomerId=\(customerID)&CustomerAddressId=&payment_type=&order_price=\(totalAmount)&subTotalAmount=\(subTotalAmount)&delivery_date=\(currentDate)&delivery_time=\(currentTime)&instructions=&deliveryCharge=\(deliveryChargeAmount)&CouponCode=\(self.couponCode)&CouponCodePrice=\(couponAmount)&couponCodeType=&SalesTaxAmount=\(saleTaxAmount)&order_type=\(self.orderTypeString)&SpecialInstruction=&extraTipAddAmount=\(tipAmount)&RestaurantNameEstimate=&discountOfferDescription=&discountOfferPrice=\(restaurantDiscountAmount)&RestaurantoffrType=&ServiceFees=\(serviceFeesAmount)&PaymentProcessingFees=\(paymentProcessigFees)&deliveryChargeValueType=&ServiceFeesType=&PackageFeesType=&PackageFees=\(packageFeesAmount)&WebsiteCodePrice=&WebsiteCodeType=&WebsiteCodeNo=&preorderTime=&VatTax=\(vatTaxAmount)&GiftCardPay=&WalletPay=&loyptamount=\(loyaltyPointsAmount)&table_number_assign=\(tableID)&customer_country=&group_member_id=&loyltPnts=\(loyaltyPoints)&branch_id=\(branchID)&FoodCosts=\(foodCost)&getTotalItemDiscount=\(getTotalItemDiscount)&getFoodTaxTotal7=\(getFoodTaxTotal7)&getFoodTaxTotal19=\(getFoodTaxTotal19)&TotalSavedDiscount=\(totalSavedDiscount)&discountOfferFreeItems=\(discountOfferFreeItems)&number_of_people=\(personCount)"
        print("Url for place order : ", url)
        return url
    }
    
//    Func send order to kitchen Url for add new item
    func setupSendAddNewItemInOrderURL() -> String {
            
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
        let subTotalAmount = String(self.labelSubtotalAmount.text!.dropFirst(1))
        let restaurantDiscountAmount = String(self.labelRestaurantDiscountAmount.text!.dropFirst(1))
        let deliveryChargeAmount = String(self.labelRestaurantDiscountAmount.text!.dropFirst(1))
        var customerID = userDetails.userID
        let totalAmount = String(self.labelPayableAmount.text!.dropFirst(1))
        var couponAmount = String(self.labelTotalCouponDiscountAmount.text!.dropFirst(1))
        let paymentProcessigFees = "0"
        var loyaltyPoints = String()
        var loyaltyPointsAmount = String()
        let foodCost = String(self.labelFoodItemAmount.text!.dropFirst(1))
        let getTotalItemDiscount = String(self.labelTotalFoodDiscountAmount.text!.dropFirst(1))
        let getFoodTaxTotal7 = self.calculate7PercentTax()
        let getFoodTaxTotal19 = self.calculate19PercentTax()
        let discountOfferFreeItems = "0"
        let totalSavedDiscount = "\(self.calculateTotalAllDiscountForShow())"
        
        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_LOYALTY_POINTS_REDEEMED) {
            
            loyaltyPoints = UserDefaultOperations.getStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS)
            loyaltyPointsAmount = UserDefaultOperations.getStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS_AMOUNT)
        }else {
            
            loyaltyPoints = ""
            loyaltyPointsAmount = ""
        }
        
        if self.couponCode.isEmpty {
            
            couponAmount = ""
        }
        var tableID = String()
        var personCount = String()
        if self.orderType == self.DINING_TYPE {
            tableID = self.selectedTableID
            personCount = UserDefaultOperations.getStringObject(ConstantStrings.TABLE_PERSON_COUNT)
        }else {
            personCount = ""
            tableID = ""
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: date)
        let arrayNewItem = self.filterNewAddedItemInCartForSendOrder()
        for itemDetails in arrayNewItem {
            var sizeID = itemDetails[JSONKey.ITEM_SIZE_ID]!
            if sizeID.isEmpty {
                sizeID = "0"
            }
            if itemID.isEmpty {
                
                itemID = itemDetails[JSONKey.ITEM_ID]!
                itemQuantity = itemDetails[JSONKey.ITEM_QUANTITY]!
                itemPrice = itemDetails[JSONKey.ITEM_OFFER_PRICE]!
                if !(itemDetails[JSONKey.ITEM_SIZE_ID]?.isEmpty)! {
                    
                    if itemSizeID.isEmpty {
                        
                        itemSizeID = "\(itemID)_\(sizeID)"
                    }else {
                        
                        itemSizeID.append(",\(itemID)_\(sizeID)")
                    }
                }
                if !(itemDetails[JSONKey.ITEM_EXTRA_ID]?.isEmpty)! {
                    
                    let arrayExtraIDs = itemDetails[JSONKey.ITEM_EXTRA_ID]!.components(separatedBy: "|")
                    for extraID in arrayExtraIDs {
                        
                        if itemExtraID.isEmpty {
                            
                            itemExtraID = "\(itemID)_\(sizeID)_\(extraID)"
                        }else {
                            
                            itemExtraID.append(",\(itemID)_\(sizeID)_\(extraID)")
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
                        
                        itemSizeID = "\(selectedItemId)_\(sizeID)"
                    }else {
                        
                        itemSizeID.append(",\(selectedItemId)_\(sizeID)")
                    }
                }
                if !(itemDetails[JSONKey.ITEM_EXTRA_ID]?.isEmpty)! {
                    
                    let arrayExtraIDs = itemDetails[JSONKey.ITEM_EXTRA_ID]!.components(separatedBy: "|")
                    for extraID in arrayExtraIDs {
                        
                        if itemExtraID.isEmpty {
                            
                            itemExtraID = "\(selectedItemId)_\(sizeID)_\(extraID)"
                        }else {
                            
                            itemExtraID.append(",\(selectedItemId)_\(sizeID)_\(extraID)")
                        }
                    }
                }
            }
        }
        let branchDetails = UserDefaultOperations.getDictionaryObject(ConstantStrings.SELECTED_EAT_IN_BRANCH)
        let branchID = (branchDetails[JSONKey.BRANCH_ID] as? Int != nil) ? String(branchDetails[JSONKey.BRANCH_ID] as! Int) : "0"
        if userDetails.userID.isEmpty {
            
            if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
                
                self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
                customerID = self.userDetails.userID
            }
        }
        dateFormatter.dateFormat = "hh:mm a"
        let currentTime = dateFormatter.string(from: Date())
        
        let url = WebApi.BASE_URL + "phpexpert_EAT_In_Order_Send.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&payment_transaction_paypal=&mealID=&mealquqntity=&mealPrice=&itemId=\(itemID)&Quantity=\(itemQuantity)&Price=\(itemPrice)&strsizeid=\(itemSizeID)&extraItemID=\(itemExtraID)&CustomerId=\(customerID)&CustomerAddressId=&payment_type=&order_price=\(totalAmount)&subTotalAmount=\(subTotalAmount)&delivery_date=\(currentDate)&delivery_time=\(currentTime)&instructions=&deliveryCharge=\(deliveryChargeAmount)&CouponCode=\(self.couponCode)&CouponCodePrice=\(couponAmount)&couponCodeType=&SalesTaxAmount=\(saleTaxAmount)&order_type=\(self.orderTypeString)&SpecialInstruction=&extraTipAddAmount=\(tipAmount)&RestaurantNameEstimate=&discountOfferDescription=&discountOfferPrice=\(restaurantDiscountAmount)&RestaurantoffrType=&ServiceFees=\(serviceFeesAmount)&PaymentProcessingFees=\(paymentProcessigFees)&deliveryChargeValueType=&ServiceFeesType=&PackageFeesType=&PackageFees=\(packageFeesAmount)&WebsiteCodePrice=&WebsiteCodeType=&WebsiteCodeNo=&preorderTime=&VatTax=\(vatTaxAmount)&GiftCardPay=&WalletPay=&loyptamount=\(loyaltyPointsAmount)&table_number_assign=\(tableID)&customer_country=&group_member_id=&loyltPnts=\(loyaltyPoints)&branch_id=\(branchID)&FoodCosts=\(foodCost)&getTotalItemDiscount=\(getTotalItemDiscount)&getFoodTaxTotal7=\(getFoodTaxTotal7)&getFoodTaxTotal19=\(getFoodTaxTotal19)&TotalSavedDiscount=\(totalSavedDiscount)&discountOfferFreeItems=\(discountOfferFreeItems)&order_identifyno=\(self.kitchenOrderID)&number_of_people=\(personCount)"
        print("Url for place order : ", url)
        return url
    }
    
    @IBAction func buttonRedeemLoyalityPointClicked(_ sender: UIButton) {
        
        if UserDefaultOperations.getStringObject(ConstantStrings.LOYALTY_POINTS).isEmpty || UserDefaultOperations.getStringObject(ConstantStrings.LOYALTY_POINTS) == "0" {
            
            self.showToastWithMessage(self.view, ConstantStrings.YOU_HAVE_ZERO_LOYALTY_POINTS)
        }else {
            
            self.setupLoyaltyPointPopup()
        }
    }
    
    @IBAction func buttonActionForRedeemLoyaltyPointsSubmit(_ sender: UIButton) {
        
        self.viewLoyaltyPointsPopup.endEditing(true)
        if self.textFieldLoyaltyPoints.text!.isEmpty {
            
            self.showToastWithMessage(self.viewLoyaltyPointsPopup, ConstantStrings.LOYALTY_POINT_FIELD_IS_REQUIRED)
            self.textFieldLoyaltyPoints.becomeFirstResponder()
            return
        }
        if self.textFieldLoyaltyPoints.text!.trim() == "0" {
            
            self.showToastWithMessage(self.viewLoyaltyPointsPopup, ConstantStrings.PLEASE_ENTER_MORE_THAN_POINTS)
            return
        }
        
//        let subTotal = Double(self.labelTotalPayAmount.text!.dropFirst(1))!
        let loyaltyPoints = Double(self.textFieldLoyaltyPoints.text!)!
//        if loyaltyPoints > subTotal {
//
//            self.showToastWithMessage(self.viewLoyaltyPointsPopup, "Redeem points should be less than total amount.")
//            return
//        }
        
        let myLoyaltyPoints = (Double(UserDefaultOperations.getStringObject(ConstantStrings.LOYALTY_POINTS)) != nil) ? Double(UserDefaultOperations.getStringObject(ConstantStrings.LOYALTY_POINTS))! : 0.00
        if myLoyaltyPoints < loyaltyPoints {
            
            self.showToastWithMessage(self.viewLoyaltyPointsPopup, ConstantStrings.YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS)
        }
        self.webApiRedeemLoyaltyPoints()
    }
    
    @IBAction func buttonRemoveLoyaltyPointsViewAction(_ sender: UIButton) {
        
        self.popLoyaltyPointsController?.dismiss(animated: true)
    }
    
    @IBAction func buttonRemoveOrderTypeAction(_ sender: UIButton) {
        
        self.popupController?.dismiss(animated: true)
    }
    
    func setupLoyaltyPointPopup() -> Void {
        
        UtilityMethods.addBorderAndShadow(self.viewLoyaltyPointsPopup, 10.0)
        UtilityMethods.addBorderAndShadow(self.buttonRedeem, self.buttonRedeem.bounds.height / 2)
        self.textFieldLoyaltyPoints.text = ""
        self.viewLoyaltyPointsPopup.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        var loyalityPointsCount = (self.appDelegate.languageData["YOU_HAVE_ZERO_LOYALTY_POINTS"] as? String != nil) ? (self.appDelegate.languageData["YOU_HAVE_ZERO_LOYALTY_POINTS"] as! String).trim() : "You have zero loyalty points"
        loyalityPointsCount = loyalityPointsCount.replacingOccurrences(of: "zero", with: "\(UserDefaultOperations.getStringObject(ConstantStrings.LOYALTY_POINTS))")
        self.labelLoyaltyPointsCount.text = loyalityPointsCount

        self.labelLoyaltyPointsCount.font = UIFont.systemFont(ofSize: 13.0)
        self.viewLoyaltyPointsPopup.frame = CGRect.init(x: 15, y: 0, width: UIScreen.main.bounds.width - 30, height: self.LOYALTY_POINTS_POP_UP_HEIGHT)
        
        let popupController = CNPPopupController(contents:[self.viewLoyaltyPointsPopup])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = CNPPopupStyle.centered
        // LFL added settings for custom color and blur
        popupController.theme.backgroundColor = .clear
        popupController.theme.maskType = .dimmed
        popupController.delegate = self
        self.popLoyaltyPointsController = popupController
        popupController.present(animated: true)
    }
    
    @IBAction func buttonApplyCouponValidateAction(_ sender: UIButton) {
        
        if self.textFieldApplyCoupon.text!.isEmpty {
            
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.APPLY_COUPON_IS_REQUIRED)
        }else {
            
            self.viewPopupApplyCoupon.endEditing(false)
            let subtotal = String(self.labelFoodItemAmount.text!.dropFirst(1))
            self.webApiVerifyCoupon(self.textFieldApplyCoupon.text!, subtotal)
        }
    }
    
    //    MARK:- Web Api Code Start
//    Get Verify coupon and discount the price
    func webApiVerifyCoupon(_ coupon : String, _ subTotal : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.viewPopupApplyCoupon, animated: true)
        let url = WebApi.BASE_URL + "couponCode.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&subTotal=\(subTotal)&CouponCodePrice=&couponCodeType=&CouponCode=\(coupon)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.viewPopupApplyCoupon, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupApplyCouponDiscount(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup And apply coupon discount
    func setupApplyCouponDiscount(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int != 0 {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    self.popupApplyCodeController?.dismiss(animated: true)
                    self.showToastWithMessage(self.view, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }else {
                
                if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
                    
                    if jsonDictionary[JSONKey.ERROR_CODE] as! Int == 0 {
                        
                        self.couponCode = self.textFieldApplyCoupon.text!
                        self.popupApplyCodeController?.dismiss(animated: true)
                        self.showToastWithMessage(self.view, ConstantStrings.YOUR_COUPON_HAS_BEEN_APPLIED_SUCCESSFULLY)
                        
                        if jsonDictionary[JSONKey.COUPON_CODE_PRICE] as? String != nil {
                            
                            self.heightApplyCouponView.constant = 0.5
                            self.topMarginApplyCoupon.constant = 0.5
                            self.viewApplyCoupon.isHidden = true
                            
                            let couponCodePrice = (jsonDictionary[JSONKey.COUPON_CODE_PRICE] as! String)
                            UserDefaultOperations.setBoolObject(ConstantStrings.IS_COUPON_APPLIED, true)
                            UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_COUPON_CODE, self.couponCode)
                            UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_COUPON_AMOUNT, couponCodePrice)
                            self.labelTotalCouponDiscountAmount.text = ConstantStrings.RUPEES_SYMBOL + couponCodePrice
                            self.calculateAndSetupBillDetails()
                            self.webApiGetServiceCharge(String(self.labelSubtotalAmount.text!.dropFirst(1)))
                        }
                    }
                }
            }
        }
    }
    
//    Get Restaurant discount the price
    func webApiGetRestaurantDiscount(_ subTotal : String, _ orderType : Int) -> Void {
        
        var orderTypeString = String()
        
        if orderType == self.DELIVERY_TYPE {
            
            orderTypeString = self.DELIVER_STRING
        }else if orderType == self.PICKUP_TYPE {
            
            orderTypeString = self.PICKUP_STRING
        }else {
            
            orderTypeString = self.DINING_STRING
        }
//        For some time
//        orderTypeString = "Delivery"
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        let url = WebApi.BASE_URL + "discountGet.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&subTotal=\(subTotal)&Order_Type=\(orderTypeString)"
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
                self.calculateAndSetupBillDetails()
                print("Restaurant Discount : ", self.labelRestaurantDiscountAmount.text!)
                
                self.webApiGetServiceCharge(String(self.labelSubtotalAmount.text!.dropFirst(1)))
            }
        }
    }
    
//    Get service charge of the price
    func webApiGetServiceCharge(_ subTotal : String) -> Void {
        
        //        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "ServiceChargetGet.php?subTotal=\(subTotal)&api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&restaurant_locality&Order_Type=\(self.orderTypeString)"
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
    
    func setupServiceCharges(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary["deliveryChargeValue"] as? String != nil {
            
            if self.orderType == self.DELIVERY_TYPE {
                
                let deliveryAmount = (Double(self.stringDeliveryCharge) != nil) ? Double(self.stringDeliveryCharge)! : 0.00
                self.labelDeliveryFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", deliveryAmount)
            }else {
                
                var deliveryAmount = (Double(jsonDictionary["deliveryChargeValue"] as! String) != nil) ? Double(jsonDictionary["deliveryChargeValue"] as! String)! : 0.00
                if self.orderType != ConstantStrings.ORDER_TYPE_DELIVERY {
                    
                    deliveryAmount = 0.00
                }
                self.labelDeliveryFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", deliveryAmount)
            }
        }else {
            
            self.hideViewWith(self.viewDeliveryValue, self.labelDeliveryFee, self.labelDeliveryFeesAmount, self.heightDeliveryView)
        }
        if jsonDictionary["SeviceFeesValue"] as? String != nil {
            
            let amount = (Double(jsonDictionary["SeviceFeesValue"] as! String) != nil) ? Double(jsonDictionary["SeviceFeesValue"] as! String)! : 0.00
            self.labelServiceFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", amount)
        }else {
            
            self.hideViewWith(self.viewServiceFees, self.labelServiceFees, self.labelServiceFeesAmount, self.heightServiceFeesView)
        }
        if jsonDictionary["PackageFeesValue"] as? String != nil {
            
            let amount = (Double(jsonDictionary["PackageFeesValue"] as! String) != nil) ? Double(jsonDictionary["PackageFeesValue"] as! String)! : 0.00
            self.labelPackageFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", amount)
        }else {
            
            self.hideViewWith(self.viewPackageFees, self.labelPackageFees, self.labelPackageFeesAmount, self.heightPackageFeesView)
        }
        if jsonDictionary["SalesTaxAmount"] as? String != nil {
            
            let amount = (Double(jsonDictionary["SalesTaxAmount"] as! String) != nil) ? Double(jsonDictionary["SalesTaxAmount"] as! String)! : 0.00
            self.labelSaleTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", amount)
        }else {
            
            self.hideViewWith(self.viewSaleTax, self.labelSaleTax, self.labelSaleTaxAmount, self.heightSaleTaxView)
        }
        if jsonDictionary["VatTax"] as? String != nil {
            
            let amount = (Double(jsonDictionary["VatTax"] as! String) != nil) ? Double(jsonDictionary["VatTax"] as! String)! : 0.00
            self.labelVatTaxAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", amount)
        }else {
            
            self.hideViewWith(self.viewVatTax, self.labelVatTax, self.labelVatTaxAmount, self.heightVatTaxView)
        }
        
//        Hide Or show view for value
        self.setupAllBillDetailsView()
        
        print("Get Service Charge Callled...")
        self.buttonCheckout.isUserInteractionEnabled = true
        self.buttonCheckout.backgroundColor = .clear
        self.calculateAndSetupBillDetails()
    }
    
    //    Get postal code details
    func webApiPostalCodeDetails(_ postalCode : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.viewPostalCode, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_postcode_validator.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&Order_Type=Delivery&Postcode=\(postalCode)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.viewPostalCode, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupPostalcodeDetails(json.dictionaryObject!)
                }
            }
        }
    }
    
    //    Func setup Postal Code Details
    func setupPostalcodeDetails(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int == 0 {
                
                var dictionaryPostalCode = Dictionary<String, String>()
                dictionaryPostalCode[JSONKey.POSTALCODE_CITY] = (jsonDictionary[JSONKey.POSTALCODE_CITY] as? String != nil) ? (jsonDictionary[JSONKey.POSTALCODE_CITY] as? String) : ""
                dictionaryPostalCode[JSONKey.POSTALCODE_MINIMUM_ORDER] = (jsonDictionary[JSONKey.POSTALCODE_MINIMUM_ORDER] as? String != nil) ? (jsonDictionary[JSONKey.POSTALCODE_MINIMUM_ORDER] as! String) : ""
                dictionaryPostalCode[JSONKey.POSTALCODE_SHIPPING_CHARGE] = (jsonDictionary[JSONKey.POSTALCODE_SHIPPING_CHARGE] as? String != nil) ? (jsonDictionary[JSONKey.POSTALCODE_SHIPPING_CHARGE] as! String) : ""
                dictionaryPostalCode[JSONKey.POSTALCODE_DELIVERY_CHARGE] = (jsonDictionary[JSONKey.POSTALCODE_DELIVERY_CHARGE] as? String != nil) ? (jsonDictionary[JSONKey.POSTALCODE_DELIVERY_CHARGE] as! String) : ""
                dictionaryPostalCode[JSONKey.POSTALCODE_POSTAL_CODE] = (jsonDictionary[JSONKey.POSTALCODE_POSTAL_CODE] as? String != nil) ? (jsonDictionary[JSONKey.POSTALCODE_POSTAL_CODE] as! String) : ""
                self.stringDeliveryCharge = (jsonDictionary[JSONKey.POSTALCODE_DELIVERY_CHARGE] as? String != nil) ? ((jsonDictionary[JSONKey.POSTALCODE_DELIVERY_CHARGE] as? String)!) : ""
                
                if Double(dictionaryPostalCode[JSONKey.POSTALCODE_MINIMUM_ORDER]!) != nil {
                    
                    self.minimumOrderLimit = Double(dictionaryPostalCode[JSONKey.POSTALCODE_MINIMUM_ORDER]!)!
                }
                
                self.labelDeliveryFeesAmount.text = ConstantStrings.RUPEES_SYMBOL + self.stringDeliveryCharge
                self.setupAllBillDetailsView()
                self.calculateAndSetupBillDetails()
                
                UserDefaultOperations.setDictionaryObject(ConstantStrings.POSTAL_CODE_INFO, dictionaryPostalCode)
                UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, ConstantStrings.ORDER_TYPE_DELIVERY)
                self.popupController?.dismiss(animated: true)
                self.orderType = self.DELIVERY_TYPE
//                self.setupOrderType(self.orderType)
                self.collectionView.reloadData()
                UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, self.orderType)
                self.webApiGetRestaurantDiscount(String(self.labelFoodItemAmount.text!.dropFirst(1)), self.orderType)
                let message =  (self.appDelegate.languageData["We_offer_delivery_to_your_postcode"] as? String != nil) ? (self.appDelegate.languageData["We_offer_delivery_to_your_postcode"] as! String).trim() : "We offer delivery to your postcode."
                self.showToastWithMessage(self.view, message)
            }else {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }else {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.ENTER_VALID_POSTAL_CODE)
                }
            }
        }else {
            
            if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
            }else {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.ENTER_VALID_POSTAL_CODE)
            }
        }
    }
    
    //    Get loyalty Points
    func webApiGetLoyaltyPoints() -> Void {
        
        let url = WebApi.BASE_URL + "phpexpert_customer_loyalty_point.php?lang_code=\(WebApi.LANGUAGE_CODE)&api_key=\(WebApi.API_KEY)&CustomerId=\(self.userDetails.userID)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            if json.isEmpty {
                
//                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
//                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupLoyaltyPoints(json.dictionaryObject!)
                }
            }
        }
    }
    
    //    Func setup Loyalty Points
    func setupLoyaltyPoints(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 0 {
                
                if jsonDictionary[JSONKey.TOTAL_LOYALTY_POINTS] as? String != nil {
                    
                    self.labelLoyaltyPoints.text = (jsonDictionary[JSONKey.TOTAL_LOYALTY_POINTS] as! String)
                    UserDefaultOperations.setStringObject(ConstantStrings.LOYALTY_POINTS, jsonDictionary[JSONKey.TOTAL_LOYALTY_POINTS] as! String)
                }
            }
        }
    }
    
//    Redeem loyalty Points
    func webApiRedeemLoyaltyPoints() -> Void {
        
        MBProgressHUD.showAdded(to: self.viewLoyaltyPointsPopup, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_loyalty_point_redeem.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&CustomerId=\(self.userDetails.userID)&loyltPnts=\(self.textFieldLoyaltyPoints.text!)&TotalFoodCostAmount=\(Double(self.labelTotalPayAmount.text!.dropFirst(1)) ?? 0.00)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
        MBProgressHUD.hide(for: self.viewLoyaltyPointsPopup, animated: true)
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupRedeemedLoyaltyPoints(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Func setup Redeem Loyalty Points
    func setupRedeemedLoyaltyPoints(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 0 {
                
                self.hideRedeemLoyaltyPointsView()
                
                let loyaltyAmount = (jsonDictionary[JSONKey.TOTAL_LOYALTY_AMOUNT] as? String != nil) ? (jsonDictionary[JSONKey.TOTAL_LOYALTY_AMOUNT] as! String) : "0.00"
                
                UserDefaultOperations.setBoolObject(ConstantStrings.IS_LOYALTY_POINTS_REDEEMED, true)
                UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS, self.textFieldLoyaltyPoints.text!)
                UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS_AMOUNT, loyaltyAmount)
                self.labelLoyaltyPointAmount.text = "-" + ConstantStrings.RUPEES_SYMBOL + loyaltyAmount
                self.showViewWith(self.viewLoyaltyPoints, self.labelLoyaltyPoint, self.labelLoyaltyPointAmount, self.heightLoyaltyPointView)
                self.popLoyaltyPointsController?.dismiss(animated: true)
                self.calculateAndSetupBillDetails()
                self.webApiGetServiceCharge(String(self.labelSubtotalAmount.text!.dropFirst(1)))
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    
                    self.showToastWithMessage(self.view, jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String)
                }
            }else {
                
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    
                    self.showToastWithMessage(self.viewLoyaltyPointsPopup, jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String)
                }
            }
        }
    }
    
//    Show popup for Order Type
    func setupViewPopupAnimation() -> Void {
        self.viewPostalCode.backgroundColor = .clear
        if self.orderType == self.DELIVERY_TYPE {
            self.labelPostalCode.isHidden = false
            self.textFieldPostalCode.isHidden = false
            self.viewBottomPostalCode.isHidden = false
            self.textFieldPostalCode.isUserInteractionEnabled = true
            self.textFieldPostalCode.becomeFirstResponder()
            self.heightPostalTextFieldView.constant = self.POSTAL_TEXT_FIELD_VIEW_HEIGHT
        }else if self.orderType == self.PICKUP_TYPE {
            self.textFieldPostalCode.text = ""
            self.labelPostalCode.isHidden = true
            self.textFieldPostalCode.isHidden = true
            self.viewBottomPostalCode.isHidden = true
            self.textFieldPostalCode.isUserInteractionEnabled = false
            self.heightPostalTextFieldView.constant = 0.5
        }else if self.orderType == self.DINING_TYPE {
            self.textFieldPostalCode.text = ""
            self.labelPostalCode.isHidden = true
            self.textFieldPostalCode.isHidden = true
            self.viewBottomPostalCode.isHidden = true
            self.textFieldPostalCode.isUserInteractionEnabled = false
            self.heightPostalTextFieldView.constant = 0.5
        }
        self.selectedPostalCodeOrderType = self.orderType
        self.collectionViewPopup.reloadData()
        UtilityMethods.addBorderAndShadow(self.viewPostalCode, 10.0)
        UtilityMethods.addBorderAndShadow(self.buttonSubmitPostalCode, self.buttonSubmitPostalCode.bounds.height / 2)
        self.viewPostalCode.backgroundColor = .clear
        self.textFieldPostalCode.text = ""
        self.viewPostalCode.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewPostalCode.frame = CGRect.init(x: 15, y: 0, width: UIScreen.main.bounds.width - 30, height: self.HEIGHT_POSTAL_CODE_VIEW)
        
        let popupController = CNPPopupController(contents:[self.viewPostalCode])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = CNPPopupStyle.centered
        // LFL added settings for custom color and blur
        popupController.theme.backgroundColor = .clear
        popupController.theme.maskType = .dimmed
        popupController.delegate = self
        self.popupController = popupController
        popupController.present(animated: true)
    }
    
    func popupControllerWillDismiss(_ controller: CNPPopupController) {
        
        print("Popup controller will be dismissed...")
    }
    
    func popupControllerDidPresent(_ controller: CNPPopupController) {
        
        print("Popup controller presented...")
    }
    
//    Get Latitude and logitude for current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        self.checkForCurrentRestaurant(locValue.latitude, locValue.longitude)
        self.currentLocationLatitude = locValue.latitude
        self.currentLocationLongitude = locValue.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error \(error)")
    }
    
    func checkForCurrentRestaurant(_ lat : Double, _ long : Double) -> Bool {
        
        var branchIndex = Int()
        var isMatchedBranch =  Bool()
        let arrayBranch = UserDefaultOperations.getArrayObject(ConstantStrings.RESTAURANT_BRANCH_LIST) as! Array<Dictionary<String, String>>
        for branch in arrayBranch {
            
            let restaurantLat = Double(branch[JSONKey.BRANCH_LATITUDE]!)!
            let restaurantLong = Double(branch[JSONKey.BRANCH_LONGITUDE]!)!
            print("Distance between coordinates : ", self.isAvailableInRestaurant(lat, long, restaurantLat, restaurantLong))
            if self.isAvailableInRestaurant(lat, long, restaurantLat, restaurantLong) {
                isMatchedBranch = true
                break
            }
            branchIndex += 1
        }
        if isMatchedBranch {
            let branchDetails = arrayBranch[branchIndex]
            UserDefaultOperations.setDictionaryObject(ConstantStrings.SELECTED_EAT_IN_BRANCH, branchDetails)
            return true
        }else {
            return false
        }
    }
    
    func webApiSendOrderToKitchen() -> Void {
        print("New Order added to the kitchen.")
        let url = self.setupSendOrderURL()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        WebApi.webApiForGetRequest(updatedUrl) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json[JSONKey.ERROR_CODE] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupSendOrderUrlData(json.dictionaryObject!)
                }
            }
        }
    }
    
    func webApiAddNewItemToKitchen() -> Void {
        
        print("New Item added to the kitchen.")
        let url = self.setupSendAddNewItemInOrderURL()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        WebApi.webApiForGetRequest(updatedUrl) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json[JSONKey.ERROR_CODE] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupSendOrderUrlData(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupSendOrderUrlData(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        if jsonDictionary[JSONKey.ORDER_ID] as? String != nil {
            let orderID = jsonDictionary[JSONKey.ORDER_ID] as! String
            UserDefaultOperations.setStringObject(ConstantStrings.SEND_ORDER_KITCHEN_ID, orderID)
            UserDefaultOperations.setArrayObject(ConstantStrings.SEND_ORDER_KITCHEN_LIST, self.arrayCartItems)
            self.kitchenOrderID = orderID
            self.showToastWithMessage(self.view, ConstantStrings.ORDER_SENT_TO_THE_KITCHEN)
            self.labelCheckout.text = (self.appDelegate.languageData["Checkout"] as? String != nil) ? (self.appDelegate.languageData["Checkout"] as! String).trim() : "Checkout"
            if self.kitchenOrderID.isEmpty {
                self.tableView.tableFooterView = UIView()
            }else {
                self.tableView.tableFooterView = self.setupTableViewFooter()
            }
            print(ConstantStrings.ORDER_SENT_TO_THE_KITCHEN)
        }
    }
    
    var arrayNewOrderList = Array<Dictionary<String, String>>()
    func filterNewAddedItemInCartForSendOrder() -> Array<Dictionary<String, String>> {
        
        let kitchenOrderList = UserDefaultOperations.getArrayObject(ConstantStrings.SEND_ORDER_KITCHEN_LIST) as! Array<Dictionary<String, String>>
        var arrayNewItemList = Array<Dictionary<String, String>>()
        if kitchenOrderList.count == 0 {
            return arrayNewItemList
        }
        self.arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST) as! Array<Dictionary<String, String>>
        for cartItem in self.arrayCartItems {
            var isMatched = Bool()
            for kitchenItem in kitchenOrderList {
                let cartOrderID = cartItem[JSONKey.ITEM_ID]!
                let kitchenOrderID = kitchenItem[JSONKey.ITEM_ID]!
                let cartSizeID = cartItem[JSONKey.ITEM_SIZE_ID]!
                let kitchenSizeID = kitchenItem[JSONKey.ITEM_SIZE_ID]!
                let cartExtraID = cartItem[JSONKey.ITEM_EXTRA_ID]!
                let kitchenExtraID = kitchenItem[JSONKey.ITEM_EXTRA_ID]!
                if (cartOrderID == kitchenOrderID) && (cartSizeID == kitchenSizeID) && (cartExtraID == kitchenExtraID) {
                    let cartQuantity = Int(cartItem[JSONKey.ITEM_QUANTITY]!)!
                    let kitchenQuantity = Int(kitchenItem[JSONKey.ITEM_QUANTITY]!)!
                    if cartQuantity > kitchenQuantity {
                        let newQuantity = cartQuantity - kitchenQuantity
                        var dictionaryNewItem = cartItem
                        dictionaryNewItem[JSONKey.ITEM_QUANTITY] = "\(newQuantity)"
                        let totalAmount = (Double(dictionaryNewItem[JSONKey.ITEM_UPDATED_PRICE]!)!) * (Double(newQuantity))
                        dictionaryNewItem[JSONKey.ITEM_CART_PRICE] = String(format: "%.2f", totalAmount)
                        let totalOriginalAmount = (Double(dictionaryNewItem[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE]!)!) * (Double(newQuantity))
                        dictionaryNewItem[JSONKey.ITEM_CART_ORIGINAL_PRICE] = String(format: "%.2f", totalOriginalAmount)
                        arrayNewItemList.append(dictionaryNewItem)
                    }
                    isMatched = true
                }
            }
            if !isMatched {
                arrayNewItemList.append(cartItem)
            }
        }
        print(arrayNewItemList.count)
        return arrayNewItemList
    }
}

extension CartViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrayOrderType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewPopup {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.ORDER_TYPE_POPUP_CELL, for: indexPath) as! OrderTypePopupCollectionViewCell
            let dictionaryOrderType = self.arrayOrderType[indexPath.row]
            
            cell.labelOrderType.text = (dictionaryOrderType[self.ORDER_TYPE_NAME] as! String)
            if (dictionaryOrderType[self.ORDER_TYPE_ID] as! Int) == self.selectedPostalCodeOrderType {
                
                cell.labelOrderType.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
                UtilityMethods.addBorder(cell.viewBg, Colors.colorWithHexString(Colors.GREEN_COLOR), 5.0)
            }else {
                
                cell.labelOrderType.textColor = .lightGray
                UtilityMethods.addBorder(cell.viewBg, .lightGray, 5.0)
            }
            
            return cell
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.ORDER_TYPE_CELL, for: indexPath) as! OrderTypeCollectionViewCell
            let dictionaryOrderType = self.arrayOrderType[indexPath.row]
            cell.labelOrderType.text = (dictionaryOrderType[self.ORDER_TYPE_NAME] as! String)
            cell.imageViewOrderType.image = UIImage.init(named: dictionaryOrderType[self.ORDER_TYPE_IMAGE] as! String)
            
            if (dictionaryOrderType[self.ORDER_TYPE_ID] as! Int) == self.orderType {
                
                self.orderTypeString = (dictionaryOrderType[self.ORDER_TYPE_STRING_VALUE] as! String)
                UtilityMethods.changeImageColor(cell.imageViewOrderType, .white)
                cell.labelOrderType.textColor = .white
                cell.viewBg.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
            }else {
                
                UtilityMethods.changeImageColor(cell.imageViewOrderType, .darkGray)
                cell.labelOrderType.textColor = .darkGray
                cell.viewBg.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !self.kitchenOrderID.isEmpty {
            return
        }
        let dictionaryOrder = self.arrayOrderType[indexPath.row]
        if collectionView == self.collectionViewPopup {
            
            if (dictionaryOrder[self.ORDER_TYPE_ID] as! Int) == self.DELIVERY_TYPE {
                
                self.labelPostalCode.isHidden = false
                self.textFieldPostalCode.isHidden = false
                self.viewBottomPostalCode.isHidden = false
                self.textFieldPostalCode.isUserInteractionEnabled = true
                self.textFieldPostalCode.becomeFirstResponder()
                self.heightPostalTextFieldView.constant = self.POSTAL_TEXT_FIELD_VIEW_HEIGHT
                self.viewPostalContainer.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth - 30, height: self.HEIGHT_POSTAL_CODE_VIEW)
                self.selectedPostalCodeOrderType = (dictionaryOrder[self.ORDER_TYPE_ID] as! Int)
                self.collectionViewPopup.reloadData()
            }else if (dictionaryOrder[self.ORDER_TYPE_ID] as! Int) == self.PICKUP_TYPE {
                
                self.textFieldPostalCode.text = ""
                self.labelPostalCode.isHidden = true
                self.textFieldPostalCode.isHidden = true
                self.viewBottomPostalCode.isHidden = true
                self.textFieldPostalCode.isUserInteractionEnabled = false
                self.heightPostalTextFieldView.constant = 0.5
                self.viewPostalContainer.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth - 30, height: self.HEIGHT_POSTAL_CODE_VIEW - self.POSTAL_TEXT_FIELD_VIEW_HEIGHT)
                self.selectedPostalCodeOrderType = (dictionaryOrder[self.ORDER_TYPE_ID] as! Int)
                self.collectionViewPopup.reloadData()
            }else if (dictionaryOrder[self.ORDER_TYPE_ID] as! Int) == self.DINING_TYPE {
                
                if self.checkForCurrentRestaurant(self.currentLocationLatitude, self.currentLocationLongitude) {
                    self.textFieldPostalCode.text = ""
                    self.labelPostalCode.isHidden = true
                    self.textFieldPostalCode.isHidden = true
                    self.viewBottomPostalCode.isHidden = true
                    self.textFieldPostalCode.isUserInteractionEnabled = false
                    self.heightPostalTextFieldView.constant = 0.5
                    self.viewPostalContainer.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth - 30, height: self.HEIGHT_POSTAL_CODE_VIEW - self.POSTAL_TEXT_FIELD_VIEW_HEIGHT)
                    self.selectedPostalCodeOrderType = (dictionaryOrder[self.ORDER_TYPE_ID] as! Int)
                    self.collectionViewPopup.reloadData()
                }else {
                    self.showToastWithMessage(self.view, ConstantStrings.YOU_ARE_NOT_AVAILABLE_AT_ANY_BRANCH)
                }
            }
        }else {
            
            if dictionaryOrder[ORDER_TYPE_ID] as! Int == self.DELIVERY_TYPE {
                let postalCodeInfo = UserDefaultOperations.getDictionaryObject(ConstantStrings.POSTAL_CODE_INFO)
                let orderType = UserDefaultOperations.getIntValue(ConstantStrings.ORDER_TYPE_VALUE)
                if (postalCodeInfo.isEmpty) && (orderType != self.DELIVERY_TYPE) {
                    self.setupViewPopupAnimation()
                }else {
                    self.orderType = (dictionaryOrder[self.ORDER_TYPE_ID] as! Int)
                    self.collectionView.reloadData()
                    UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, self.orderType)
                    self.webApiGetRestaurantDiscount(String(self.labelFoodItemAmount.text!.dropFirst(1)), self.orderType)
                }
            }else if dictionaryOrder[ORDER_TYPE_ID] as! Int == self.PICKUP_TYPE {
                
                self.orderType = (dictionaryOrder[self.ORDER_TYPE_ID] as! Int)
                self.collectionView.reloadData()
                UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, self.orderType)
                self.webApiGetRestaurantDiscount(String(self.labelFoodItemAmount.text!.dropFirst(1)), self.orderType)
            }else if dictionaryOrder[ORDER_TYPE_ID] as! Int == self.DINING_TYPE {
                
                if self.checkForCurrentRestaurant(self.currentLocationLatitude, self.currentLocationLongitude) {
                    self.setupSelectTablePopup()
                }else {
                    self.showToastWithMessage(self.view, ConstantStrings.YOU_ARE_NOT_AVAILABLE_AT_ANY_BRANCH)
                }
            }
        }
        if self.orderType == ConstantStrings.ORDER_TYPE_DINING {
            self.labelCheckout.text = ConstantStrings.SEND_ORDER_TO_KITCHEN
        }else {
            self.labelCheckout.text = (self.appDelegate.languageData["Checkout"] as? String != nil) ? (self.appDelegate.languageData["Checkout"] as! String).trim() : "Checkout"
            self.tableView.tableFooterView = UIView()
            self.tableView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionViewPopup {
            
            let width = CGFloat(((self.screenWidth - 90) / 3))
            let height : CGFloat = 40
            return CGSize.init(width: width, height: height)
        }else {
            
            let width = ((self.screenWidth - 60) / 3)
            let height = width * 0.75
            return CGSize.init(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
}
