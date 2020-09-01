//
//  ConfirmationTableViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 18/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class ConfirmationTableViewController: BaseViewController, PayPalPaymentDelegate {

    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var viewPaypal: UIView!
//    @IBOutlet weak var viewCashOnDelivery: UIView!
    @IBOutlet weak var imageViewCardSelect: UIImageView!
    @IBOutlet weak var imageViewPaypalSelect: UIImageView!
//    @IBOutlet weak var imageViewCashOnDeliverySelect: UIImageView!
    @IBOutlet weak var imageViewCard: UIImageView!
    @IBOutlet weak var imageViewPaypal: UIImageView!
//    @IBOutlet weak var imageViewCash: UIImageView!
    @IBOutlet weak var labelCard: UILabel!
    @IBOutlet weak var labelPaypal: UILabel!
//    @IBOutlet weak var labelCashOnDelivery: UILabel!
    @IBOutlet weak var heightCardView: NSLayoutConstraint!
    @IBOutlet weak var heightPaypalView: NSLayoutConstraint!
//    @IBOutlet weak var heightCashOnDeliveryView: NSLayoutConstraint!
    
    @IBOutlet weak var labelTableName : UILabel!
    @IBOutlet weak var labelTableNameValue : UILabel!
    @IBOutlet weak var labelBookingDate : UILabel!
    @IBOutlet weak var labelBookingDateValue : UILabel!
    @IBOutlet weak var labelBookingTime : UILabel!
    @IBOutlet weak var labelBookingTimeValue : UILabel!
    @IBOutlet weak var labelPersonCount : UILabel!
    @IBOutlet weak var labelPersonCountValue : UILabel!
    @IBOutlet weak var labelTotalBillAmount : UILabel!
    @IBOutlet weak var labelTotalBillAmountValue : UILabel!
    @IBOutlet weak var labelTotalDiscount : UILabel!
    @IBOutlet weak var labelTotalDiscountValue : UILabel!
    @IBOutlet weak var labelSubTotalAmount : UILabel!
    @IBOutlet weak var labelSubTotalAmountValue : UILabel!
    @IBOutlet weak var labelServiceCharge : UILabel!
    @IBOutlet weak var labelServiceChargeValue : UILabel!
    @IBOutlet weak var labelFinalBillAmount : UILabel!
    @IBOutlet weak var labelFinalBillAmountValue : UILabel!
    @IBOutlet weak var labelDepositAmount : UILabel!
    @IBOutlet weak var labelDepositAmountValue : UILabel!
    @IBOutlet weak var buttonConfirmAndPay: UIButton!
    @IBOutlet weak var imageViewTable: UIImageView!
    @IBOutlet weak var viewImageView: UIView!
    
    let PAYPAL = 1
    let CARD = 2
    let WALLET = 3
    let CASH_OF_DELIVERY = 4
    let PERCENTAGE_STRING = "PERCENTAGE"
    var ADD_PERCENTAGE = "(PERCENTAGE%)"
    var TABLE_NUMBER_STRING = "Table No - "
    var BOOKING_DATE_STRING = "Booking Date : "
    var BOOKING_TIME_STRING = "Booking Time : "
    var PERSON_COUN_STRING = "No of Person : "
    var TOTAL_AMOUNT_STRING = "Total Bill Amount : "
    var FINAL_AMOUNT_STRING = "Final Bill Amount : "
    var TOTAL_DISCOUNT_STRING = "Total Discount (PERCENTAGE%) : "
    var DEPOSIT_AMOUNT_STRING = "Deposit Amount for Booking (PERCENTAGE%) : "
    var SERVICE_CHARGE_STRING = "Service Charge (PERCENTAGE%) : "
    var SUB_TOTAL_AMOUNT_STRING = "SubTotal After Discount : "
    
    var selectedTableID = String()
    var paymentMode = 0
    var userDetails = UserDetails()
    var tableName = String()
//    var totalAmount = String()
    var bookingDate = String()
    var bookingTime = String()
    var personCount = String()
    var finalAmount = String()
    var customerName = String()
