//
//  PayNowPaymentViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 26/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class PayNowPaymentViewController: BaseViewController, PayPalPaymentDelegate {

    @IBOutlet weak var labelAmountToBePaid: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var labelSelectPaymentMethod: UILabel!
    @IBOutlet weak var buttonPayNow: UIButton!
    
    @IBOutlet weak var viewPaypal: UIView!
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var viewCashOnDelivery: UIView!
    
    @IBOutlet weak var imageViewCardSelect: UIImageView!
    @IBOutlet weak var imageViewPaypalSelect: UIImageView!
    @IBOutlet weak var imageViewCashOnDeliverySelect: UIImageView!
    
    @IBOutlet weak var imageViewCard: UIImageView!
    @IBOutlet weak var imageViewPaypal: UIImageView!
    @IBOutlet weak var imageViewCash: UIImageView!
    
    @IBOutlet weak var topMarginCard: NSLayoutConstraint!
    @IBOutlet weak var topMarginPaypal: NSLayoutConstraint!
    @IBOutlet weak var topMarginCash: NSLayoutConstraint!
    
    @IBOutlet weak var viewHeightCard: NSLayoutConstraint!
    @IBOutlet weak var viewHeightPaypal: NSLayoutConstraint!
    @IBOutlet weak var heightCashOnDelivery: NSLayoutConstraint!
    
    @IBOutlet weak var labelCard: UILabel!
    @IBOutlet weak var labelPaypal: UILabel!
    @IBOutlet weak var labelCashOnDelivery: UILabel!
    
    @IBOutlet weak var buttonCard: UIButton!
    @IBOutlet weak var buttonPaypal: UIButton!
    @IBOutlet weak var buttonCash: UIButton!
    
    var paymentMode = 0
    var totalAmount = String()
    var orderPlaceUrl = String()
    var paymentTypeString = String()
    var userDetails = UserDetails()
    var selectedOrderID = String()
    var orderDetails = Dictionary<String, String>()
    var restaurantInfo = RestaurantInfo()
    
    let PAYPAL = 1
    let CARD = 2
    let WALLET = 3
    let CASH_OF_DELIVERY = 4
    let CORNER_RADIUS : CGFloat = 5.0
    let HEIGHT_PAYMENT_METHOD : CGFloat = 60.0
    let PAYMENT_TYPE_STRING = "PAYMENT_TYPE_STRING"
