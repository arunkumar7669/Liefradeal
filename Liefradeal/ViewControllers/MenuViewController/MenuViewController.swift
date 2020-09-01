//
//  MenuViewController.swift
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

class MenuViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ModifyItemCountDelegate, ItemAddedIntoCartDelegate, CartValueUpdatedDelegate, CNPPopupControllerDelegate, BookTableDelegate, CLLocationManagerDelegate {
    
    func bookSelectedTable(_ tableID: String) {
        UserDefaultOperations.setStringObject(ConstantStrings.SELECTED_TABLE_NUMBER, tableID)
        UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, self.selectedOrderType)
        self.itemAddToCartOperation(self.selectedAddToCartIndexPath)
    }
    
    
//    When cart value is updated on cart page then call this method by delegate
    func cartValueChanged(_ itemDictionary: Dictionary<String, String>) {
        
        for i in 0..<self.arrayMenuItems.count {
            var itemDetails = self.arrayMenuItems[i]
            if (itemDetails[JSONKey.ITEM_ID] == itemDictionary[JSONKey.ITEM_ID]) {
                itemDetails[JSONKey.ITEM_QUANTITY] = itemDictionary[JSONKey.ITEM_QUANTITY]
                itemDetails[JSONKey.ITEM_CART_PRICE] = itemDictionary[JSONKey.ITEM_CART_PRICE]
                itemDetails[JSONKey.ITEM_CART_ORIGINAL_PRICE] = itemDictionary[JSONKey.ITEM_CART_ORIGINAL_PRICE]
                itemDetails[JSONKey.ITEM_UPDATED_PRICE] = itemDictionary[JSONKey.ITEM_UPDATED_PRICE]
                itemDetails[JSONKey.ITEM_IS_ADDED_TO_CART] = itemDictionary[JSONKey.ITEM_IS_ADDED_TO_CART]
                self.arrayMenuItems[i] = itemDetails
                break
            }
        }
    }
    
//    For choose item size and extra things for add in menu details delegate
    func menuItemAddedIntoCart(_ indexPath: IndexPath, _ itemDetails: Dictionary<String, String>) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            self.arrayMenuItems[indexPath.row] = itemDetails
            self.tableView.reloadData()
            self.setupAnimationForCart(indexPath)
        }
    }
    
    func showMessageAddedItemInPaylaterOrder() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showToastWithMessage(self.view, ConstantStrings.ITEM_HAS_BEEN_ADDED_IN_PAY_LATER_ORDER)
        }
    }
    
    @IBOutlet weak var collectionViewPageMenu: UICollectionView!
    @IBOutlet weak var viewPageMenu: UIView!
    @IBOutlet weak var labelSubtotalAmount: UILabel!
    @IBOutlet weak var labelItemCount: UILabel!
    @IBOutlet weak var viewBottomCart: UIView!
    @IBOutlet weak var imageViewCart: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
