//
//  DeliveryViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 02/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class DeliveryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var labelAreaName: UILabel!
    @IBOutlet weak var labelPostalCode: UILabel!
    @IBOutlet weak var labelMinAmount: UILabel!
    @IBOutlet weak var labelDeliveryCharge: UILabel!
    @IBOutlet weak var buttonGotoMenu: UIButton!
    @IBOutlet weak var labelNoDeliveryArea: UILabel!
    
    var arrayDeliveryList = Array<Dictionary<String, String>>()
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["delivery_area"] as? String != nil) ? (self.appDelegate.languageData["delivery_area"] as! String).trim() : "Delivery Area"
        self.labelNoDeliveryArea.text = (self.appDelegate.languageData["NO_DELIVERY_AREA_AVAILABLE"] as? String != nil) ? (self.appDelegate.languageData["NO_DELIVERY_AREA_AVAILABLE"] as! String).trim() : "No Delivery area available."
        self.labelAreaName.text = (self.appDelegate.languageData["Area_Name"] as? String != nil) ? (self.appDelegate.languageData["Area_Name"] as! String).trim() : "Area Name"
        
        self.labelPostalCode.text = (self.appDelegate.languageData["Postal_Code"] as? String != nil) ? (self.appDelegate.languageData["Postal_Code"] as! String).trim() : "Postcode"
        self.labelMinAmount.text = (self.appDelegate.languageData["Min_Amount_for_Delivery"] as? String != nil) ? (self.appDelegate.languageData["Min_Amount_for_Delivery"] as! String).trim() : "Area Name"
        self.labelDeliveryCharge.text = (self.appDelegate.languageData["Delivery_Charge"] as? String != nil) ? (self.appDelegate.languageData["Delivery_Charge"] as! String).trim() : "Delivery\ncharge"
        
        self.setupBackBarButton()
        self.labelNoDeliveryArea.isHidden = true
        self.labelAreaName.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.labelPostalCode.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.labelMinAmount.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.labelDeliveryCharge.textColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.buttonGotoMenu.setTitle(ConstantStrings.GO_TO_MENU, for: .normal)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
//        self.viewContent.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        UtilityMethods.addBorderAndShadow(self.viewContent, 5.0)
        self.buttonGotoMenu.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.setupTableViewDelegateAndDatasource()
        self.webApiGetDeliveryArea()
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
        
        return self.arrayDeliveryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("DeliveryTableViewCell", owner: self, options: nil)?.first as! DeliveryTableViewCell
        cell.selectionStyle = .none
        
        let dictionary = self.arrayDeliveryList[indexPath.row]
        print(dictionary)
        
        cell.labelAreaName.text = dictionary[JSONKey.DELIVERY_AREA_ADMIN_DISTRICT]
        cell.labelMinAmount.text = dictionary[JSONKey.DELIVERY_AREA_POSTAL_CODE]
        cell.labelPostalCode.text = dictionary[JSONKey.DELIVERY_AREA_MINIMUM_ORDER]
        cell.labelDeliveryCharge.text = ConstantStrings.RUPEES_SYMBOL + dictionary[JSONKey.DELIVERY_AREA_DELIVERY_CHARGE]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    //    MARK:- Button Action
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
        self.moveOnMenuPage()
    }
    
    //    MARK:- Web Api Code Start
