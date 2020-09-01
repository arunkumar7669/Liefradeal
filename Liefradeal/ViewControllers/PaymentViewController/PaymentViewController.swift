//
//  PaymentViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 17/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import CNPPopupController

class PaymentViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CNPPopupControllerDelegate, PayPalPaymentDelegate {
    
    @IBOutlet weak var labelAmountToBePaid: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var labelHowToPay: UILabel!
    @IBOutlet weak var viewPaypal: UIView!
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var viewCashOnDelivery: UIView!
    @IBOutlet weak var buttonPay: UIButton!
    @IBOutlet weak var imageViewPaypalSelect: UIImageView!
    @IBOutlet weak var imageViewCardSelect: UIImageView!
    @IBOutlet weak var imageViewCashOnDeliverySelect: UIImageView!
    @IBOutlet weak var viewWhenFood: UIView!
    @IBOutlet weak var heightWhenFoodView: NSLayoutConstraint!
    @IBOutlet weak var labelWhenFood: UILabel!
    @IBOutlet weak var imageViewSelectAsap: UIImageView!
    @IBOutlet weak var imageViewSelectLater: UIImageView!
    @IBOutlet weak var labelAsap: UILabel!
    @IBOutlet weak var labelLater: UILabel!
    @IBOutlet weak var viewSchedule: UIView!
    @IBOutlet weak var labelSchedule: UILabel!
    @IBOutlet weak var heightViewSchedule: NSLayoutConstraint!
    @IBOutlet weak var bottomMarginViewSchedule: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelAllergyInstruction: UILabel!
    @IBOutlet weak var textFieldInstruction: UITextField!
    @IBOutlet weak var heightCashOnDelivery: NSLayoutConstraint!
    @IBOutlet weak var viewHeightPaypal: NSLayoutConstraint!
    @IBOutlet weak var viewHeightCard: NSLayoutConstraint!
    @IBOutlet weak var imageViewCard: UIImageView!
    @IBOutlet weak var imageViewPaypal: UIImageView!
    @IBOutlet weak var imageViewCash: UIImageView!
    @IBOutlet weak var labelCashOnDelivery: UILabel!
    @IBOutlet weak var labelPaypal: UILabel!
    @IBOutlet weak var labelCard: UILabel!
    @IBOutlet weak var buttonCard: UIButton!
    @IBOutlet weak var buttonPaypal: UIButton!
    @IBOutlet weak var buttonCash: UIButton!
    @IBOutlet weak var topMarginCash: NSLayoutConstraint!
    @IBOutlet weak var topMarginPaypal: NSLayoutConstraint!
    @IBOutlet weak var topMarginCard: NSLayoutConstraint!
    @IBOutlet weak var heightPayLater: NSLayoutConstraint!
    @IBOutlet weak var imageViewPayLaterSelect: UIImageView!
    @IBOutlet weak var imageViewPayLater: UIImageView!
    @IBOutlet weak var labelPayLater: UILabel!
    @IBOutlet weak var viewPayLater: UIView!
    @IBOutlet weak var butttonPayLater: UIButton!
    @IBOutlet weak var heightAsapView: NSLayoutConstraint!
    @IBOutlet weak var topMarginPayLater: NSLayoutConstraint!
    @IBOutlet weak var topMarginASAPView: NSLayoutConstraint!
    @IBOutlet weak var buttonASAP: UIButton!
    @IBOutlet weak var buttonLater: UIButton!
    @IBOutlet weak var labelAllergyDetails: UILabel!
    @IBOutlet weak var labelDoYouHaveAllergy: UILabel!
    
    @IBOutlet var viewAllergyPopup: UIView!
    @IBOutlet weak var labelAllergyInfo: UILabel!
    //    @IBOutlet weak var textFieldAllergyDetails: UITextField!
//    @IBOutlet weak var buttonSubmit: UIButton!
    
    var allergyInformation = String()
    var orderTypeString = String()
    var paymentTypeString = String()
    let PAYPAL = 1
    let CARD = 2
    let WALLET = 3
    let CASH_OF_DELIVERY = 4
    let PAY_LATER = 5
    var paymentMode = 0
    var totalAmount = String()
    var selectedAddressID = String()
    var placeOrderUrlString = String()
    var selectedFoodDeliveryTime = Int()
    var selectedScheduleTime = String()
    var arrayTimeSlot = Array<String>()
    var isDirectMoveFromCart = Bool()
    
