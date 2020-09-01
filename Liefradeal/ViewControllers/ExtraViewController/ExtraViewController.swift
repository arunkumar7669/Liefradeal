//
//  ExtraViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 17/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class ExtraViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonCart: UIButton!
//    @IBOutlet weak var imageFoodType: UIImageView!
    @IBOutlet weak var labelMenuName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var labelFreeToppingCount: UILabel!
    
//    let EXTRA_TOPPING_NAME = "Extra Topping"
//    let EXTRA_STRING = "Extra"
    let SELECTED = "1"
    let UNSELECTED = "0"
    var freeToppingLimit = Int()
    var selectionLimit = Int()
    var isCheckBoxEnable = Bool()
    var selectedIndex = IndexPath()
    var selectedSizeID = String()
    var isMovedFromMenu = Bool()
    var arrayHeaderTitle = Array<String>()
    var arraySubTitleList = Array<Array<Dictionary<String, String>>>()
    var dictionaryMenuDetails = Dictionary<String, String>()
    
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
        self.navigationItem.title = (self.appDelegate.languageData["Extra_Topping"] as? String != nil) ? (self.appDelegate.languageData["Extra_Topping"] as! String).trim() : "Extra Topping"
        self.labelTotal.text = (self.appDelegate.languageData["Total"] as? String != nil) ? (self.appDelegate.languageData["Total"] as! String).trim() : "Total"
        let buttonTitle = (self.appDelegate.languageData["Add_to_cart"] as? String != nil) ? (self.appDelegate.languageData["Add_to_cart"] as! String).trim() : "Add to Cart"
        self.buttonCart.setTitle(buttonTitle, for: .normal)
        self.setupBackBarButton()
        self.buttonCart.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.labelTotal.textColor = Colors.colorWithHexString(Colors.RED_COLOR)
        self.labelTotalAmount.textColor = Colors.colorWithHexString(Colors.RED_COLOR)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        if self.dictionaryMenuDetails.isEmpty{
            self.labelTotalAmount.text = " "
        }else {
            self.webApiGetItemSizeList(self.dictionaryMenuDetails[JSONKey.ITEM_ID]!, self.selectedSizeID)
            self.labelTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + self.dictionaryMenuDetails[JSONKey.ITEM_OFFER_PRICE]!
        }
        self.labelFreeToppingCount.text = ""
        self.setupTableViewDelegateAndDatasource()
        self.labelMenuName.text = self.dictionaryMenuDetails[JSONKey.ITEM_NAME]?.trim()
        self.labelDescription.text = self.dictionaryMenuDetails[JSONKey.ITEM_DESCRIPTION]?.trim()
    }
    