//    For Postal code popup View
    @IBOutlet var viewPostalCode: UIView!
    @IBOutlet weak var labelPostalCode: UILabel!
    @IBOutlet weak var textFieldPostalCode: UITextField!
    @IBOutlet weak var buttonSubmitPostalCod: UIButton!
    @IBOutlet weak var labelDescription: UILabel!
    
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
    @IBOutlet weak var collectionViewPopup: UICollectionView!
    @IBOutlet weak var labelSelectOption: UILabel!
    @IBOutlet weak var labelOrderType: UILabel!
    @IBOutlet weak var labelViewCart: UILabel!
    
    var button = UIButton()
    let DINING_VIEW_HEIGHT : CGFloat = 187.0
    let HEIGHT_POSTAL_CODE_VIEW : CGFloat = 270.0
    let POSTAL_TEXT_FIELD_VIEW_HEIGHT : CGFloat = 76.5
    var selectedAddToCartIndexPath = IndexPath()
    var popDiningController : CNPPopupController?
    var selectedOrderType = Int()
    let locationManager = CLLocationManager()
    var currentLocationLatitude = Double()
    var currentLocationLongitude = Double()
    
    let EAT_IN_IMAGE = "dining"
    let PICK_UP_IMAGE = "pickup"
    let MENU_CELL = "RecommendCell"
    let ORDER_TYPE_ID = "orderTypeId"
    let PAGE_MENU_CELL = "PageMenuCell"
    let ORDER_TYPE_NAME = "orderTypeName"
    let DELIVERY_IMAGE = "delivery_type"
    let ORDER_TYPE_CELL = "OrderTypeCell"
    let ORDER_TYPE_IMAGE = "orderTypeImage"
    let ORDER_TYPE_POPUP_CELL = "OrderTypePopupCell"
    let ORDER_TYPE_STRING_VALUE = "orderTypeStringValue"
    let DELIVER_STRING = "Delivery"
    let PICKUP_STRING = "Pickup"
    let DINING_STRING = "EAT-IN"
    let DELIVERY_TYPE = 1
    let PICKUP_TYPE = 2
    let DINING_TYPE = 3
    
    var bagButton = CartButton()
    var restaurantInfo = RestaurantInfo()
    var isActiveCurrentViewController = Bool()
    var arrayOrderType = Array<Dictionary<String, Any>>()
    var arrayMenuList = Array<Dictionary<String, String>>()
    var arrayMenuItems = Array<Dictionary<String, String>>()
    
    var selectedPageMenu = 0
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isActiveCurrentViewController = true
        let arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST)
        self.bagButton.badge = "\(arrayCartItems.count)"
        self.checkIsItemAddedToCart()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isActiveCurrentViewController = false
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Menu"] as? String != nil) ? (self.appDelegate.languageData["Menu"] as! String).trim() : "Menu"
        self.labelSelectOption.text = (self.appDelegate.languageData["Select_Option"] as? String != nil) ? (self.appDelegate.languageData["Select_Option"] as! String).trim() : "Select Option"
        self.labelScanQRCode.text = (self.appDelegate.languageData["Scan_QR_Code"] as? String != nil) ? (self.appDelegate.languageData["Scan_QR_Code"] as! String).trim() : "Scan QR Code"
        self.labelSelectTableNumber.text = (self.appDelegate.languageData["Select_Table_Number"] as? String != nil) ? (self.appDelegate.languageData["Select_Table_Number"] as! String).trim() : "Select Table Number"
        self.labelViewCart.text = (self.appDelegate.languageData["VIEW_CART"] as? String != nil) ? (self.appDelegate.languageData["VIEW_CART"] as! String).trim() : "View Cart"
        let buttonSubmitTitle = (self.appDelegate.languageData["Submit"] as? String != nil) ? (self.appDelegate.languageData["Submit"] as! String).trim() : "Submit"
        self.buttonSelectTableSubmit.setTitle(buttonSubmitTitle, for: .normal)
        self.buttonSubmitPostalCod.setTitle(buttonSubmitTitle, for: .normal)
        self.labelOrderType.text = (self.appDelegate.languageData["Order_Type"] as? String != nil) ? (self.appDelegate.languageData["Order_Type"] as! String).trim() : "Order Type"
        let postalCodePlaceholder = (self.appDelegate.languageData["Please_enter_your_postal_code_here"] as? String != nil) ? (self.appDelegate.languageData["Please_enter_your_postal_code_here"] as! String).trim() : "Please enter your postal code here"
        self.textFieldPostalCode.placeholder = postalCodePlaceholder
        self.labelPostalCode.text = (self.appDelegate.languageData["Postal_Code"] as? String != nil) ? (self.appDelegate.languageData["Postal_Code"] as! String).trim() : "Postcode"
        
        self.setupBackBarButton()
        let arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST)
        self.setupCartNavigationButtonWithBadge(arrayCartItems.count)
        self.collectionViewPageMenu.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        
        self.labelSubtotalAmount.textColor = .white
        UtilityMethods.changeImageColor(self.imageViewCart, .white)
        self.viewBottomCart.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.viewBottomCart.layer.cornerRadius = 5.0
        self.viewBottomCart.layer.masksToBounds = true
        self.viewBottomCart.layerGradient(startPoint: .centerRight, endPoint: .centerLeft, colorArray: [Colors.colorWithHexString(Colors.GRADIANT_DARK).cgColor, Colors.colorWithHexString(Colors.GRADIANT_LIGHT).cgColor], type: .axial)
        
        self.collectionViewPageMenu.backgroundColor = Colors.colorWithHexString("#E8E8E8")
        self.collectionViewPageMenu.contentInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        self.collectionViewPageMenu.delegate = self
        self.collectionViewPageMenu.dataSource = self
        self.collectionViewPageMenu.register(UINib.init(nibName: "PageMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.PAGE_MENU_CELL)
        
        self.collectionViewPopup.delegate = self
        self.collectionViewPopup.dataSource = self
        self.collectionViewPopup.register(UINib.init(nibName: "OrderTypePopupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.ORDER_TYPE_POPUP_CELL)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        if self.selectedPageMenu != 0 {
            self.arrayMenuItems.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.collectionViewPageMenu.selectItem(at: IndexPath(row: self.selectedPageMenu, section: 0), animated: true, scrollPosition: .left)
            }
            let menuDictionary = self.arrayMenuList[self.selectedPageMenu]
            self.webApiHomeCategoryItemList(menuDictionary[JSONKey.CATEGORY_ID]!)
        }
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as? RestaurantInfo != nil {
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        self.setupTableViewDelegateMethod()
        self.setupOrderTypeArray()
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
    }
    
//    Func setup tableview delegate method
    func setupTableViewDelegateMethod() -> Void {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 40
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        if gesture.direction == .right {
            
            if self.selectedPageMenu > 0 {
                
                self.selectedPageMenu -= 1
                self.collectionViewPageMenu.reloadData()
                self.collectionViewPageMenu.scrollToItem(at:IndexPath(item: self.selectedPageMenu, section: 0), at: .right, animated: true)
                
                let menuDictionary = self.arrayMenuList[self.selectedPageMenu]
                self.webApiHomeCategoryItemList(menuDictionary[JSONKey.CATEGORY_ID]!)
            }
        }else if gesture.direction == .left {
            
            if self.selectedPageMenu < self.arrayMenuList.count - 1 {
                
                self.selectedPageMenu += 1
                self.collectionViewPageMenu.reloadData()
                self.collectionViewPageMenu.scrollToItem(at:IndexPath(item: self.selectedPageMenu, section: 0), at: .right, animated: true)
                
                let menuDictionary = self.arrayMenuList[self.selectedPageMenu]
                self.webApiHomeCategoryItemList(menuDictionary[JSONKey.CATEGORY_ID]!)
            }
        }
    }
    
    //    Setup cart and cart value
    func setupCartNavigationButtonWithBadge(_ cartItemCount : Int) {
        
        bagButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        bagButton.tintColor = UIColor.white
        bagButton.setImage(UIImage(named: "cart")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        bagButton.badge = "\(cartItemCount)"
        bagButton.addTarget(self, action: #selector(self.buttonCartNavigationClickAction(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bagButton)
    }
    
    //    Button cart action
    @objc func buttonCartNavigationClickAction(_ sender : UIButton) -> Void {
        
        let cartVC = CartViewController.init(nibName: "CartViewController", bundle: nil)
        cartVC.delegate = self
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
//    Check item is added to cart and setup flag value
    func checkIsItemAddedToCart() -> Void {
        
        let arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST) as! Array<Dictionary<String, String>>
        if arrayCartItems.count > 0 {
            for i in 0..<self.arrayMenuItems.count {
                var itemDetails = self.arrayMenuItems[i]
                for cartItem in arrayCartItems {
                    if (itemDetails[JSONKey.ITEM_ID] == cartItem[JSONKey.ITEM_ID]) && (itemDetails[JSONKey.ITEM_IS_ADDED_TO_CART] == ConstantStrings.ITEM_NOT_ADDED_TO_CART) {
                        itemDetails[JSONKey.ITEM_IS_ADDED_TO_CART] = ConstantStrings.ITEM_ADDED_TO_CART
                        itemDetails[JSONKey.ITEM_QUANTITY] = cartItem[JSONKey.ITEM_QUANTITY]
                        itemDetails[JSONKey.ITEM_OFFER_PRICE] = cartItem[JSONKey.ITEM_OFFER_PRICE]
                        itemDetails[JSONKey.ITEM_ORIGINAL_PRICE] = cartItem[JSONKey.ITEM_ORIGINAL_PRICE]
                        self.arrayMenuItems[i] = itemDetails
                        break
                    }
                }
            }
        }
        
        var subTotalAmount = Double()
        for cartDictionary in arrayCartItems {
            subTotalAmount += Double(cartDictionary[JSONKey.ITEM_CART_PRICE]!)!
        }
        self.labelItemCount.text = "\(arrayCartItems.count) \(ConstantStrings.ITEMS)"
        self.labelSubtotalAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format: "%.2f", subTotalAmount)
        if arrayCartItems.count == 0 {
            self.viewBottomCart.isHidden = true
            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }else {
            self.viewBottomCart.isHidden = false
            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 80, right: 0)
        }
    }
    
    //    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionViewPageMenu {
            
            return self.arrayMenuList.count
        }else if collectionView == self.collectionViewPopup {
            
            return self.arrayOrderType.count
        }else {
            
            return self.arrayMenuItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewPageMenu {
            
            return self.setupPageMenuCell(collectionView, indexPath)
        }else if collectionView == self.collectionViewPopup {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.ORDER_TYPE_POPUP_CELL, for: indexPath) as! OrderTypePopupCollectionViewCell
            let dictionaryOrderType = self.arrayOrderType[indexPath.row]
            
            cell.labelOrderType.text = (dictionaryOrderType[self.ORDER_TYPE_NAME] as! String)
            if (dictionaryOrderType[self.ORDER_TYPE_ID] as! Int) == self.selectedOrderType {
                
                cell.labelOrderType.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
                UtilityMethods.addBorder(cell.viewBg, Colors.colorWithHexString(Colors.GREEN_COLOR), 5.0)
            }else {
                
                cell.labelOrderType.textColor = .lightGray
                UtilityMethods.addBorder(cell.viewBg, .lightGray, 5.0)
            }
            
            return cell
        }else {
            
            return self.setupMenuItemCell(collectionView, indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionViewPageMenu {
            
            let label = UILabel(frame: CGRect.zero)
            let dictionaryMenu = self.arrayMenuList[indexPath.row]
            label.text = dictionaryMenu[JSONKey.CATEGORY_NAME]
            label.sizeToFit()
            
            return CGSize.init(width: label.frame.width + 10, height: 40)
        }else if collectionView == self.collectionViewPopup {
            
            let width = CGFloat(((self.screenWidth - 90) / 3))
            let height : CGFloat = 40
            return CGSize.init(width: width, height: height)
        }else {
            
            let dictionaryMenuItems = self.arrayMenuItems[indexPath.row]
            let heightName = self.estimateFrameForText(dictionaryMenuItems[JSONKey.ITEM_NAME]!)
            let heightDescription = self.estimateFrameForText(dictionaryMenuItems[JSONKey.ITEM_DESCRIPTION]!)
            let totalHeight = heightName.height + heightDescription.height + CGFloat(30)
            
            return CGSize.init(width: self.screenWidth, height: totalHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.collectionViewPageMenu {
            
            return 0
        }else {
            
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionViewPageMenu {
            
            self.selectedPageMenu = indexPath.row
            self.collectionViewPageMenu.reloadData()
            self.collectionViewPageMenu.scrollToItem(at:IndexPath(item: self.selectedPageMenu, section: 0), at: .right, animated: true)
            let menuDictionary = self.arrayMenuList[self.selectedPageMenu]
            self.webApiHomeCategoryItemList(menuDictionary[JSONKey.CATEGORY_ID]!)
        }else if collectionView == self.collectionViewPopup {
            
            let dictionaryOrder = self.arrayOrderType[indexPath.row]
            if (dictionaryOrder[self.ORDER_TYPE_ID] as! Int) == self.DELIVERY_TYPE {
                
                self.labelPostalCode.isHidden = false
                self.textFieldPostalCode.isHidden = false
                self.viewBottomPostalCode.isHidden = false
                self.textFieldPostalCode.isUserInteractionEnabled = true
                self.textFieldPostalCode.becomeFirstResponder()
                self.heightPostalTextFieldView.constant = self.POSTAL_TEXT_FIELD_VIEW_HEIGHT
                self.viewPostalContainer.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth - 30, height: self.HEIGHT_POSTAL_CODE_VIEW)
                self.selectedOrderType = (dictionaryOrder[self.ORDER_TYPE_ID] as! Int)
                self.collectionViewPopup.reloadData()
            }else if (dictionaryOrder[self.ORDER_TYPE_ID] as! Int) == self.PICKUP_TYPE {
                
                self.textFieldPostalCode.text = ""
                self.labelPostalCode.isHidden = true
                self.textFieldPostalCode.isHidden = true
                self.viewBottomPostalCode.isHidden = true
                self.textFieldPostalCode.isUserInteractionEnabled = false
                self.heightPostalTextFieldView.constant = 0.5
                self.viewPostalContainer.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth - 30, height: self.HEIGHT_POSTAL_CODE_VIEW - self.POSTAL_TEXT_FIELD_VIEW_HEIGHT)
                self.selectedOrderType = (dictionaryOrder[self.ORDER_TYPE_ID] as! Int)
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
                    self.selectedOrderType = (dictionaryOrder[self.ORDER_TYPE_ID] as! Int)
                    self.collectionViewPopup.reloadData()
                }else {
                    self.showToastWithMessage(self.view, ConstantStrings.YOU_ARE_NOT_AVAILABLE_AT_ANY_BRANCH)
                }
            }
        }
    }
    
    //    MARK:- Setup Collection View Cell
    func setupPageMenuCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> PageMenuCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.PAGE_MENU_CELL, for: indexPath) as! PageMenuCollectionViewCell
        let dictionaryMenu = self.arrayMenuList[indexPath.row]
        cell.labelMenuItem.text = dictionaryMenu[JSONKey.CATEGORY_NAME]
        
        if indexPath.row == self.selectedPageMenu {
            
            UtilityMethods.addBorder(cell.viewBg, .white, 8.0)
            cell.viewBg.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
            cell.labelMenuItem.textColor = .white
            self.labelDescription.text = dictionaryMenu[JSONKey.CATEGORY_DESCRIPTION]
        }else{
            
            cell.viewBg.backgroundColor = .clear
            cell.labelMenuItem.textColor = .black
            UtilityMethods.addBorder(cell.viewBg, .clear, 15.0)
        }
        
        return cell
    }
    
    func setupMenuItemCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> RecommendCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.MENU_CELL, for: indexPath) as! RecommendCollectionViewCell