    let BUTTON_ASAP = 1
    let BUTTON_LATER = 2
    var orderType = Int()
    let SCHEDULE_HEIGHT : CGFloat = 105.0
    let CORNER_RADIUS : CGFloat = 5.0
    var selectedIndex = Int()
    var restaurantInfo = RestaurantInfo()
    var popupController:CNPPopupController?
    let ALLERGY_POPUP_HEIGHT : CGFloat = 170.5
    let HEIGHT_PAYMENT_METHOD : CGFloat = 60.0
    
    let CELL_ID = "TimeSlotCell"
    let ORDER_TIME = "ORDER_TIME"
    let CUSTOMER_ADDRESS_ID = "CUSTOMER_ADDRESS_ID"
    let PAYMENT_TYPE_STRING = "PAYMENT_TYPE_STRING"
    let SPECIAL_INSTRUCTION = "SPECIAL_INSTRUCTION"
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupPaymentMethod()
    }
    
    override func viewDidLayoutSubviews() {
        
        if self.selectedFoodDeliveryTime == self.BUTTON_LATER {
            super.viewDidLayoutSubviews()
            let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.heightCollectionView.constant = height
            self.heightViewSchedule.constant = height + 45.0
            self.view.layoutIfNeeded()
        }
        UtilityMethods.addBorderAndShadow(self.viewPaypal, self.CORNER_RADIUS)
        UtilityMethods.addBorderAndShadow(self.viewCard, self.CORNER_RADIUS)
        UtilityMethods.addBorderAndShadow(self.viewCashOnDelivery, self.CORNER_RADIUS)
        UtilityMethods.addBorderAndShadow(self.viewWhenFood, self.CORNER_RADIUS)
        UtilityMethods.addBorderAndShadow(self.viewSchedule, self.CORNER_RADIUS)
    }

    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Payment"] as? String != nil) ? (self.appDelegate.languageData["Payment"] as! String).trim() : "Payment"
        self.labelAmountToBePaid.text = (self.appDelegate.languageData["Amount_to_be_paid"] as? String != nil) ? (self.appDelegate.languageData["Amount_to_be_paid"] as! String).trim() : "Amount to be paid"
        self.labelWhenFood.text = (self.appDelegate.languageData["When_would_you_like_your_food"] as? String != nil) ? (self.appDelegate.languageData["When_would_you_like_your_food"] as! String).trim() : "When would you like your food"
        self.labelHowToPay.text = (self.appDelegate.languageData["please_select_payment_type"] as? String != nil) ? (self.appDelegate.languageData["please_select_payment_type"] as! String).trim() : "Please select payment type"
        self.labelCard.text = (self.appDelegate.languageData["Credit_Debit_Card"] as? String != nil) ? (self.appDelegate.languageData["Credit_Debit_Card"] as! String).trim() : "Credit/Debit Card"
        self.labelPaypal.text = (self.appDelegate.languageData["Paypal"] as? String != nil) ? (self.appDelegate.languageData["Paypal"] as! String).trim() : "Paypal"
        self.labelCashOnDelivery.text = (self.appDelegate.languageData["Cash_on_Delivery"] as? String != nil) ? (self.appDelegate.languageData["Cash_on_Delivery"] as! String).trim() : "Cash on delivery"
        self.labelAllergyDetails.text = (self.appDelegate.languageData["Allergy_Details"] as? String != nil) ? (self.appDelegate.languageData["Allergy_Details"] as! String).trim() : "Allergy Information"
        let instructionPlaceholder = (self.appDelegate.languageData["enter_instruction"] as? String != nil) ? (self.appDelegate.languageData["enter_instruction"] as! String).trim() : "Enter_your_loyalty_points"
        self.textFieldInstruction.placeholder = instructionPlaceholder
        self.labelDoYouHaveAllergy.text = (self.appDelegate.languageData["Do_you_have_any_allergy"] as? String != nil) ? (self.appDelegate.languageData["Do_you_have_any_allergy"] as! String).trim() : "Do you have any allergy"
        self.labelAllergyInstruction.text = (self.appDelegate.languageData["Leave_a_note_for_the_restaurant_Text"] as? String != nil) ? (self.appDelegate.languageData["Leave_a_note_for_the_restaurant_Text"] as! String).trim() : self.labelAllergyInstruction.text!
        let scheduleString = (self.appDelegate.languageData["Schedule"] as? String != nil) ? (self.appDelegate.languageData["Schedule"] as! String).trim() : "Schedule"
        let buttonMakePayment = (self.appDelegate.languageData["Make_a_Payment"] as? String != nil) ? (self.appDelegate.languageData["Make_a_Payment"] as! String).trim() : "Make a Payment"
        self.buttonPay.setTitle(buttonMakePayment, for: .normal)
        
        if self.orderType == ConstantStrings.ORDER_TYPE_DELIVERY {
            self.labelSchedule.text = "\(scheduleString) \(ConstantStrings.ORDER_TYPE_DELIVERY_STRING)"
        }else if self.orderType == ConstantStrings.ORDER_TYPE_PICKUP {
            self.labelSchedule.text = "\(scheduleString) \(ConstantStrings.ORDER_TYPE_PICKUP_STRING)"
        }else {
            self.labelSchedule.text = scheduleString
        }
        
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.setupBackBarButton()
        self.webApiAllergyInformation()
        self.webApiRestaurantTimeSlot()
        
        self.labelAllergyInfo.text = ""
        self.viewSchedule.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewWhenFood.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewPaypal.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewCard.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewPayLater.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