//    setup extra items
    func setupExtraItems() -> Void {
        
        self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_PRICE] = self.dictionaryMenuDetails[JSONKey.ITEM_OFFER_PRICE]
        self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE] = self.dictionaryMenuDetails[JSONKey.ITEM_ORIGINAL_PRICE]
        for i in 0..<self.arraySubTitleList.count {
            let arrayExtraItems = self.arraySubTitleList[i]
            for dicItems in arrayExtraItems {
                if dicItems[JSONKey.SIZE_IS_SELECTED] == self.SELECTED {
                    let price = (Double(dicItems[JSONKey.SIZE_OFFER_PRICE]!) != nil) ? Double(dicItems[JSONKey.SIZE_OFFER_PRICE]!) : 0.00
                    self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_PRICE] = String(format: "%.2f", price!)
                    self.dictionaryMenuDetails[JSONKey.ITEM_OFFER_PRICE] = self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_PRICE]
                    let originalPrice = (Double(dicItems[JSONKey.SIZE_ORIGINAL_PRICE]!) != nil) ? Double(dicItems[JSONKey.SIZE_ORIGINAL_PRICE]!) : 0.00
                    self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE] = String(format: "%.2f", originalPrice!)
                    self.dictionaryMenuDetails[JSONKey.ITEM_ORIGINAL_PRICE] = self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE]
                }
            }
        }
        print("Calculated Amount ", self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_PRICE]!)
        self.labelTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_PRICE]!
        self.dictionaryMenuDetails[JSONKey.ITEM_CART_PRICE] = self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_PRICE]
        self.dictionaryMenuDetails[JSONKey.ITEM_CART_ORIGINAL_PRICE] = self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE]
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
        
        return self.arrayHeaderTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.arrayHeaderTitle.count > 0 {
            return self.arraySubTitleList[0].count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewContainer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        viewContainer.backgroundColor = .white
        
        let labelTitle = UILabel.init(frame: CGRect.init(x: 45, y: 15, width: self.view.bounds.width, height: 20))
        labelTitle.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        labelTitle.text = self.arrayHeaderTitle[section]
        
        viewContainer.addSubview(labelTitle)
        
        return viewContainer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("MenuDetailsTableViewCell", owner: self, options: nil)?.first as! MenuDetailsTableViewCell
        cell.selectionStyle = .none
        
        let arrayMenuDetails = self.arraySubTitleList[indexPath.section]
        let dictionary = arrayMenuDetails[indexPath.row]
        
        if Int(dictionary[JSONKey.ITEM_EXTRA_TOPPING_IS_SELECTED]!) == 1 {
            
            if self.isCheckBoxEnable {
                
                cell.imageViewSelection.image = UIImage.init(named: ConstantStrings.SELECTED_CHECK_BOX)
            }else {
                
                cell.imageViewSelection.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
            }
            UtilityMethods.changeImageColor(cell.imageViewSelection, Colors.colorWithHexString(Colors.GREEN_COLOR))
        }else {
            
            if self.isCheckBoxEnable {
                
                cell.imageViewSelection.image = UIImage.init(named: ConstantStrings.UNSELECTED_CHECK_BOX)
            }else {
                
                cell.imageViewSelection.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
            }
            UtilityMethods.changeImageColor(cell.imageViewSelection, .lightGray)
        }
        cell.labelPrice.text = ConstantStrings.RUPEES_SYMBOL + dictionary[JSONKey.ITEM_EXTRA_TOPPING_PRICE]!
        cell.labelMenuDetail.text = dictionary[JSONKey.ITEM_EXTRA_TOPPING_FOOD_NAME]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isCheckBoxEnable {
            var isAddable = Bool()
            var arrayMenuDetails = self.arraySubTitleList[indexPath.section]
            var dictionary = arrayMenuDetails[indexPath.row]
            if dictionary[JSONKey.ITEM_EXTRA_TOPPING_IS_SELECTED] == "0" {
                isAddable = true
                dictionary[JSONKey.ITEM_EXTRA_TOPPING_IS_SELECTED] = "1"
            }else {
                isAddable = false
                dictionary[JSONKey.ITEM_EXTRA_TOPPING_IS_SELECTED] = "0"
            }
            arrayMenuDetails[indexPath.row] = dictionary
            self.arraySubTitleList[indexPath.section] = arrayMenuDetails
            self.tableView.reloadData()
            var freeToppingCount = Int()
            arrayMenuDetails = self.arraySubTitleList[indexPath.section]
            for extraTopping in arrayMenuDetails {
                if extraTopping[JSONKey.ITEM_EXTRA_TOPPING_IS_SELECTED] == "1" {
                    freeToppingCount += 1
                }
            }
            if (freeToppingCount == self.freeToppingLimit) && (self.freeToppingLimit != 0) {
                var stringMessage = (self.appDelegate.languageData["YOUR_HAVE_CHOOSED_FREE_TOPPING"] as? String != nil) ? (self.appDelegate.languageData["YOUR_HAVE_CHOOSED_FREE_TOPPING"] as! String).trim() : "You have been choosed your $ free topping."
                stringMessage = stringMessage.replacingOccurrences(of: "$", with: "\(self.freeToppingLimit)")
                self.showToastWithMessage(self.view, stringMessage)
            }
            if freeToppingCount >= self.freeToppingLimit {
                var totalAmount = Double()
                if isAddable {
                    if freeToppingCount > self.freeToppingLimit {
                        totalAmount = Double(self.labelTotalAmount.text!.dropFirst(1))! + Double(dictionary[JSONKey.ITEM_EXTRA_TOPPING_PRICE]!)!
                        self.labelTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", totalAmount)
                    }
                }else {
                    totalAmount = Double(self.labelTotalAmount.text!.dropFirst(1))! - Double(dictionary[JSONKey.ITEM_EXTRA_TOPPING_PRICE]!)!
                    self.labelTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", totalAmount)
                }
            }
        }else {
            var arrayMenuDetails = self.arraySubTitleList[indexPath.section]
            for i in 0..<arrayMenuDetails.count {
                var dictionary = arrayMenuDetails[i]
                dictionary[JSONKey.ITEM_EXTRA_TOPPING_IS_SELECTED] = "0"
                arrayMenuDetails[i] = dictionary
            }
            var dictionary = arrayMenuDetails[indexPath.row]
            dictionary[JSONKey.ITEM_EXTRA_TOPPING_IS_SELECTED] = "1"
            arrayMenuDetails[indexPath.row] = dictionary
            self.arraySubTitleList[indexPath.section] = arrayMenuDetails
            self.tableView.reloadData()
            var totalAmount = Double()
            for i in 0..<self.arraySubTitleList.count {
                let arrayMenuDetails = self.arraySubTitleList[i]
                for j in 0..<arrayMenuDetails.count {
                    let dictionary = arrayMenuDetails[j]
                    if dictionary[JSONKey.ITEM_EXTRA_TOPPING_IS_SELECTED] == "1" {
                        totalAmount += Double(dictionary[JSONKey.ITEM_EXTRA_TOPPING_PRICE]!)!
                    }
                }
            }
            totalAmount += Double(self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_PRICE]!)!
            self.labelTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + String(format : "%.2f", totalAmount)
        }
    }
    
    //    MARK:- Button Action
    @IBAction func buttonAddToCartAction(_ sender: UIButton) {
        
        if self.arraySubTitleList.count == 0 || self.arrayHeaderTitle.count == 0 {
            self.showToastWithMessage(self.view, ConstantStrings.PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING)
            return
        }
        if self.arraySubTitleList.count > 0 {
            
            var stringExtraID = ""
            var stringExtraName = ""
            var stringExtraPrice = ""
            var stringExtraQuantity = ""
            var isSelectedAny = Bool()
            
            for i in 0..<self.arraySubTitleList.count {
                let arrayMenuDetails = self.arraySubTitleList[i]
                for dictionary in arrayMenuDetails {
                    if dictionary[JSONKey.ITEM_EXTRA_TOPPING_IS_SELECTED] == "1" {
                        isSelectedAny = true
                        if !stringExtraID.isEmpty {
                            stringExtraID.append("|")
                            stringExtraPrice.append("|")
                            stringExtraName.append("|")
                            stringExtraQuantity.append("|")
                        }
                        stringExtraQuantity.append("1")
                        stringExtraID.append(dictionary[JSONKey.ITEM_EXTRA_TOPPING_ID]!)
                        stringExtraPrice.append(dictionary[JSONKey.ITEM_EXTRA_TOPPING_PRICE]!)
                        stringExtraName.append(dictionary[JSONKey.ITEM_EXTRA_TOPPING_FOOD_NAME]!)
                    }
                }
            }
            if !isSelectedAny {
                self.showToastWithMessage(self.view, ConstantStrings.PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING)
                return
            }
            let extraToppingAmount = Double(self.labelTotalAmount.text!.dropFirst(1))! - Double(self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_PRICE]!)!
            self.dictionaryMenuDetails[JSONKey.ITEM_EXTRA_ID] = stringExtraID
            self.dictionaryMenuDetails[JSONKey.ITEM_EXTRA_NAME] = stringExtraName
            self.dictionaryMenuDetails[JSONKey.ITEM_EXTRA_PRICE] = String(format : "%.2f", extraToppingAmount)
            self.dictionaryMenuDetails[JSONKey.ITEM_EXTRA_QUANTITY] = stringExtraQuantity
        }
        
        var arrayCart = Array<Dictionary<String, String>>()
        if isMovedFromPayLaterDetailsPage {
            arrayCart = arrayGlobalPayLaterList
        }else {
            arrayCart = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST) as! Array<Dictionary<String, String>>
        }
        var selectedCartIndex = -1
        for i in 0..<arrayCart.count {
            let dictionary = arrayCart[i]
            if (dictionary[JSONKey.ITEM_EXTRA_ID] == self.dictionaryMenuDetails[JSONKey.ITEM_EXTRA_ID]) && (dictionary[JSONKey.ITEM_SIZE_ID] == self.dictionaryMenuDetails[JSONKey.ITEM_SIZE_ID]) && (dictionary[JSONKey.ITEM_ID] == self.dictionaryMenuDetails[JSONKey.ITEM_ID]) {
                selectedCartIndex = i
                break
            }
        }
        
        if selectedCartIndex >= 0 {
            var cartDictionary = arrayCart[selectedCartIndex]
            let quantity = Int(cartDictionary[JSONKey.ITEM_QUANTITY]!)! + 1
            let cartAmount = Double(self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_PRICE]!)! * Double(quantity)
            let cartOriginalAmount = Double(self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE]!)! * Double(quantity)
            cartDictionary[JSONKey.ITEM_CART_PRICE] = String(format : "%.2f", cartAmount)
            cartDictionary[JSONKey.ITEM_CART_ORIGINAL_PRICE] = String(format : "%.2f", cartOriginalAmount)
            cartDictionary[JSONKey.ITEM_QUANTITY] = "\(quantity)"
            arrayCart[selectedCartIndex] = cartDictionary
        }else {
            if self.isMovedFromMenu {
                self.dictionaryMenuDetails[JSONKey.ITEM_CART_PRICE] = self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_PRICE]
                self.dictionaryMenuDetails[JSONKey.ITEM_CART_ORIGINAL_PRICE] = self.dictionaryMenuDetails[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE]
            }
            self.dictionaryMenuDetails[JSONKey.ITEM_IS_ADDED_TO_CART] = ConstantStrings.ITEM_ADDED_TO_CART
            self.dictionaryMenuDetails[JSONKey.ITEM_QUANTITY] = ConstantStrings.ITEM_ADDED_TO_CART
            if isMovedFromPayLaterDetailsPage {
                self.dictionaryMenuDetails[JSONKey.ORDER_ID] = selectedPayLaterGlobalOrderID
            }
            
            if arrayCart.count == 0 {
                arrayCart = [self.dictionaryMenuDetails]
            }else {
                arrayCart.append(self.dictionaryMenuDetails)
            }
        }
        
        if isMovedFromPayLaterDetailsPage {
            payLaterGlobalOrderID = selectedPayLaterGlobalOrderID
            arrayGlobalPayLaterList = arrayCart
        }else {
            UserDefaultOperations.setArrayObject(ConstantStrings.CART_ITEM_LIST, arrayCart)
        }
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MenuViewController.self) {
                let menuVC = controller as! MenuViewController
                if isMovedFromPayLaterDetailsPage {
                    menuVC.showMessageAddedItemInPaylaterOrder()
                }else {
                    menuVC.menuItemAddedIntoCart(self.selectedIndex, self.dictionaryMenuDetails)
                }
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    //    MARK:- Web Api Code Start
//    Get Item size List
    func webApiGetItemSizeList(_ itemID : String, _ sizeID : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_food_items_extra.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&ItemID=\(itemID)&FoodItemSizeID=\(sizeID)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupItemSizeList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup Item Size List
    func setupItemSizeList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ITEM_EXTRA_TOPPING] as? Array<Array<Dictionary<String, Any>>> != nil {
            
            let arrayExtraTopping = jsonDictionary[JSONKey.ITEM_EXTRA_TOPPING] as! Array<Array<Dictionary<String, Any>>>
            if arrayExtraTopping.count > 0 {
                
                let arrayExtraToppingList = arrayExtraTopping[0]
                for extraTopping in arrayExtraToppingList {
                    
                    if (extraTopping[JSONKey.ITEM_EXTRA_TOPPING_NAME] as? String) != nil {
                        
//                        if (extraTopping[JSONKey.ITEM_EXTRA_TOPPING_NAME] as! String) == self.EXTRA_TOPPING_NAME {
                            
                            self.isCheckBoxEnable = ((extraTopping[JSONKey.ITEM_EXTRA_TOPPING_SELECTION_TYPE] as? String) != nil) ? ((extraTopping[JSONKey.ITEM_EXTRA_TOPPING_SELECTION_TYPE] as! String) == ConstantStrings.ITEM_EXTRA_TOPPING_SELECTION_TYPE) : false
                            print(self.isCheckBoxEnable)
                            
                            if extraTopping[JSONKey.ITEM_EXTRA_TOPPING_LIST] as? Array<Dictionary<String, Any>> != nil {
                            var arrayExtraToppingDictionary = Array<Dictionary<String, String>>()
                            let arrayExtraToppingsDetails = extraTopping[JSONKey.ITEM_EXTRA_TOPPING_LIST] as! Array<Dictionary<String, Any>>
                                for toppingDetails in arrayExtraToppingsDetails {
                                    
                                    var extraToppingDictionary = Dictionary<String, String>()
                                    extraToppingDictionary[JSONKey.ITEM_EXTRA_TOPPING_ID] = ((toppingDetails[JSONKey.ITEM_EXTRA_TOPPING_ID] as? Int) != nil) ? String(toppingDetails[JSONKey.ITEM_EXTRA_TOPPING_ID] as! Int) : "0"
                                    extraToppingDictionary[JSONKey.ITEM_EXTRA_TOPPING_FOOD_NAME] = ((toppingDetails[JSONKey.ITEM_EXTRA_TOPPING_FOOD_NAME] as? String) != nil) ? (toppingDetails[JSONKey.ITEM_EXTRA_TOPPING_FOOD_NAME] as! String) : "-"
                                    extraToppingDictionary[JSONKey.ITEM_EXTRA_TOPPING_PRICE] = ((toppingDetails[JSONKey.ITEM_EXTRA_TOPPING_PRICE] as? String) != nil) ? (toppingDetails[JSONKey.ITEM_EXTRA_TOPPING_PRICE] as! String) : "0.00"
                                    extraToppingDictionary[JSONKey.ITEM_EXTRA_TOPPING_SELECTION_LIMIT] = ((toppingDetails[JSONKey.ITEM_EXTRA_TOPPING_SELECTION_LIMIT] as? Int) != nil) ? String(toppingDetails[JSONKey.ITEM_EXTRA_TOPPING_SELECTION_LIMIT] as! Int) : "0"
                                    extraToppingDictionary[JSONKey.ITEM_EXTRA_TOPPING_IS_SELECTED] = "0"
                                    
                                    self.freeToppingLimit = (Int(extraToppingDictionary[JSONKey.ITEM_EXTRA_TOPPING_SELECTION_LIMIT]!) != nil) ? Int(extraToppingDictionary[JSONKey.ITEM_EXTRA_TOPPING_SELECTION_LIMIT]!)! : 0
                                    if !extraToppingDictionary.isEmpty {
                                        
                                        arrayExtraToppingDictionary.append(extraToppingDictionary)
                                    }
                                    print(extraToppingDictionary)
                                }
                                if self.freeToppingLimit == 0 {
                                    self.labelFreeToppingCount.text = ""
                                }else {
                                    
                                    var chooseFreeTopping = (self.appDelegate.languageData["CHOOSE_ANY_FREE_TOPINGS"] as? String != nil) ? (self.appDelegate.languageData["CHOOSE_ANY_FREE_TOPINGS"] as! String).trim() : "Choose Any $ Topping Free"
                                    chooseFreeTopping = chooseFreeTopping.replacingOccurrences(of: "$", with: "\(self.freeToppingLimit)")
                                    self.labelFreeToppingCount.text = chooseFreeTopping
                                }
                                self.labelFreeToppingCount.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
                                if !arrayExtraToppingDictionary.isEmpty {
                                    
                                    self.arrayHeaderTitle.append((extraTopping[JSONKey.ITEM_EXTRA_TOPPING_NAME] as! String))
                                    self.arraySubTitleList.append(arrayExtraToppingDictionary)
                                }
                            }
//                        }
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
}
//Choose Any 5 Topping Free