//        cell.delegate = self
        cell.indexPath = indexPath
        cell.contentView.backgroundColor = .clear
        
        let dictionary = self.arrayMenuItems[indexPath.row]
        cell.labelMenuName.text = dictionary[JSONKey.ITEM_NAME]
        cell.labelCount.text = dictionary[JSONKey.ITEM_QUANTITY]
        cell.labelAmount.text = ConstantStrings.RUPEES_SYMBOL + dictionary[JSONKey.ITEM_OFFER_PRICE]!
        cell.labelMenuDetails.text = dictionary[JSONKey.ITEM_DESCRIPTION]
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: ConstantStrings.RUPEES_SYMBOL + dictionary[JSONKey.ITEM_ORIGINAL_PRICE]!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.gray, range: NSMakeRange(0, attributeString.length))
        cell.labelOriginalPrice.attributedText = attributeString
        
        if cell.labelMenuDetails.text!.isEmpty {
            
            cell.labelMenuDetails.text = " "
        }
        cell.buttonAddToCart.isHidden = true
        if dictionary[JSONKey.ITEM_IS_ADDED_TO_CART] == ConstantStrings.ITEM_ADDED_TO_CART {
            
            cell.labelCount.isHidden = false
            cell.labelMinus.isHidden = false
            cell.buttonMinus.isUserInteractionEnabled = true
            cell.buttonMinus.isHidden = false
            cell.buttonPlus.isUserInteractionEnabled = true
            cell.buttonAddToCart.isHidden = true
            cell.buttonAddToCart.isUserInteractionEnabled = false
            UtilityMethods.roundCorners(view: cell.labelPlus, corners: [.topRight, .bottomRight], radius: 5.0)
            UtilityMethods.roundCorners(view: cell.labelMinus, corners: [.topLeft, .bottomLeft], radius: 5.0)
        }else {
            
            cell.labelCount.isHidden = true
            cell.labelMinus.isHidden = true
            cell.buttonMinus.isUserInteractionEnabled = false
            cell.buttonMinus.isHidden = true
            cell.buttonPlus.isUserInteractionEnabled = false
            cell.buttonAddToCart.isHidden = false
            cell.buttonAddToCart.isUserInteractionEnabled = true
            UtilityMethods.roundCorners(view: cell.labelPlus, corners: [.topRight, .bottomRight], radius: 5.0)
        }
        
        return cell
    }
    
    private func estimateFrameForText(_ text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 1000
        let size = CGSize(width: self.screenWidth - 30, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)]
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    let MINUS_CLICKED = 1
    let PLUS_CLICKED = 2