//        self.viewWallet.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.viewCashOnDelivery.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.buttonPay.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        
        self.selectedFoodDeliveryTime = self.BUTTON_ASAP
        self.labelTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + self.totalAmount
        self.imageViewSelectAsap.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
        self.imageViewSelectLater.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
        
        self.hideScheduleTimeView()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        self.selectedScheduleTime = dateFormatter.string(from: Date())
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as? RestaurantInfo != nil {
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        
        if self.isDirectMoveFromCart {
            self.heightAsapView.constant = 0.5
            self.topMarginASAPView.constant = 0.5
            self.labelWhenFood.isHidden = true
            self.labelAsap.isHidden = true
            self.labelLater.isHidden = true
            self.buttonASAP.isHidden = true
            self.buttonLater.isHidden = true
            self.viewWhenFood.isHidden = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            self.selectedScheduleTime = dateFormatter.string(from: Date())
        }
        
        self.selectedIndex = 0
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "TimeSlotCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.CELL_ID)
        
        let strNumber: NSString = self.labelAllergyInstruction.text! as NSString
        let range = (strNumber).range(of: "(e.g. if you have a food allergy or instruction for the restuarant/driver)")
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15.0, weight: .regular), range: range)
        self.labelAllergyInstruction.attributedText = attribute
        
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
    
//    Hide/Show schedule view
    func hideScheduleTimeView() -> Void {
        
        self.bottomMarginViewSchedule.constant = 0.5
        self.heightViewSchedule.constant = 0.5
        self.heightCollectionView.constant = 0.5
        self.viewSchedule.isHidden = true
        self.collectionView.isHidden = true
    }
    
    func showScheduleTimeView() -> Void {
        
        self.bottomMarginViewSchedule.constant = 15
        self.heightViewSchedule.constant = self.SCHEDULE_HEIGHT
        self.heightCollectionView.constant = 0.5
        self.viewSchedule.isHidden = false
        self.collectionView.isHidden = false
    }
    
//    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrayTimeSlot.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CELL_ID, for: indexPath) as! TimeSlotCollectionViewCell
        
        if self.selectedIndex == indexPath.row {
            
            self.selectedScheduleTime = self.arrayTimeSlot[indexPath.row]
            cell.labelTimeSlot.text = self.arrayTimeSlot[indexPath.row]
            cell.labelTimeSlot.textColor = .black
            UtilityMethods.addBorder(cell.viewBg, Colors.colorWithHexString(Colors.GREEN_COLOR), self.CORNER_RADIUS)
        }else {
            
            cell.labelTimeSlot.text = self.arrayTimeSlot[indexPath.row]
            cell.labelTimeSlot.textColor = Colors.colorWithHexString(Colors.LIGHT_GRAY_COLOR)
            UtilityMethods.addBorder(cell.viewBg, Colors.colorWithHexString(Colors.LIGHT_GRAY_COLOR), self.CORNER_RADIUS)
        }
        
        if self.screenWidth == 320 {
            
            cell.labelTimeSlot.font = UIFont.systemFont(ofSize: 11)
        }else {
            
            cell.labelTimeSlot.font = UIFont.systemFont(ofSize: 13)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (self.collectionView.bounds.width - 30) / 4, height: 35.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedScheduleTime = self.arrayTimeSlot[indexPath.row]
        self.selectedIndex = indexPath.row
        self.collectionView.reloadData()
    }
    
    //    MARK:- Button Action