//    Paypal
    var payPalConfig = PayPalConfiguration()
    var environment:String = PayPalEnvironmentNoNetwork {
      willSet(newEnvironment) {
        if (newEnvironment != environment) {
          PayPalMobile.preconnect(withEnvironment: newEnvironment)
        }
      }
    }
    var acceptCreditCart : Bool = true {
        didSet {
            
            payPalConfig.acceptCreditCards = acceptCreditCart
        }
    }
    var resultText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    override func viewDidLayoutSubviews() {
            
        UtilityMethods.addBorderAndShadow(self.viewPaypal, self.CORNER_RADIUS)
        UtilityMethods.addBorderAndShadow(self.viewCard, self.CORNER_RADIUS)
        UtilityMethods.addBorderAndShadow(self.viewCashOnDelivery, self.CORNER_RADIUS)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = "Payment"
        self.setupBackBarButton()
        self.labelTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + self.totalAmount
        self.labelSelectPaymentMethod.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as? RestaurantInfo != nil {
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        self.setupPaymentMethod()
        self.buttonPayNow.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        
        self.viewPaypal.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewCard.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewCashOnDelivery.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        
//        Paypal setup
        let privacyPolicyUrl = WebApi.BASE_URL + "privacy_statement_web.php"
        let userAggreementUrl = WebApi.BASE_URL + "terms_of_use_web.php"
        payPalConfig.acceptCreditCards = self.acceptCreditCart
        payPalConfig.merchantName = self.restaurantInfo.restaurantName
        payPalConfig.merchantPrivacyPolicyURL = URL(string: privacyPolicyUrl)
        payPalConfig.merchantUserAgreementURL = URL(string: userAggreementUrl)
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    func setupPaymentMethod() -> Void {
        
        self.topMarginCash.constant = 0.5
        self.hidePaymentMethodView(self.imageViewCashOnDeliverySelect, self.labelCashOnDelivery, imageViewCash, self.viewCashOnDelivery, heightCashOnDelivery, self.buttonCash)
//        if self.restaurantInfo.isCashOnDeliveryAvailable {
//
//            self.topMarginCash.constant = 15.0
//            self.showPaymentMethodView(self.imageViewCashOnDeliverySelect, self.labelCashOnDelivery, imageViewCash, self.viewCashOnDelivery, heightCashOnDelivery, self.buttonCash)
//        }else {
//
//            self.topMarginCash.constant = 0.5
//            self.hidePaymentMethodView(self.imageViewCashOnDeliverySelect, self.labelCashOnDelivery, imageViewCash, self.viewCashOnDelivery, heightCashOnDelivery, self.buttonCash)
//        }
        if self.restaurantInfo.isOnlinePaymentAvailable {
            
            self.topMarginPaypal.constant = 15.0
            self.showPaymentMethodView(self.imageViewPaypalSelect, self.labelPaypal, imageViewPaypal, self.viewPaypal, viewHeightPaypal, self.buttonPaypal)
            self.showPaymentMethodView(self.imageViewCardSelect, self.labelCard, imageViewCard, self.viewCard, viewHeightCard, self.buttonCard)
        }else {
            
            self.topMarginPaypal.constant = 0.5
            self.topMarginCash.constant = 0.5
            self.hidePaymentMethodView(self.imageViewPaypalSelect, self.labelPaypal, imageViewPaypal, self.viewPaypal, viewHeightPaypal, self.buttonPaypal)
            self.hidePaymentMethodView(self.imageViewCardSelect, self.labelCard, imageViewCard, self.viewCard, viewHeightCard, self.buttonCard)
        }
    }
    
//    Hide payment method
    func hidePaymentMethodView(_ imageViewSelect : UIImageView, _ labelPaymentName : UILabel, _ imageViewPaymentMethod : UIImageView, _ viewPaymentMethod : UIView, _ viewHeight : NSLayoutConstraint, _ buttonPayment : UIButton) -> Void {
        
        imageViewSelect.isHidden = true
        labelPaymentName.isHidden = true
        imageViewPaymentMethod.isHidden = true
        viewHeight.constant = 0.5
        buttonPayment.isUserInteractionEnabled = false
        viewPaymentMethod.isHidden = true
    }
    
//    Show payment method
    func showPaymentMethodView(_ imageViewSelect : UIImageView, _ labelPaymentName : UILabel, _ imageViewPaymentMethod : UIImageView, _ viewPaymentMethod : UIView, _ viewHeight : NSLayoutConstraint, _ buttonPayment : UIButton) -> Void {
        
        imageViewSelect.isHidden = false
        labelPaymentName.isHidden = false
        imageViewPaymentMethod.isHidden = false
        viewHeight.constant = self.HEIGHT_PAYMENT_METHOD
        buttonPayment.isUserInteractionEnabled = true
        viewPaymentMethod.isHidden = false
    }
    
//    MARK:- Button Action for payment method selection
    @IBAction func buttonSelectPaypalPaymentAction(_ sender: UIButton) {
        
        self.paymentMode = self.PAYPAL
        self.paymentTypeString = "Online"
        self.imageViewCashOnDeliverySelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewPaypalSelect.image = UIImage(named: ConstantStrings.SELECTED_ADDRESS_IMAGE)
        self.imageViewCardSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
    }
    
    @IBAction func buttonSelectCardPaymentAction(_ sender: UIButton) {
        
        self.paymentMode = self.CARD
        self.paymentTypeString = "Card"
        self.imageViewCashOnDeliverySelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewPaypalSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewCardSelect.image = UIImage(named: ConstantStrings.SELECTED_ADDRESS_IMAGE)
    }
    
    @IBAction func buttonSelectCashOnDeliveryPaymentAction(_ sender: UIButton) {
        
        self.paymentTypeString = "Cash"
        self.paymentMode = self.CASH_OF_DELIVERY
        self.imageViewCashOnDeliverySelect.image = UIImage(named: ConstantStrings.SELECTED_ADDRESS_IMAGE)
        self.imageViewPaypalSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewCardSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
    }
    
//    Button Action For Pay
    @IBAction func buttonPayAction(_ sender: UIButton) {

        if self.paymentMode == 0 {
            
            self.showToastWithMessage(self.view, ConstantStrings.PLEASE_SELECT_PAYMENT_MODE)
        }else {
            
            if self.paymentMode == self.CARD {
                
                let stripeVC = StripePayLaterPaymentViewController.init(nibName: "StripePayLaterPaymentViewController", bundle: nil)
                stripeVC.totalAmount = self.totalAmount
                stripeVC.placeOrderUrl = self.orderPlaceUrl
                stripeVC.paymentTypeString = self.paymentTypeString
                stripeVC.selectedOrderID = self.selectedOrderID
                self.navigationController?.pushViewController(stripeVC, animated: true)
            }else if self.paymentMode == self.CASH_OF_DELIVERY {
                
                self.callPlaceOrderApi()
            }else if self.paymentMode == self.PAYPAL {
                
                self.setupPaypalPaymentGatway()
            }
        }
    }
    
    func callPlaceOrderApi() -> Void {
        
        if self.orderPlaceUrl.isEmpty {
            self.webApiPlaceOrderWithModify()
        }else {
            self.orderPlaceUrl = self.orderPlaceUrl.replacingOccurrences(of: self.PAYMENT_TYPE_STRING, with: self.paymentTypeString)
            self.webApiPlaceOrder(self.orderPlaceUrl)
        }
    }
    
//    MARK:- Setup Paypal Payment Gateway
//    Func setup Paypal gateway
    func setupPaypalPaymentGatway() -> Void {
      // Remove our last completed payment, just for demo purposes.
      resultText = ""
      
        let subtotal = NSDecimalNumber(string: self.totalAmount)
      
      // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
      let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
      
        let total = subtotal.adding(shipping).adding(tax)
      
        let payment = PayPalPayment(amount: total, currencyCode: UserDefaultOperations.getStringObject(ConstantStrings.COUNTRY_CODE), shortDescription: "Food", intent: .sale)
      
        payment.paymentDetails = paymentDetails
      
        if (payment.processable) {
        let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
        present(paymentViewController!, animated: true, completion: nil)
      }
      else {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
        print("Payment not processalbe: \(payment)")
      }
    }
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
      print("PayPal Payment Cancelled")
      resultText = ""
      paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
      print("PayPal Payment Success !")
      paymentViewController.dismiss(animated: true, completion: { () -> Void in
        // send completed confirmaion to your server
        print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
        
        self.resultText = completedPayment.description
        self.callPlaceOrderApi()
      })
    }
    
//    MARK:- Web Api Code
//    Web Api for place order
    func webApiPlaceOrder(_ url : String) -> Void {
        
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
                    
                    self.setupUserDetails(json.dictionaryObject!)
                }
            }
        }
    }
    
    //    func for setup user details
    func setupUserDetails(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int != 0 {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }
        }else {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
                
                if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 1 {
                    
                    if jsonDictionary["order_identifyno"] as? String != nil {
                        
                        arrayGlobalPayLaterList.removeAll()
                        let orderID = jsonDictionary["order_identifyno"] as! String
                        let thankyouVC = ThankyouViewController.init(nibName: "ThankyouViewController", bundle: nil)
                        thankyouVC.orderID = String(orderID)
                        thankyouVC.isMovedFromPayNow = true
                        self.navigationController?.pushViewController(thankyouVC, animated: true)
                    }else {
                        
                        self.showToastWithMessage(self.view, ConstantStrings.YOUR_ORDER_COULD_NOT_PLACED)
                    }
                }
            }
        }
    }
    
//    Place order with modify the order with new items
    func webApiPlaceOrderWithModify() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_payment_pay_later_direct.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&order_identifyno=\(self.selectedOrderID)&payment_transaction_paypal=&CustomerId=\(self.userDetails.userID)&payment_type=\(self.paymentTypeString)&order_price=\(self.totalAmount)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json[JSONKey.ERROR_CODE] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupUserDetails(json.dictionaryObject!)
                }
            }
        }
    }
}