//    Recommend cell update item quantity delegate method
    func updateItemQuantity(_ count : String, _ indexPath : IndexPath, _ buttonTag : Int) {
        var dictionary = self.arrayMenuItems[indexPath.row]
        if isAddingItemToCart {
//            if (self.orderType == ConstantStrings.ORDER_TYPE_DINING) && !self.kitchenOrderID.isEmpty {
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
                if buttonTag == self.MINUS_CLICKED {
                    if (Int(count)! < kitchenItemQuantity) {
                        self.showToastWithMessage(self.view, ConstantStrings.YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW)
                        return
                    }
                }
//                }
//            }
        }
        if dictionary[JSONKey.ITEM_IS_ADDED_TO_CART] == ConstantStrings.ITEM_ADDED_TO_CART {
            
            dictionary[JSONKey.ITEM_QUANTITY] = count
            if count == ConstantStrings.ITEM_NOT_ADDED_TO_CART {
                
                dictionary[JSONKey.ITEM_IS_ADDED_TO_CART] = ConstantStrings.ITEM_NOT_ADDED_TO_CART
            }
            let totalAmount = (Double(dictionary[JSONKey.ITEM_UPDATED_PRICE]!)!) * (Double(count)!)
            dictionary[JSONKey.ITEM_CART_PRICE] = String(format: "%.2f", totalAmount)
            let totalOriginalPriceAmount = (Double(dictionary[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE]!)!) * (Double(count)!)
            dictionary[JSONKey.ITEM_CART_ORIGINAL_PRICE] = String(format: "%.2f", totalOriginalPriceAmount)
            self.arrayMenuItems[indexPath.row] = dictionary
            self.updateCartValue(count, dictionary)
            let arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST)
            self.bagButton.badge = "\(arrayCartItems.count)"
        }else {
            self.showToastWithMessage(self.view, ConstantStrings.FIRSTLY_PLEASE_ADD_INTO_CART)
        }
    }
    
//    Update cart value according to item count
    func updateCartValue(_ count : String, _ dictionary : Dictionary<String, String>) -> Void {
        
        var arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST) as! Array<Dictionary<String, String>>
        
        if arrayCartItems.count > 0 {
            
            var cartItemIndex = Int()
            for i in 0..<arrayCartItems.count {
                
                let cartDictionary = arrayCartItems[i]
                if dictionary[JSONKey.ITEM_ID] == cartDictionary[JSONKey.ITEM_ID] {
                    
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
                self.checkIsItemAddedToCart()
                self.tableView.reloadData()
            }
        }
    }
    
    //    Recommend cell item Added into cart delegate method
    func itemAddedIntoCart( _ indexPath: IndexPath) {
        
        self.selectedAddToCartIndexPath = indexPath
        
        let postalCodeInfo = UserDefaultOperations.getDictionaryObject(ConstantStrings.POSTAL_CODE_INFO)
        let orderType = UserDefaultOperations.getIntValue(ConstantStrings.ORDER_TYPE_VALUE)
        
        if postalCodeInfo.isEmpty && orderType == 0 {
            
            self.setupViewPopupAnimation()
        }else {
            
            self.itemAddToCartOperation(indexPath)
        }
    }
    
    func setupAnimationForCart(_ indexPath : IndexPath) -> Void {
        
        if tableView.cellForRow(at: indexPath) == nil {
            return
        }
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        let imageViewPosition : CGPoint = cell.labelMenuName.convert(cell.labelMenuName.bounds.origin, to: self.view)
        
        let imgViewTemp = UIImageView(frame: CGRect(x: imageViewPosition.x, y: imageViewPosition.y, width: 40.0, height: 40.0))
        imgViewTemp.image = UIImage.init(named: "cart")
        animation(tempView: imgViewTemp, indexPath)
    }
    
    func animation(tempView : UIView, _ indexPath : IndexPath)  {
        
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        self.view.addSubview(tempView)
        UIView.animate(withDuration: 0.5, animations: {
                        tempView.animationZoom(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.5, animations: {
                
                tempView.animationZoom(scaleX: 0.2, y: 0.2)
                tempView.animationRoted(angle: CGFloat(Double.pi))
                tempView.frame.origin.x = cell.buttonAddToCart.frame.origin.x
                tempView.frame.origin.y = cell.buttonAddToCart.frame.origin.y
            }, completion: { _ in
                
                tempView.removeFromSuperview()
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.bagButton.animationZoom(scaleX: 1.4, y: 1.4)
                }, completion: {_ in
                    self.bagButton.animationZoom(scaleX: 1.0, y: 1.0)
                })
            })
        })
    }
    