//    Button Action For Pay
    @IBAction func buttonPayAction(_ sender: UIButton) {

        if self.paymentMode == 0 {
            
            self.showToastWithMessage(self.view, ConstantStrings.PLEASE_SELECT_PAYMENT_MODE)
        }else {
            
            if self.paymentMode == self.CARD {
                
                let stripeVC = StripeViewController.init(nibName: "StripeViewController", bundle: nil)
                stripeVC.totalAmount = self.totalAmount
                stripeVC.placeOrderUrl = self.placeOrderUrlString
                stripeVC.selectedAddressID = self.selectedAddressID
                stripeVC.scheduleTime = self.selectedScheduleTime
                stripeVC.paymentMethod = self.paymentTypeString
                stripeVC.specialInstruction = self.textFieldInstruction.text!
                self.navigationController?.pushViewController(stripeVC, animated: true)
            }else if self.paymentMode == self.CASH_OF_DELIVERY {
                
                self.callPlaceOrderApi()
            }else if self.paymentMode == self.PAYPAL {
                
                self.setupPaypalPaymentGatway()
            }else if self.paymentMode == self.PAY_LATER {
                
                self.callPlaceOrderApi()
            }
        }
    }
    
//    Setup Payment Method
    func setupPaymentMethod() -> Void {
        
        if self.restaurantInfo.isCashOnDeliveryAvailable {
            
            self.topMarginCash.constant = 15.0
            self.showPaymentMethodView(self.imageViewCashOnDeliverySelect, self.labelCashOnDelivery, imageViewCash, self.viewCashOnDelivery, heightCashOnDelivery, self.buttonCash)
        }else {
            
            self.topMarginCash.constant = 0.5
            self.hidePaymentMethodView(self.imageViewCashOnDeliverySelect, self.labelCashOnDelivery, imageViewCash, self.viewCashOnDelivery, heightCashOnDelivery, self.buttonCash)
        }
        
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
        
        let orderType = UserDefaultOperations.getIntValue(ConstantStrings.ORDER_TYPE_VALUE)
        if (orderType == ConstantStrings.ORDER_TYPE_DINING) && (self.restaurantInfo.isPaylater) {
            
//            self.topMarginPayLater.constant = 15.0
//            self.showPaymentMethodView(self.imageViewPayLaterSelect, self.labelPayLater, self.imageViewPayLater, self.viewPayLater, self.heightPayLater, self.butttonPayLater)
            self.topMarginPayLater.constant = 0.5
            self.hidePaymentMethodView(self.imageViewPayLaterSelect, self.labelPayLater, self.imageViewPayLater, self.viewPayLater, self.heightPayLater, self.butttonPayLater)
        }else {
            
            self.topMarginPayLater.constant = 0.5
            self.hidePaymentMethodView(self.imageViewPayLaterSelect, self.labelPayLater, self.imageViewPayLater, self.viewPayLater, self.heightPayLater, self.butttonPayLater)
        }
    }
    
//    call the place order api
    func callPlaceOrderApi() -> Void {
        if self.textFieldInstruction.text!.isEmpty {
            self.placeOrderUrlString = self.placeOrderUrlString.replacingOccurrences(of: self.SPECIAL_INSTRUCTION, with: "")
        }else {
            self.placeOrderUrlString = self.placeOrderUrlString.replacingOccurrences(of: self.SPECIAL_INSTRUCTION, with: self.textFieldInstruction.text!)
        }
        self.placeOrderUrlString = self.placeOrderUrlString.replacingOccurrences(of: self.ORDER_TIME, with: self.selectedScheduleTime)
        self.placeOrderUrlString = self.placeOrderUrlString.replacingOccurrences(of: self.CUSTOMER_ADDRESS_ID, with: self.selectedAddressID)
        self.placeOrderUrlString = self.placeOrderUrlString.replacingOccurrences(of: self.PAYMENT_TYPE_STRING, with: self.paymentTypeString)
        self.webApiPlaceOrder(self.placeOrderUrlString)
    }
    