//    Api for get Delivery area
    func webApiGetDeliveryArea() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_get_restaurant_delivery_list.php?lang_code=\(WebApi.LANGUAGE_CODE)&api_key=\(WebApi.API_KEY)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupRestaurantDeliveryAreaList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    func setup delivery area list
    func setupRestaurantDeliveryAreaList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        //        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
        
        //            if jsonDictionary[JSONKey.ERROR_CODE] as! Int == 0 {
        
        if jsonDictionary[JSONKey.DELIVERY_AREA_LIST] as? Array<Dictionary<String, Any>> != nil {
            
            let arrayDeliveryArea = jsonDictionary[JSONKey.DELIVERY_AREA_LIST] as! Array<Dictionary<String, Any>>
            
            for area in arrayDeliveryArea {
                
                var dictionaryDelivery = Dictionary<String, String>()
                dictionaryDelivery[JSONKey.DELIVERY_AREA_ID] = (area[JSONKey.DELIVERY_AREA_ID] as? Int != nil) ? String(area[JSONKey.DELIVERY_AREA_ID] as! Int) : "0"
                dictionaryDelivery[JSONKey.DELIVERY_AREA_POSTAL_CODE] = (area[JSONKey.DELIVERY_AREA_POSTAL_CODE] as? String != nil) ? (area[JSONKey.DELIVERY_AREA_POSTAL_CODE] as! String) : " "
                dictionaryDelivery[JSONKey.DELIVERY_AREA_ADMIN_DISTRICT] = (area[JSONKey.DELIVERY_AREA_ADMIN_DISTRICT] as? String != nil) ? (area[JSONKey.DELIVERY_AREA_ADMIN_DISTRICT] as! String) : " "
                dictionaryDelivery[JSONKey.DELIVERY_AREA_LATITUDE] = (area[JSONKey.DELIVERY_AREA_LATITUDE] as? String != nil) ? (area[JSONKey.DELIVERY_AREA_LATITUDE] as! String) : " "
                dictionaryDelivery[JSONKey.DELIVERY_AREA_LONGITUDE] = (area[JSONKey.DELIVERY_AREA_LONGITUDE] as? String != nil) ? (area[JSONKey.DELIVERY_AREA_LONGITUDE] as! String) : " "
                dictionaryDelivery[JSONKey.DELIVERY_AREA_MIN_RANGE] = (area[JSONKey.DELIVERY_AREA_MIN_RANGE] as? String != nil) ? (area[JSONKey.DELIVERY_AREA_MIN_RANGE] as! String) : " "
                dictionaryDelivery[JSONKey.DELIVERY_AREA_MAX_RANGE] = (area[JSONKey.DELIVERY_AREA_MAX_RANGE] as? String != nil) ? (area[JSONKey.DELIVERY_AREA_MAX_RANGE] as! String) : " "
                dictionaryDelivery[JSONKey.DELIVERY_AREA_MINIMUM_ORDER] = (area[JSONKey.DELIVERY_AREA_MINIMUM_ORDER] as? String != nil) ? (area[JSONKey.DELIVERY_AREA_MINIMUM_ORDER] as! String) : " "
                dictionaryDelivery[JSONKey.DELIVERY_AREA_DELIVERY_CHARGE] = (area[JSONKey.DELIVERY_AREA_DELIVERY_CHARGE] as? String != nil) ? (area[JSONKey.DELIVERY_AREA_DELIVERY_CHARGE] as! String) : " "
                dictionaryDelivery[JSONKey.DELIVERY_AREA_SHIPPING_CHARGE] = (area[JSONKey.DELIVERY_AREA_SHIPPING_CHARGE] as? String != nil) ? (area[JSONKey.DELIVERY_AREA_SHIPPING_CHARGE] as! String) : " "
                dictionaryDelivery[JSONKey.DELIVERY_AREA_DELIVERY_TIME] = (area[JSONKey.DELIVERY_AREA_DELIVERY_TIME] as? String != nil) ? (area[JSONKey.DELIVERY_AREA_DELIVERY_TIME] as! String) : " "
                
                if !dictionaryDelivery.isEmpty {
                    
                    self.arrayDeliveryList.append(dictionaryDelivery)
                }
            }
            //                }
        }else {
            
            if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil  {
                
                self.labelNoDeliveryArea.text = (jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
            }
        }
        //        }
        
        if self.arrayDeliveryList.count > 0 {
            
            self.labelNoDeliveryArea.isHidden = true
            self.tableView.reloadData()
        }else {
            
            self.labelNoDeliveryArea.isHidden = false
        }
    }
}