//    var depositAmount = String()
//    var serviceCharge = String()
//    var subTotalAmount = String()
    var paymentTypeString = String()
    var specialInstruction = String()
    var customerContactNumber = String()
    var tableInformation = Dictionary<String, String>()
    var restaurantInfo = RestaurantInfo()
    var serviceCharge = String()
    var subTotalAmount = String()
    var totalBillAmount = String()
    var totalFinalAmount = String()
    var totalDepositAmount = String()
    var totalDiscountAmount = String()
    
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
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Confirmation_Booking"] as? String != nil) ? (self.appDelegate.languageData["Confirmation_Booking"] as! String).trim() : "Confirmation Booking"
        
        let tableNumber = (self.appDelegate.languageData["Table_No"] as? String != nil) ? (self.appDelegate.languageData["Table_No"] as! String).trim() : "Table Number"
        let bookingDate = (self.appDelegate.languageData["Booking_Date"] as? String != nil) ? (self.appDelegate.languageData["Booking_Date"] as! String).trim() : "Booking Date"
        let bookingTime = (self.appDelegate.languageData["Booking_Time"] as? String != nil) ? (self.appDelegate.languageData["Booking_Time"] as! String).trim() : "Booking Time"
        let noOfPerson = (self.appDelegate.languageData["No_of_Person"] as? String != nil) ? (self.appDelegate.languageData["No_of_Person"] as! String).trim() : "No. Of Person"
        let totalBillAmountString = (self.appDelegate.languageData["Total_Bill_Amount"] as? String != nil) ? (self.appDelegate.languageData["Total_Bill_Amount"] as! String).trim() : "Total Bill Amount"
        let finalBillAmount = (self.appDelegate.languageData["Final_Bill_Amount"] as? String != nil) ? (self.appDelegate.languageData["Final_Bill_Amount"] as! String).trim() : "Final Bill Amount"
        let totalDiscountString = (self.appDelegate.languageData["Total_Discount"] as? String != nil) ? (self.appDelegate.languageData["Total_Discount"] as! String).trim() : "Total Discount"
        let depositAmountString = (self.appDelegate.languageData["Deposit_Amount_for_Booking"] as? String != nil) ? (self.appDelegate.languageData["Deposit_Amount_for_Booking"] as! String).trim() : "Deposit Amount for Booking"
        let serviceCharge = (self.appDelegate.languageData["Service_Charge"] as? String != nil) ? (self.appDelegate.languageData["Service_Charge"] as! String).trim() : "Service Charge"
        let subtotalString = (self.appDelegate.languageData["Subtotal_After_Discount"] as? String != nil) ? (self.appDelegate.languageData["Subtotal_After_Discount"] as! String).trim() : "Subtotal After Discount"
        self.labelCard.text = (self.appDelegate.languageData["Credit_Debit_Card"] as? String != nil) ? (self.appDelegate.languageData["Credit_Debit_Card"] as! String).trim() : "Credit/Debit Card"
        self.labelPaypal.text = (self.appDelegate.languageData["Paypal"] as? String != nil) ? (self.appDelegate.languageData["Paypal"] as! String).trim() : "Paypal"
        let buttonMakePayment = (self.appDelegate.languageData["Confirm_and_Pay"] as? String != nil) ? (self.appDelegate.languageData["Confirm_and_Pay"] as! String).trim() : "Confirm and Pay"
        self.buttonConfirmAndPay.setTitle(buttonMakePayment, for: .normal)
        
        self.TABLE_NUMBER_STRING = tableNumber + " : "
        self.BOOKING_DATE_STRING = "\(bookingDate) : "
        self.BOOKING_TIME_STRING = "\(bookingTime) : "
        self.PERSON_COUN_STRING = "\(noOfPerson) : "
        self.TOTAL_AMOUNT_STRING = "\(totalBillAmountString) : "
        self.FINAL_AMOUNT_STRING = "\(finalBillAmount) : "
        self.TOTAL_DISCOUNT_STRING = "\(totalDiscountString) (PERCENTAGE%) : "
        self.DEPOSIT_AMOUNT_STRING = "\(depositAmountString) (PERCENTAGE%) : "
        self.SERVICE_CHARGE_STRING = "\(serviceCharge) (PERCENTAGE%) : "
        self.SUB_TOTAL_AMOUNT_STRING = "\(subtotalString) : "
        
        
        self.setupBackBarButton()
        self.buttonConfirmAndPay.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        var imageUrl = self.tableInformation[JSONKey.TABLE_IMAGE_ICON]!
        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
        self.imageViewTable.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "table"))
        self.buttonConfirmAndPay.setTitle(ConstantStrings.CONFIRM_AND_PAY, for: .normal)
        
        self.DEPOSIT_AMOUNT_STRING = self.DEPOSIT_AMOUNT_STRING.replacingOccurrences(of: self.PERCENTAGE_STRING, with: self.tableInformation[JSONKey.TABLE_MINIMUM_DIPOSIT_PERCENTAGE]!)
        self.SERVICE_CHARGE_STRING = self.SERVICE_CHARGE_STRING.replacingOccurrences(of: self.PERCENTAGE_STRING, with: self.tableInformation[JSONKey.TABLE_SERVICE_CHARGE]!)
        self.TOTAL_DISCOUNT_STRING = self.TOTAL_DISCOUNT_STRING.replacingOccurrences(of: self.PERCENTAGE_STRING, with: self.tableInformation[JSONKey.TABLE_DISCOUNT_PERCENTAGE]!)
        let totalBillAmount = Double(self.personCount)! * Double(self.tableInformation[JSONKey.TABLE_CHARGE_PER_PERSON]!)!
        let discount = Double(self.tableInformation[JSONKey.TABLE_DISCOUNT_PERCENTAGE]!)!
        let discountAmount = UtilityMethods.calculatePercentageAmount(discount, totalBillAmount)
        let subTotalAmount = totalBillAmount - discountAmount
        let serviceChargePercentage = Double(self.tableInformation[JSONKey.TABLE_SERVICE_CHARGE]!)!
        let serviceChargeAmount = UtilityMethods.calculatePercentageAmount(serviceChargePercentage, subTotalAmount)
        let finalAmount = subTotalAmount + serviceChargeAmount
        let depositPercentage = Double(self.tableInformation[JSONKey.TABLE_MINIMUM_DIPOSIT_PERCENTAGE]!)!
        let depositAmount = UtilityMethods.calculatePercentageAmount(depositPercentage, finalAmount)
        self.totalDepositAmount = String(format : "%.2f", depositAmount)
        self.serviceCharge = String(format : "%.2f", serviceChargeAmount)
        self.subTotalAmount = String(format : "%.2f", subTotalAmount)
        self.totalBillAmount = String(format : "%.2f", totalBillAmount)
        self.totalDiscountAmount = String(format : "%.2f", discountAmount)
        self.totalFinalAmount = String(format : "%.2f", finalAmount)
            
        self.labelTableName.text = self.TABLE_NUMBER_STRING
        self.labelBookingDate.text = self.BOOKING_DATE_STRING
        self.labelBookingTime.text = self.BOOKING_TIME_STRING
        self.labelPersonCount.text = self.PERSON_COUN_STRING
        self.labelTotalBillAmount.text = self.TOTAL_AMOUNT_STRING
        self.labelTotalDiscount.text = self.TOTAL_DISCOUNT_STRING
        self.labelSubTotalAmount.text = self.SUB_TOTAL_AMOUNT_STRING
        self.labelServiceCharge.text = self.SERVICE_CHARGE_STRING
        self.labelFinalBillAmount.text = self.FINAL_AMOUNT_STRING
        self.labelDepositAmount.text = self.DEPOSIT_AMOUNT_STRING
        
        self.labelTableNameValue.text = self.tableName
        self.labelBookingDateValue.text = self.bookingDate
        self.labelBookingTimeValue.text = self.bookingTime
        self.labelPersonCountValue.text = self.personCount
        self.labelTotalBillAmountValue.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", totalBillAmount)
        self.labelTotalDiscountValue.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", discountAmount)
        self.labelSubTotalAmountValue.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", subTotalAmount)
        self.labelServiceChargeValue.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", serviceChargeAmount)
        self.labelFinalBillAmountValue.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", finalAmount)
        self.labelDepositAmountValue.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", depositAmount)
        
        UtilityMethods.addBorderAndShadow(self.viewCard, 5.0)
        UtilityMethods.addBorderAndShadow(self.viewPaypal, 5.0)
        UtilityMethods.addBorder(self.viewImageView, .darkGray, self.viewImageView.layer.bounds.height / 2)
        self.viewCard.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewPaypal.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        self.labelTableName.attributedText = self.changeSelectedStringColor(self.labelTableName.text!, self.TABLE_NUMBER_STRING, .darkGray, 15.0)
        self.labelBookingDate.attributedText = self.changeSelectedStringColor(self.labelBookingDate.text!, self.BOOKING_DATE_STRING, .darkGray, 15.0)
        self.labelBookingTime.attributedText = self.changeSelectedStringColor(self.labelBookingTime.text!, self.BOOKING_TIME_STRING, .darkGray, 15.0)
        self.labelPersonCount.attributedText = self.changeSelectedStringColor(self.labelPersonCount.text!, self.PERSON_COUN_STRING, .darkGray, 15.0)
        self.labelTotalBillAmount.attributedText = self.changeSelectedStringColor(self.labelTotalBillAmount.text!, self.TOTAL_AMOUNT_STRING, .darkGray, 15.0)
        self.labelTotalDiscount.attributedText = self.changeSelectedStringColor(self.labelTotalDiscount.text!, self.TOTAL_DISCOUNT_STRING, .darkGray, 15.0)
        self.labelSubTotalAmount.attributedText = self.changeSelectedStringColor(self.labelSubTotalAmount.text!, self.SUB_TOTAL_AMOUNT_STRING, .darkGray, 15.0)
        self.labelServiceCharge.attributedText = self.changeSelectedStringColor(self.labelServiceCharge.text!, self.SERVICE_CHARGE_STRING, .darkGray, 15.0)
        self.labelFinalBillAmount.attributedText = self.changeSelectedStringColor(self.labelFinalBillAmount.text!, self.FINAL_AMOUNT_STRING, .darkGray, 15.0)
        self.labelDepositAmount.attributedText = self.changeSelectedStringColor(self.labelDepositAmount.text!, self.DEPOSIT_AMOUNT_STRING, .darkGray, 13.0)
        self.labelTableNameValue.attributedText = self.changeSelectedStringColor(self.labelTableNameValue.text!, "(\(self.tableInformation[JSONKey.TABLE_NAME]!))", .lightGray, 13.0)
        self.selectedTableID = self.tableInformation[JSONKey.TABLE_ID]!
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as? RestaurantInfo != nil {
            
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        
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
    
//    MARK:- Button Action
    //    Button Action for select payment mode
    @IBAction func buttonSelectCardPaymentAction(_ sender: UIButton) {
        
        self.paymentMode = self.CARD
        self.paymentTypeString = "Card"
//        self.imageViewCashOnDeliverySelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewPaypalSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewCardSelect.image = UIImage(named: ConstantStrings.SELECTED_ADDRESS_IMAGE)
    }
    
    @IBAction func buttonSelectPaypalPaymentAction(_ sender: UIButton) {
        
//        self.showToastWithMessage(self.view, "Only card payment available.")
        self.paymentMode = self.PAYPAL
//        self.imageViewCashOnDeliverySelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewPaypalSelect.image = UIImage(named: ConstantStrings.SELECTED_ADDRESS_IMAGE)
        self.imageViewCardSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
    }
    
    @IBAction func buttonSelectCashOnDeliveryPaymentAction(_ sender: UIButton) {
        
//        self.paymentTypeString = "Cash"
//        self.paymentMode = self.CASH_OF_DELIVERY
//        self.imageViewCashOnDeliverySelect.image = UIImage(named: ConstantStrings.SELECTED_ADDRESS_IMAGE)
//        self.imageViewPaypalSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
//        self.imageViewCardSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
    }
    
    @IBAction func buttonConfirmAndPayAction(_ sender: UIButton) {
        
        if self.paymentMode == 0 {
            self.showToastWithMessage(self.view, ConstantStrings.PLEASE_SELECT_PAYMENT_MODE)
        }else if self.paymentMode == self.PAYPAL {
            
            self.setupPaypalPaymentGatway()
        }else if self.paymentMode == self.CARD {
            let stripeTVC = StripeTableViewController.init(nibName: "StripeTableViewController", bundle: nil)
            stripeTVC.totalAmount = self.totalDepositAmount
            stripeTVC.tableInformation = self.tableInformation
            stripeTVC.specialInstruction = self.specialInstruction
            stripeTVC.personCount = self.personCount
            stripeTVC.tableID = self.tableInformation[JSONKey.TABLE_ID]!
            stripeTVC.bookingDate = self.bookingDate
            stripeTVC.tableName = self.tableName
            stripeTVC.bookingTime = self.bookingTime
            stripeTVC.serviceCharge = self.serviceCharge
            stripeTVC.subTotalAmount = self.subTotalAmount
            stripeTVC.totalBillAmount = self.totalBillAmount
            stripeTVC.totalFinalAmount = self.totalFinalAmount
            stripeTVC.totalDepositAmount = self.totalDepositAmount
            stripeTVC.totalDiscountAmount = self.totalDiscountAmount
            stripeTVC.cutomerContactNumber = self.customerContactNumber
            self.navigationController?.pushViewController(stripeTVC, animated: true)
        }
    }
    
//    Func setup Paypal gateway
    func setupPaypalPaymentGatway() -> Void {
      // Remove our last completed payment, just for demo purposes.
      resultText = ""
      
      // Optional: include multiple items
//      let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
//      let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
//      let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "Hip-00291")
//
//      let items = [item1, item2, item3]
        let subtotal = NSDecimalNumber(string: self.totalFinalAmount)
      
      // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
      let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
      
        let total = subtotal.adding(shipping).adding(tax)
      
        let payment = PayPalPayment(amount: total, currencyCode: UserDefaultOperations.getStringObject(ConstantStrings.COUNTRY_CODE), shortDescription: "Food", intent: .sale)
      
//        payment.items = items
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
        self.webApiBookATable()
      })
    }
    