//    Func for item add to cart operation perform
    func itemAddToCartOperation(_ indexPath : IndexPath) -> Void {
        
        var dictionary = self.arrayMenuItems[indexPath.row]
        if dictionary[JSONKey.ITEM_IS_SIZE_AVAILABLE] == ConstantStrings.TRUE_STRING {
            
            let menuDetailsVC = MenuDetailsViewController.init(nibName: "MenuDetailsViewController", bundle: nil)
            menuDetailsVC.delegate = self
            menuDetailsVC.selectedIndex = indexPath
            menuDetailsVC.dictionaryMenuDetails = self.arrayMenuItems[indexPath.row]
            self.navigationController?.pushViewController(menuDetailsVC, animated: true)
        }else if dictionary[JSONKey.ITEM_IS_EXTRA_AVAILABLE] == ConstantStrings.TRUE_STRING {
            
            let dictionaryMenuDetails = self.arrayMenuItems[self.selectedAddToCartIndexPath.row]
            let extraVC = ExtraViewController.init(nibName: "ExtraViewController", bundle: nil)
            extraVC.isMovedFromMenu = true
            extraVC.selectedSizeID = dictionaryMenuDetails[JSONKey.ITEM_SIZE_ID]!
            extraVC.selectedIndex = self.selectedAddToCartIndexPath
            extraVC.dictionaryMenuDetails = dictionaryMenuDetails
            self.navigationController?.pushViewController(extraVC, animated: true)
        }else {
            
            if (dictionary[JSONKey.ITEM_IS_ADDED_TO_CART] != ConstantStrings.ITEM_ADDED_TO_CART) || isMovedFromPayLaterDetailsPage {
                
                var arrayCart = Array<Dictionary<String, String>>()
                if isMovedFromPayLaterDetailsPage {
                    arrayCart = arrayGlobalPayLaterList
                }else {
                    dictionary[JSONKey.ITEM_IS_ADDED_TO_CART] = ConstantStrings.ITEM_ADDED_TO_CART
                    self.arrayMenuItems[indexPath.row] = dictionary
                    arrayCart = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST) as! Array<Dictionary<String, String>>
                    var dictionaryItem = self.arrayMenuItems[indexPath.row]
                    dictionaryItem[JSONKey.ITEM_QUANTITY] = "1"
                    dictionaryItem[JSONKey.ITEM_CART_PRICE] = dictionary[JSONKey.ITEM_OFFER_PRICE]
                    dictionaryItem[JSONKey.ITEM_CART_ORIGINAL_PRICE] = dictionary[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE]
                    self.arrayMenuItems[indexPath.row] = dictionaryItem
                }
                dictionary[JSONKey.ITEM_IS_ADDED_TO_CART] = ConstantStrings.ITEM_ADDED_TO_CART
                dictionary[JSONKey.ITEM_QUANTITY] = ConstantStrings.ITEM_ADDED_TO_CART
                dictionary[JSONKey.ITEM_CART_PRICE] = dictionary[JSONKey.ITEM_OFFER_PRICE]
                dictionary[JSONKey.ITEM_CART_ORIGINAL_PRICE] = dictionary[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE]
                if isMovedFromPayLaterDetailsPage {
                    dictionary[JSONKey.ORDER_ID] = selectedPayLaterGlobalOrderID
                }
                
                if arrayCart.count == 0 {
                    arrayCart = [dictionary]
                }else {
                    if isMovedFromPayLaterDetailsPage {
                        var i = 0
                        var isMatched = Bool()
                        for item in arrayCart {
                            if item[JSONKey.ITEM_ID] == dictionary[JSONKey.ITEM_ID] {
                                isMatched = true
                                break
                            }
                            i += 1
                        }
                        if isMatched {
                            var itemDetails = arrayCart[i]
                            var quantity = Int(itemDetails[JSONKey.ITEM_QUANTITY]!)!
                            quantity += 1
                            itemDetails[JSONKey.ITEM_QUANTITY] = "\(quantity)"
                            let price = Double(itemDetails[JSONKey.ITEM_OFFER_PRICE]!)! * Double(quantity)
                            itemDetails[JSONKey.ITEM_CART_PRICE] = String(format : "%.2f", price)
                            arrayCart[i] = itemDetails
                        }else {
                            arrayCart.append(dictionary)
                        }
                    }else {
                        arrayCart.append(dictionary)
                    }
                }
                if isMovedFromPayLaterDetailsPage {
                    payLaterGlobalOrderID = selectedPayLaterGlobalOrderID
                    arrayGlobalPayLaterList = arrayCart
                    self.showToastWithMessage(self.view, ConstantStrings.ITEM_HAS_BEEN_ADDED_IN_PAY_LATER_ORDER)
                }else {
                    UserDefaultOperations.setArrayObject(ConstantStrings.CART_ITEM_LIST, arrayCart)
                    self.bagButton.badge = "\(arrayCart.count)"
                    self.checkIsItemAddedToCart()
                    self.setupAnimationForCart(indexPath)
                    self.tableView.reloadData()
                    self.showToastWithMessage(self.view, ConstantStrings.ITEM_HAS_BEEN_ADDED_INTO_CART)
                }
            }
        }
    }
    
    //    MARK:- Button Action
//    Button Action for checkout from menu
    @IBAction func buttonCheckoutAction(_ sender: UIButton) {
        
//        let arrayCartItem = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST) as! Array<Dictionary<String, String>>
//        if arrayCartItem.count == 0 {
//
//            self.showToastWithMessage(self.view, ConstantStrings.YOUR_CART_IS_EMPTY)
//        }else {
        
            let cartVC = CartViewController.init(nibName: "CartViewController", bundle: nil)
            cartVC.delegate = self
            self.navigationController?.pushViewController(cartVC, animated: true)
//        }
    }
    