//    Button Action for remove allergy popup
    @IBAction func buttonRemoveAllergyPopupViewAction(_ sender: UIButton) {
        
        self.popupController?.dismiss(animated: true)
    }
    
//    Button Action for submit details
    @IBAction func buttonAllergyDetailsSubmitAction(_ sender: UIButton) {
        
        self.popupController?.dismiss(animated: true)
    }
    
//    Button Action for show allergy details popup
    @IBAction func buttonShowAllergyPopupAction(_ sender: UIButton) {
        
        let label:UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.screenWidth - 30, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        label.text = self.allergyInformation
        label.sizeToFit()
        let height = label.bounds.height + 55.0
        self.labelAllergyInfo.text = self.allergyInformation
        UtilityMethods.addBorderAndShadow(self.viewAllergyPopup, 5.0)
        self.viewAllergyPopup.backgroundColor = .clear
        self.viewAllergyPopup.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewAllergyPopup.frame = CGRect.init(x: 15, y: 0, width: UIScreen.main.bounds.width - 30, height: height)
        
        let popupController = CNPPopupController(contents:[self.viewAllergyPopup])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = CNPPopupStyle.actionSheet
        // LFL added settings for custom color and blur
        popupController.theme.backgroundColor = .white
        popupController.theme.maskType = .dimmed
        popupController.delegate = self
        self.popupController = popupController
        popupController.present(animated: true)
    }
    
    func popupControllerWillDismiss(_ controller: CNPPopupController) {
        
        print("Popup controller will be dismissed")
    }
    
    func popupControllerDidPresent(_ controller: CNPPopupController) {
        
        print("Popup controller presented")
    }
    
    //    Button Action for select payment mode
    @IBAction func buttonSelectPaypalPaymentAction(_ sender: UIButton) {
        
        self.paymentMode = self.PAYPAL
        self.paymentTypeString = "Online"
        self.imageViewCashOnDeliverySelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewPaypalSelect.image = UIImage(named: ConstantStrings.SELECTED_ADDRESS_IMAGE)
        self.imageViewCardSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewPayLaterSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
    }
    
    @IBAction func buttonSelectCardPaymentAction(_ sender: UIButton) {
        
        self.paymentMode = self.CARD
        self.paymentTypeString = "Card"
        self.imageViewCashOnDeliverySelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewPaypalSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewCardSelect.image = UIImage(named: ConstantStrings.SELECTED_ADDRESS_IMAGE)
        self.imageViewPayLaterSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
    }
    
    @IBAction func buttonSelectCashOnDeliveryPaymentAction(_ sender: UIButton) {
        
        self.paymentTypeString = "Cash"
        self.paymentMode = self.CASH_OF_DELIVERY
        self.imageViewCashOnDeliverySelect.image = UIImage(named: ConstantStrings.SELECTED_ADDRESS_IMAGE)
        self.imageViewPaypalSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewCardSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewPayLaterSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
    }
    
    @IBAction func buttonPayLaterAction(_ sender: UIButton) {
        
        self.paymentTypeString = "payLater"
        self.paymentMode = self.PAY_LATER
        self.imageViewCashOnDeliverySelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewPaypalSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewCardSelect.image = UIImage(named: ConstantStrings.UNSELECTED_ADDRESS_IMAGE)
        self.imageViewPayLaterSelect.image = UIImage(named: ConstantStrings.SELECTED_ADDRESS_IMAGE)
    }
    
//    Button Action for When food like
    @IBAction func buttonSelectWhenFoodAction(_ sender: UIButton) {
        
        if sender.tag == self.BUTTON_ASAP {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            self.selectedScheduleTime = dateFormatter.string(from: Date())
            self.hideScheduleTimeView()
            self.selectedFoodDeliveryTime = self.BUTTON_ASAP
            self.imageViewSelectAsap.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
            self.imageViewSelectLater.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
        }else {
            
            if self.selectedFoodDeliveryTime != self.BUTTON_LATER {
                
                self.selectedIndex = 0
                self.showScheduleTimeView()
                self.selectedFoodDeliveryTime = self.BUTTON_LATER
                self.imageViewSelectLater.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
                self.imageViewSelectAsap.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    
                    self.collectionView.reloadData()
                    self.view.setNeedsLayout()
                }
            }
        }
    }
    