//    MARK:- Web Api Code Start
//    Web Api Book Table
    func webApiBookATable() -> Void {
        
        let transactionNumber = self.userDetails.userID + "_\(Int(NSDate().timeIntervalSince1970))"
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_table_booking.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&CustomerId=\(self.userDetails.userID)&table_number_assign=\(self.selectedTableID)&booking_mobile=\(self.customerContactNumber)&booking_date=\(self.bookingDate)&booking_time=\(self.bookingTime)&booking_instruction=\(self.specialInstruction)&Number_of_person=\(self.personCount)&Total_bill_amount=\(self.totalBillAmount)&Total_bill_discount_amount=\(self.totalDiscountAmount)&Total_Sub_Total_after_discount=\(self.subTotalAmount)&Total_Service_Charge=\(self.serviceCharge)&Total_Final_Amount=\(self.totalFinalAmount)&Total_Deposit_Amount=\(self.totalDepositAmount)&Transaction_Number=\(transactionNumber)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupBookTableOnSuccessfull(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupBookTableOnSuccessfull(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 1 {
                
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    
//                    self.delegate?.showMessageBookedTable((jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String))
//                    self.navigationController?.popViewController(animated: true)
                    let thankyouVC = ThankyouTableViewController.init(nibName: "ThankyouTableViewController", bundle: nil)
                    thankyouVC.bookingDate = self.bookingDate
                    thankyouVC.bookingTime = self.bookingTime
                    thankyouVC.tableNumber = self.tableName
                    thankyouVC.bookingConfirmation = (jsonDictionary["success_msg"] as? String != nil) ? (jsonDictionary["success_msg"] as! String) : ""
                    thankyouVC.thankyouString = (jsonDictionary["Thankyou"] as? String != nil) ? (jsonDictionary["Thankyou"] as! String) : ""
                    thankyouVC.transactionNumber = (jsonDictionary["Transaction_Number"] as? String != nil) ? (jsonDictionary["Transaction_Number"] as! String) : "0"
                    thankyouVC.noteString = (jsonDictionary["Important_Note"] as? String != nil) ? (jsonDictionary["Important_Note"] as! String) : ""
                    thankyouVC.bookingNumber = (jsonDictionary["Booking_Number"] as? String != nil) ? (jsonDictionary["Booking_Number"] as! String) : "0"
                    self.navigationController?.pushViewController(thankyouVC, animated: true)
                }
            }else {
                
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    
                    self.showToastWithMessage(self.view, (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String))
                }
            }
        }
    }
}