//    Button Action for select the order type
//    @IBAction func buttonSelecteOrderTypeAction(_ sender: UIButton) {
//
//        self.selectedOrderType = sender.tag
//        if sender.tag == ConstantStrings.ORDER_TYPE_DELIVERY {
//
//            self.heightPostalTextFieldView.constant = self.POSTAL_TEXT_FIELD_VIEW_HEIGHT
//            self.viewPostalContainer.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth - 30, height: self.HEIGHT_POSTAL_CODE_VIEW)
//
//            UtilityMethods.addBorder(self.viewDelivery, Colors.colorWithHexString(Colors.GREEN_COLOR), 5.0)
//            UtilityMethods.addBorder(self.viewPickup, .lightGray, 5.0)
//            UtilityMethods.addBorder(self.viewDining, .lightGray, 5.0)
//
//            self.labelPickup.textColor = .lightGray
//            self.labelDining.textColor = .lightGray
//            self.labelDelivery.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
//
//            self.labelPostalCode.isHidden = false
//            self.textFieldPostalCode.isHidden = false
//            self.viewBottomPostalCode.isHidden = false
//            self.textFieldPostalCode.isUserInteractionEnabled = true
//            self.textFieldPostalCode.becomeFirstResponder()
//        }else if sender.tag == ConstantStrings.ORDER_TYPE_PICKUP {
//
//            self.heightPostalTextFieldView.constant = 0.5
//            self.viewPostalContainer.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth - 30, height: self.HEIGHT_POSTAL_CODE_VIEW - self.POSTAL_TEXT_FIELD_VIEW_HEIGHT)
//
//            UtilityMethods.addBorder(self.viewDelivery, .lightGray, 5.0)
//            UtilityMethods.addBorder(self.viewPickup, Colors.colorWithHexString(Colors.GREEN_COLOR), 5.0)
//            UtilityMethods.addBorder(self.viewDining, .lightGray, 5.0)
//
//            self.labelDelivery.textColor = .lightGray
//            self.labelDining.textColor = .lightGray
//            self.labelPickup.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
//
//            self.textFieldPostalCode.text = ""
//            self.labelPostalCode.isHidden = true
//            self.textFieldPostalCode.isHidden = true
//            self.viewBottomPostalCode.isHidden = true
//            self.textFieldPostalCode.isUserInteractionEnabled = false
//        }else if sender.tag == ConstantStrings.ORDER_TYPE_DINING {
//
//            self.popupController?.dismiss(animated: true)
//            self.setupSelectTablePopup()
//        }
//    }
    
//    Button Action for remove popup view
    @IBAction func buttonRemovePopupViewAction(_ sender: UIButton) {
        
        self.popupController?.dismiss(animated: true)
    }
    