//    Hide/Show Payment Method view
    func hidePaymentMethodView(_ imageViewSelect : UIImageView, _ labelPaymentName : UILabel, _ imageViewPaymentMethod : UIImageView, _ viewPaymentMethod : UIView, _ viewHeight : NSLayoutConstraint, _ buttonPayment : UIButton) -> Void {
        
        imageViewSelect.isHidden = true
        labelPaymentName.isHidden = true
        imageViewPaymentMethod.isHidden = true
        viewHeight.constant = 0.5
        buttonPayment.isUserInteractionEnabled = false
        viewPaymentMethod.isHidden = true
    }
    
    func showPaymentMethodView(_ imageViewSelect : UIImageView, _ labelPaymentName : UILabel, _ imageViewPaymentMethod : UIImageView, _ viewPaymentMethod : UIView, _ viewHeight : NSLayoutConstraint, _ buttonPayment : UIButton) -> Void {
        
        imageViewSelect.isHidden = false
        labelPaymentName.isHidden = false
        imageViewPaymentMethod.isHidden = false
        viewHeight.constant = self.HEIGHT_PAYMENT_METHOD
        buttonPayment.isUserInteractionEnabled = true
        viewPaymentMethod.isHidden = false
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
                    
                    if jsonDictionary[JSONKey.ORDER_ID] as? String != nil {
                        
                        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS, "")
                        UserDefaultOperations.setBoolObject(ConstantStrings.IS_LOYALTY_POINTS_REDEEMED, false)
                        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS_AMOUNT, "")
                        UserDefaultOperations.setBoolObject(ConstantStrings.IS_COUPON_APPLIED, false)
                        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_COUPON_CODE, "")
                        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_COUPON_AMOUNT, "")
                        UserDefaultOperations.setArrayObject(ConstantStrings.CART_ITEM_LIST, Array<Any>())
                        UserDefaultOperations.setStringObject(ConstantStrings.SEND_ORDER_KITCHEN_ID, "")
                        UserDefaultOperations.setArrayObject(ConstantStrings.SEND_ORDER_KITCHEN_LIST, Array<Any>())
                        
                        let orderID = jsonDictionary[JSONKey.ORDER_ID] as! String
                        let thankyouVC = ThankyouViewController.init(nibName: "ThankyouViewController", bundle: nil)
                        thankyouVC.orderID = String(orderID)
                        let orderType = UserDefaultOperations.getIntValue(ConstantStrings.ORDER_TYPE_VALUE)
                        if (orderType == ConstantStrings.ORDER_TYPE_DINING) && (self.restaurantInfo.isPaylater) {
                            thankyouVC.isMovableOnPayLaterDetailsPage = true
                        }else {
                            thankyouVC.isMovableOnPayLaterDetailsPage = false
                        }
                        self.navigationController?.pushViewController(thankyouVC, animated: true)
                    }else {
                        
                        self.showToastWithMessage(self.view, ConstantStrings.YOUR_ORDER_COULD_NOT_PLACED)
                    }
                }
            }
        }
    }
    
//    Get Restaurant Open time slot
    func webApiRestaurantTimeSlot() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_time_fetch.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupRestaurantTimeSlot(json.dictionaryObject!)
                }
            }
        }
    }
    
//    setup restaurant time slot
    func setupRestaurantTimeSlot(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary["TimeList"] as? Array<Dictionary<String, Any>> != nil {
            
            let arrayDictionarySlot = jsonDictionary["TimeList"] as! Array<Dictionary<String, Any>>
            
            for slotDetails in arrayDictionarySlot {
                
                if slotDetails["GetTime"] as? String != nil {
                    
                    self.arrayTimeSlot.append(slotDetails["GetTime"] as! String)
                }
            }
            
            self.collectionView.reloadData()
        }
    }
    
//    Get Allergy Information
    func webApiAllergyInformation() -> Void {
        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_restaurant_allery_info.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
//            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
//                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
//                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupAllergyInformation(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Func setup allergy information
    func setupAllergyInformation(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary["AlleryInfo"] as? String != nil {
            
            self.allergyInformation = jsonDictionary["AlleryInfo"] as! String
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
}
