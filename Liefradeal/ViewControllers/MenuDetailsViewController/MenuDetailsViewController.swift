//
//  MenuDetailsViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 02/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

protocol ItemAddedIntoCartDelegate : class {
    
    func menuItemAddedIntoCart(_ indexPath : IndexPath, _ itemDetails : Dictionary<String, String>)
    func showMessageAddedItemInPaylaterOrder()
}

class MenuDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
//    func extraToppingAddedToItem(_ itemDetails: Dictionary<String, String>) {
//
//        self.delegate?.menuItemAddedIntoCart(self.selectedIndex, itemDetails)
//        self.navigationController?.popViewController(animated: true)
//    }
    
    @IBOutlet weak var buttonCart: UIButton!
    @IBOutlet weak var imageFoodType: UIImageView!
    @IBOutlet weak var labelMenuName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
        
    let SELECTED = "1"
    let UNSELECTED = "0"
    
    var arrayHeaderTitle = Array<String>()
    var arraySubTitleList = Array<Array<Dictionary<String, String>>>()
    
    var dictionaryMenuDetails = Dictionary<String, String>()
    weak var delegate : ItemAddedIntoCartDelegate?
    var selectedIndex = IndexPath()
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["Menu"] as? String != nil) ? (self.appDelegate.languageData["Menu"] as! String).trim() : "Menu"
        self.labelTotal.text = (self.appDelegate.languageData["Total"] as? String != nil) ? (self.appDelegate.languageData["Total"] as! String).trim() : "Total"
        self.setupBackBarButton()
        self.buttonCart.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.labelTotal.textColor = Colors.colorWithHexString(Colors.RED_COLOR)
        self.labelTotalAmount.textColor = Colors.colorWithHexString(Colors.RED_COLOR)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        
        if self.dictionaryMenuDetails.isEmpty{
            
            self.labelTotalAmount.text = " "
        }else {
            
            self.webApiGetItemSizeList(self.dictionaryMenuDetails[JSONKey.ITEM_ID]!)
            self.labelTotalAmount.text = ConstantStrings.RUPEES_SYMBOL + self.dictionaryMenuDetails[JSONKey.ITEM_OFFER_PRICE]!
        }
        
        self.setupTableViewDelegateAndDatasource()
        self.labelMenuName.text = self.dictionaryMenuDetails[JSONKey.ITEM_NAME]?.trim()
        self.labelDescription.text = self.dictionaryMenuDetails[JSONKey.ITEM_DESCRIPTION]?.trim()
        
        if self.dictionaryMenuDetails[JSONKey.ITEM_IS_EXTRA_AVAILABLE] == ConstantStrings.TRUE_STRING {
            let buttonTitle = (self.appDelegate.languageData["Add_Extra_Topping"] as? String != nil) ? (self.appDelegate.languageData["Add_Extra_Topping"] as! String).trim() : "Add Extra Topping"
            self.buttonCart.setTitle(buttonTitle, for: .normal)
        }else {
            let buttonTitle = (self.appDelegate.languageData["Add_to_cart"] as? String != nil) ? (self.appDelegate.languageData["Add_to_cart"] as! String).trim() : "Add to Cart"
            self.buttonCart.setTitle(buttonTitle, for: .normal)
        }
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
        if Int(dictionary[JSONKey.SIZE_IS_SELECTED]!) == 1 {
            cell.imageViewSelection.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
        }else {
            cell.imageViewSelection.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
        }
        cell.labelPrice.text = ConstantStrings.RUPEES_SYMBOL + dictionary[JSONKey.SIZE_OFFER_PRICE]!
        cell.labelMenuDetail.text = dictionary[JSONKey.SIZE_NAME]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var arrayMenuDetails = self.arraySubTitleList[indexPath.section]
        var dictionary = arrayMenuDetails[indexPath.row]
        
        if Int(dictionary[JSONKey.SIZE_IS_SELECTED]!) == 0 {
            
            for i in 0..<arrayMenuDetails.count {
                
                var dicDetails = arrayMenuDetails[i]
                dicDetails[JSONKey.SIZE_IS_SELECTED] = self.UNSELECTED
                arrayMenuDetails[i] = dicDetails
            }
            
            dictionary[JSONKey.SIZE_IS_SELECTED] = self.SELECTED
            arrayMenuDetails[indexPath.row] = dictionary
            self.arraySubTitleList[indexPath.section] = arrayMenuDetails
            self.tableView.reloadData()
        }
        
        self.dictionaryMenuDetails[JSONKey.ITEM_SIZE_ID] = dictionary[JSONKey.SIZE_ID]
        self.dictionaryMenuDetails[JSONKey.ITEM_SIZE_NAME] = dictionary[JSONKey.SIZE_NAME]
        self.dictionaryMenuDetails[JSONKey.ITEM_SIZE_PRICE] = dictionary[JSONKey.SIZE_OFFER_PRICE]
        self.dictionaryMenuDetails[JSONKey.ITEM_SIZE_QUANTITY] = "1"
        self.setupExtraItems()
    }
    
    //    MARK:- Button Action
    @IBAction func buttonAddToCartAction(_ sender: UIButton) {
        
        
        if self.arraySubTitleList.count == 0 || self.arrayHeaderTitle.count == 0 {
            
            self.showToastWithMessage(self.view, ConstantStrings.PLEASE_SELECT_OPTION)
            return
        }
        
        if self.dictionaryMenuDetails[JSONKey.ITEM_IS_EXTRA_AVAILABLE] == ConstantStrings.TRUE_STRING {
            
            let extraVC = ExtraViewController.init(nibName: "ExtraViewController", bundle: nil)
            extraVC.selectedSizeID = self.dictionaryMenuDetails[JSONKey.ITEM_SIZE_ID]!
            extraVC.selectedIndex = self.selectedIndex
            extraVC.dictionaryMenuDetails = self.dictionaryMenuDetails
            self.navigationController?.pushViewController(extraVC, animated: true)
        }else {
            
            var arrayCart = Array<Dictionary<String, String>>()
            if isMovedFromPayLaterDetailsPage {
                arrayCart = arrayGlobalPayLaterList
            }else {
                arrayCart = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST) as! Array<Dictionary<String, String>>
            }
            self.dictionaryMenuDetails[JSONKey.ITEM_IS_ADDED_TO_CART] = ConstantStrings.ITEM_ADDED_TO_CART
            self.dictionaryMenuDetails[JSONKey.ITEM_QUANTITY] = ConstantStrings.ITEM_ADDED_TO_CART
            if isMovedFromPayLaterDetailsPage {
                self.dictionaryMenuDetails[JSONKey.ORDER_ID] = selectedPayLaterGlobalOrderID
            }
                            
            if arrayCart.count == 0 {
                arrayCart = [self.dictionaryMenuDetails]
            }else {
                if isMovedFromPayLaterDetailsPage {
                    var i = 0
                    var isMatched = Bool()
                    for item in arrayCart {
                        if (item[JSONKey.ITEM_ID] == self.dictionaryMenuDetails[JSONKey.ITEM_ID]) && (item[JSONKey.ITEM_SIZE_ID] == self.dictionaryMenuDetails[JSONKey.ITEM_SIZE_ID]) {
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
                        arrayCart.append(self.dictionaryMenuDetails)
                    }
                }else {
                    arrayCart.append(self.dictionaryMenuDetails)
                }
            }
            
            if isMovedFromPayLaterDetailsPage {
                payLaterGlobalOrderID = selectedPayLaterGlobalOrderID
                arrayGlobalPayLaterList = arrayCart
                self.delegate?.showMessageAddedItemInPaylaterOrder()
            }else {
                UserDefaultOperations.setArrayObject(ConstantStrings.CART_ITEM_LIST, arrayCart)
                self.delegate?.menuItemAddedIntoCart(self.selectedIndex, self.dictionaryMenuDetails)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //    MARK:- Web Api Code Start
//    Get Item size List
    func webApiGetItemSizeList(_ itemID : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_restaurantMenuItemSize.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&ItemID=\(itemID)"
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
        
        let arraySizeList = jsonDictionary[JSONKey.ITEM_SIZE_LIST] as! Array<Dictionary<String, Any>>
        
        if arraySizeList.count == 0 {
            
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.SIZE_NOT_AVAILABLE)
        }else {
            
            if arraySizeList.count > 0 {
                let sizeString = (self.appDelegate.languageData["size"] as? String != nil) ? (self.appDelegate.languageData["size"] as! String).trim() : "Size"
                self.arrayHeaderTitle.append(sizeString)
            }
            var arraySizeDictionary = Array<Dictionary<String, String>>()
            for i in 0..<arraySizeList.count {
                
                var dictionarySize = Dictionary<String, String>()
                let sizeDetails = arraySizeList[i]
                
                if sizeDetails[JSONKey.SIZE_ID] as? Int != nil {
                    
                    dictionarySize[JSONKey.SIZE_ID] = String(sizeDetails[JSONKey.SIZE_ID] as! Int)
                }
                if sizeDetails[JSONKey.SIZE_ITEM_ID] as? Int != nil {
                    
                    dictionarySize[JSONKey.SIZE_ITEM_ID] = String(sizeDetails[JSONKey.SIZE_ITEM_ID] as! Int)
                }
                if sizeDetails[JSONKey.SIZE_ITEM_NAME] as? String != nil {
                    
                    dictionarySize[JSONKey.SIZE_ITEM_NAME] = (sizeDetails[JSONKey.SIZE_ITEM_NAME] as! String)
                }
                if sizeDetails[JSONKey.SIZE_NAME] as? String != nil {
                    
                    dictionarySize[JSONKey.SIZE_NAME] = (sizeDetails[JSONKey.SIZE_NAME] as! String)
                }
                if sizeDetails[JSONKey.SIZE_OFFER_PRICE] as? String != nil {
                    
                    dictionarySize[JSONKey.SIZE_OFFER_PRICE] = (sizeDetails[JSONKey.SIZE_OFFER_PRICE] as! String)
                }
                if sizeDetails[JSONKey.SIZE_EXTRA_AVAILABLE] as? String != nil {
                    
                    dictionarySize[JSONKey.SIZE_EXTRA_AVAILABLE] = (sizeDetails[JSONKey.SIZE_EXTRA_AVAILABLE] as! String)
                }
                if sizeDetails[JSONKey.SIZE_ORIGINAL_PRICE] as? String != nil {
                    
                    dictionarySize[JSONKey.SIZE_ORIGINAL_PRICE] = (sizeDetails[JSONKey.SIZE_ORIGINAL_PRICE] as! String)
                }
                
                if i == 0 {
                    
                    dictionarySize[JSONKey.SIZE_IS_SELECTED] = self.SELECTED
                    self.dictionaryMenuDetails[JSONKey.ITEM_SIZE_ID] = dictionarySize[JSONKey.SIZE_ID]
                    self.dictionaryMenuDetails[JSONKey.ITEM_SIZE_NAME] = dictionarySize[JSONKey.SIZE_NAME]
                    self.dictionaryMenuDetails[JSONKey.ITEM_SIZE_PRICE] = dictionarySize[JSONKey.SIZE_OFFER_PRICE]
                    self.dictionaryMenuDetails[JSONKey.ITEM_SIZE_QUANTITY] = "1"
                }else {
                    
                    dictionarySize[JSONKey.SIZE_IS_SELECTED] = self.UNSELECTED
                }
                
                if !dictionarySize.isEmpty {
                    
                    arraySizeDictionary.append(dictionarySize)
                }
            }
            
            self.arraySubTitleList.append(arraySizeDictionary)
            self.tableView.reloadData()
            self.setupExtraItems()
        }
    }
}