//    Button Action for submit the postal code
    @IBAction func buttonSubmitPostalCodeAction(_ sender: UIButton) {
        
        if self.selectedOrderType == 0 {
            
            self.showToastWithMessage(self.viewPostalCode, ConstantStrings.PLEASE_SELECT_ORDER_TYPE)
        }else if self.selectedOrderType == ConstantStrings.ORDER_TYPE_DELIVERY {
            
            if self.textFieldPostalCode.text!.trim().isEmpty {
                
                self.textFieldPostalCode.becomeFirstResponder()
                self.showToastWithMessage(self.viewPostalCode, ConstantStrings.POSTAL_CODE_FIELD_IS_REQUIRED)
            }else {
                
                self.webApiPostalCodeDetails(self.textFieldPostalCode.text!)
            }
        }else if self.selectedOrderType == ConstantStrings.ORDER_TYPE_PICKUP {
    
            UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, self.selectedOrderType)
            self.itemAddToCartOperation(self.selectedAddToCartIndexPath)
            self.popupController?.dismiss(animated: true)
        }else {
            
//            UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, self.selectedOrderType)
//            self.itemAddToCartOperation(self.selectedAddToCartIndexPath)
            self.popupController?.dismiss(animated: true)
            self.setupSelectTablePopup()
        }
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
        
        if self.chooseOptionTableNumber == 0 {
            
            self.showToastWithMessage(self.viewSelectTable, ConstantStrings.PLEASE_CHOOSE_ONE_OPTION)
        }else if self.chooseOptionTableNumber == 1 {
            
            self.popDiningController?.dismiss(animated: true)
            let scannerVC = QRScannerController.init(nibName: "QRScannerController", bundle: nil)
            self.navigationController?.pushViewController(scannerVC, animated: true)
        }else {
            
            self.popDiningController?.dismiss(animated: true)
            let selectTableVC = SelectTableViewController.init(nibName: "SelectTableViewController", bundle: nil)
            selectTableVC.delegate = self
            self.navigationController?.pushViewController(selectTableVC, animated: true)
        }
    }
    
    @IBAction func buttonRemoveSelectTableNumberPopupAction(_ sender: UIButton) {
        
        self.popDiningController?.dismiss(animated: true)
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
    
    var height : CGFloat = 230.0
    var popupController:CNPPopupController?
    func setupViewPopupAnimation() -> Void {
        
        self.viewPostalCode.backgroundColor = .clear
        let orderType = UserDefaultOperations.getIntValue(ConstantStrings.ORDER_TYPE_VALUE)
        self.labelPostalCode.isHidden = true
        self.textFieldPostalCode.isHidden = true
        self.viewBottomPostalCode.isHidden = true
        self.heightPostalTextFieldView.constant = 0.5
        self.selectedOrderType = orderType
        self.collectionViewPopup.reloadData()
        
        UtilityMethods.addBorderAndShadow(self.viewPostalCode, 5.0)
        UtilityMethods.addBorderAndShadow(self.buttonSubmitPostalCod, self.buttonSubmitPostalCod.bounds.height / 2)
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
        
        print("Popup controller will be dismissed")
    }
    
    func popupControllerDidPresent(_ controller: CNPPopupController) {
        
        print("Popup controller presented")
    }
    
//    button back action
    @objc func buttonBackAction(_ sender: UIButton) {
        
//        self.button.removeFromSuperview()
//        self.viewPostalCode.removeFromSuperview()
    }
    
    //    MARK:- Web Api Code Start
//    Get Home Category Item list
    func webApiHomeCategoryItemList(_ categoryID : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_food_items.php?Category_ID=\(categoryID)&api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json[JSONKey.ERROR_CODE] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupCategoryItemList(json.dictionaryObject!)
                }
            }
        }
    }
    
    //    Setup Home Category item List
    func setupCategoryItemList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.MENU_CATEGORY] as? Array<Array<Dictionary<String, Any>>> != nil {
            
            self.arrayMenuItems.removeAll()
            let arrayRecommendData = jsonDictionary[JSONKey.MENU_CATEGORY] as! Array<Array<Dictionary<String, Any>>>
            var arrayRecommendList = Array<Dictionary<String, Any>>()
            var arrayRecommendItems = Array<Dictionary<String, Any>>()
            if arrayRecommendData.count > 0 {
                
                arrayRecommendList = arrayRecommendData[0]
                if arrayRecommendList.count > 0 {
                    
                    let dictionaryRecommendList = arrayRecommendList[0]
                    if dictionaryRecommendList[JSONKey.MENU_SUB_CATEGORY] as? Array<Dictionary<String, Any>> != nil {
                        
                        arrayRecommendItems = dictionaryRecommendList[JSONKey.MENU_SUB_CATEGORY] as! Array<Dictionary<String, Any>>
                        for recommendItem in arrayRecommendItems {
                            
                            var dictionaryRecommend = Dictionary<String, String>()
                            if recommendItem[JSONKey.ITEM_ID] as? Int != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_ID] = String(recommendItem[JSONKey.ITEM_ID] as! Int)
                            }
                            if recommendItem[JSONKey.ITEM_NAME] as? String != nil {
                                dictionaryRecommend[JSONKey.ITEM_NAME] = (recommendItem[JSONKey.ITEM_NAME] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_SIZE] as? String != nil {
                                dictionaryRecommend[JSONKey.ITEM_SIZE] = (recommendItem[JSONKey.ITEM_SIZE] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_OFFER_PRICE] as? String != nil {
                                if (recommendItem[JSONKey.ITEM_OFFER_PRICE] as! String).isEmpty {
                                    dictionaryRecommend[JSONKey.ITEM_OFFER_PRICE] = "0.00"
                                    dictionaryRecommend[JSONKey.ITEM_UPDATED_PRICE] = "0.00"
                                }else {
                                    dictionaryRecommend[JSONKey.ITEM_OFFER_PRICE] = (recommendItem[JSONKey.ITEM_OFFER_PRICE] as! String)
                                    dictionaryRecommend[JSONKey.ITEM_UPDATED_PRICE] = dictionaryRecommend[JSONKey.ITEM_OFFER_PRICE]
                                }
                            }
                            if recommendItem[JSONKey.ITEM_DESCRIPTION] as? String != nil {
                                dictionaryRecommend[JSONKey.ITEM_DESCRIPTION] = (recommendItem[JSONKey.ITEM_DESCRIPTION] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_FOOD_TYPE] as? String != nil {
                                dictionaryRecommend[JSONKey.ITEM_FOOD_TYPE] = (recommendItem[JSONKey.ITEM_FOOD_TYPE] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_FOOD_IMAGE] as? String != nil {
                                dictionaryRecommend[JSONKey.ITEM_FOOD_IMAGE] = (recommendItem[JSONKey.ITEM_FOOD_IMAGE] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_IS_SIZE_AVAILABLE] as? String != nil {
                                dictionaryRecommend[JSONKey.ITEM_IS_SIZE_AVAILABLE] = (recommendItem[JSONKey.ITEM_IS_SIZE_AVAILABLE] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_IS_EXTRA_AVAILABLE] as? String != nil {
                                dictionaryRecommend[JSONKey.ITEM_IS_EXTRA_AVAILABLE] = (recommendItem[JSONKey.ITEM_IS_EXTRA_AVAILABLE] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_IS_POPULAR] as? String != nil {
                                dictionaryRecommend[JSONKey.ITEM_IS_POPULAR] = (recommendItem[JSONKey.ITEM_IS_POPULAR] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_ORIGINAL_PRICE] as? String != nil {
                                if (recommendItem[JSONKey.ITEM_ORIGINAL_PRICE] as! String).isEmpty {
                                    dictionaryRecommend[JSONKey.ITEM_ORIGINAL_PRICE] = "0.00"
                                    dictionaryRecommend[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE] = "0.00"
                                }else {
                                    dictionaryRecommend[JSONKey.ITEM_ORIGINAL_PRICE] = (recommendItem[JSONKey.ITEM_ORIGINAL_PRICE] as! String)
                                    dictionaryRecommend[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE] = (recommendItem[JSONKey.ITEM_ORIGINAL_PRICE] as! String)
                                }
                            }
                            if recommendItem[JSONKey.ITEM_FOOD_TAX_APPLICABLE] as? String != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_FOOD_TAX_APPLICABLE] = (recommendItem[JSONKey.ITEM_FOOD_TAX_APPLICABLE] as! String)
                            }
                            
                            dictionaryRecommend[JSONKey.ITEM_IS_ADDED_TO_CART] = ConstantStrings.ITEM_NOT_ADDED_TO_CART
                            dictionaryRecommend[JSONKey.ITEM_QUANTITY] = "0"
                            dictionaryRecommend[JSONKey.ITEM_SIZE_ID] = ""
                            dictionaryRecommend[JSONKey.ITEM_SIZE_NAME] = ""
                            dictionaryRecommend[JSONKey.ITEM_SIZE_QUANTITY] = ""
                            dictionaryRecommend[JSONKey.ITEM_SIZE_PRICE] = "0.00"
                            dictionaryRecommend[JSONKey.ITEM_EXTRA_ID] = ""
                            dictionaryRecommend[JSONKey.ITEM_EXTRA_NAME] = ""
                            dictionaryRecommend[JSONKey.ITEM_EXTRA_QUANTITY] = ""
                            dictionaryRecommend[JSONKey.ITEM_EXTRA_PRICE] = "0.00"
                            dictionaryRecommend[JSONKey.ITEM_CHOOSE_CHAUCE_ID] = ""
                            dictionaryRecommend[JSONKey.ITEM_IS_EDITABLE] = ConstantStrings.FALSE_STRING
                            dictionaryRecommend[JSONKey.ITEM_CART_PRICE] = "0.0"
                            dictionaryRecommend[JSONKey.ITEM_CART_ORIGINAL_PRICE] = "0.0"
                            
                            if !dictionaryRecommend.isEmpty {
                                
                                self.arrayMenuItems.append(dictionaryRecommend)
                            }
                        }
                    }
                }
            }
        }
        
        self.checkIsItemAddedToCart()
        
        if self.isActiveCurrentViewController {
            
            self.tableView.reloadData()
            self.tableView.scrollToTop()
        }
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
                dictionaryPostalCode[JSONKey.POSTALCODE_MINIMUM_ORDER] = (jsonDictionary[JSONKey.POSTALCODE_MINIMUM_ORDER] as? String != nil) ? (jsonDictionary[JSONKey.POSTALCODE_MINIMUM_ORDER] as? String) : ""
                dictionaryPostalCode[JSONKey.POSTALCODE_SHIPPING_CHARGE] = (jsonDictionary[JSONKey.POSTALCODE_SHIPPING_CHARGE] as? String != nil) ? (jsonDictionary[JSONKey.POSTALCODE_SHIPPING_CHARGE] as? String) : ""
                dictionaryPostalCode[JSONKey.POSTALCODE_DELIVERY_CHARGE] = (jsonDictionary[JSONKey.POSTALCODE_DELIVERY_CHARGE] as? String != nil) ? (jsonDictionary[JSONKey.POSTALCODE_DELIVERY_CHARGE] as? String) : ""
                dictionaryPostalCode[JSONKey.POSTALCODE_POSTAL_CODE] = (jsonDictionary[JSONKey.POSTALCODE_POSTAL_CODE] as? String != nil) ? (jsonDictionary[JSONKey.POSTALCODE_POSTAL_CODE] as? String) : ""
                
                UserDefaultOperations.setDictionaryObject(ConstantStrings.POSTAL_CODE_INFO, dictionaryPostalCode)
                UserDefaultOperations.setIntValue(ConstantStrings.ORDER_TYPE_VALUE, ConstantStrings.ORDER_TYPE_DELIVERY)
                self.popupController?.dismiss(animated: true)
                
                let dictionary = self.arrayMenuItems[self.selectedAddToCartIndexPath.row]
                if dictionary[JSONKey.ITEM_IS_SIZE_AVAILABLE] == ConstantStrings.TRUE_STRING {
                    
                    let menuDetailsVC = MenuDetailsViewController.init(nibName: "MenuDetailsViewController", bundle: nil)
                    menuDetailsVC.delegate = self
                    menuDetailsVC.selectedIndex = self.selectedAddToCartIndexPath
                    menuDetailsVC.dictionaryMenuDetails = self.arrayMenuItems[self.selectedAddToCartIndexPath.row]
                    self.navigationController?.pushViewController(menuDetailsVC, animated: true)
                }else if dictionary[JSONKey.ITEM_IS_EXTRA_AVAILABLE] == ConstantStrings.TRUE_STRING {
                    
                    let dictionaryMenuDetails = self.arrayMenuItems[self.selectedAddToCartIndexPath.row]
                    let extraVC = ExtraViewController.init(nibName: "ExtraViewController", bundle: nil)
                    extraVC.isMovedFromMenu = true
                    extraVC.selectedSizeID = dictionaryMenuDetails[JSONKey.ITEM_SIZE_ID]!
                    extraVC.selectedIndex = self.selectedAddToCartIndexPath
                    extraVC.dictionaryMenuDetails = dictionaryMenuDetails
                    self.navigationController?.pushViewController(extraVC, animated: true)
                }else {
                    
                    self.itemAddToCartOperation(self.selectedAddToCartIndexPath)
                }
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
}


extension MenuViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("MenuTableViewCell", owner: self, options: nil)?.first as! MenuTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.indexPath = indexPath
        
        let dictionary = self.arrayMenuItems[indexPath.row]
        cell.labelMenuName.text = dictionary[JSONKey.ITEM_NAME]?.trim()
        cell.labelCount.text = dictionary[JSONKey.ITEM_QUANTITY]
        cell.labelAmount.text = ConstantStrings.RUPEES_SYMBOL + dictionary[JSONKey.ITEM_OFFER_PRICE]!
        cell.labelMenuDetails.text = dictionary[JSONKey.ITEM_DESCRIPTION]?.trim()
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: ConstantStrings.RUPEES_SYMBOL + dictionary[JSONKey.ITEM_ORIGINAL_PRICE]!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.gray, range: NSMakeRange(0, attributeString.length))
        cell.labelOriginalPrice.attributedText = attributeString
        
        if cell.labelMenuDetails.text!.isEmpty {
            
            cell.labelMenuDetails.text = " "
        }
        cell.buttonAddToCart.isHidden = true
        let isSizeAvailable = (dictionary[JSONKey.ITEM_IS_SIZE_AVAILABLE] == ConstantStrings.TRUE_STRING) ? true : false
        let isExtraAvailable = (dictionary[JSONKey.ITEM_IS_EXTRA_AVAILABLE] == ConstantStrings.TRUE_STRING) ? true : false
        if (dictionary[JSONKey.ITEM_IS_ADDED_TO_CART] == ConstantStrings.ITEM_ADDED_TO_CART) && !isSizeAvailable && !isExtraAvailable && !isMovedFromPayLaterDetailsPage {
            
            self.showAddToCart(cell)
        }else {
            
            self.hideAddToCart(cell)
        }
        
        return cell
    }
    
    func hideAddToCart(_ cell : MenuTableViewCell) -> Void {
        
        cell.labelCount.isHidden = true
        cell.labelMinus.isHidden = true
        cell.buttonMinus.isUserInteractionEnabled = false
        cell.buttonMinus.isHidden = true
        cell.buttonPlus.isUserInteractionEnabled = false
        cell.buttonAddToCart.isHidden = false
        cell.buttonAddToCart.isUserInteractionEnabled = true
        UtilityMethods.roundCorners(view: cell.labelPlus, corners: [.topRight, .bottomRight], radius: 5.0)
    }
    
    func showAddToCart(_ cell : MenuTableViewCell) -> Void {
        
        cell.labelCount.isHidden = false
        cell.labelMinus.isHidden = false
        cell.buttonMinus.isUserInteractionEnabled = true
        cell.buttonMinus.isHidden = false
        cell.buttonPlus.isUserInteractionEnabled = true
        cell.buttonAddToCart.isHidden = true
        cell.buttonAddToCart.isUserInteractionEnabled = false
        UtilityMethods.roundCorners(view: cell.labelPlus, corners: [.topRight, .bottomRight], radius: 5.0)
        UtilityMethods.roundCorners(view: cell.labelMinus, corners: [.topLeft, .bottomLeft], radius: 5.0)
    }
}

extension UIView{
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
}
