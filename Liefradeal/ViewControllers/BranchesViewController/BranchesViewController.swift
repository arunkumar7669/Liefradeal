//
//  BranchesViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 02/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import MBProgressHUD

class BranchesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, OpenBranchLocationMapDelegate, SelectBranchLocationMapDelegate {
    
    func openAppleMapWith(_ indexPath: IndexPath) {
        
        let dictionary = self.arrayBranchList[indexPath.row]
        if (Double(dictionary[JSONKey.BRANCH_LATITUDE]!) == nil) || (Double(dictionary[JSONKey.BRANCH_LONGITUDE]!) == nil) {
            
            self.showToastWithMessage(self.view, ConstantStrings.NO_CORDINATES_AVAILABLE)
        }else {
            
            let coordinate = CLLocationCoordinate2DMake(Double(dictionary[JSONKey.BRANCH_LATITUDE]!)!, Double(dictionary[JSONKey.BRANCH_LONGITUDE]!)!)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = dictionary[JSONKey.BRANCH_RESTAURANT_NAME]
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonGoToMenu: UIButton!
    @IBOutlet weak var labelNoBranches: UILabel!
    var isMovedFromCartPage = Bool()
    var restaurantInfo = RestaurantInfo()
    var arrayBranchList = Array<Dictionary<String, String>>()
    var selectedBranch : Int = -1
    var isOrderTypeDelivery = Bool()
    var placeOrderUrl = String()
    var orderTypeString = String()
    var totalAmount = String()
    var orderType = Int()
    var selectedAddressID = String()
    var selectedBranchID = String()
    
    let SELECTED_BRANCH_ID = "SELECTED_BRANCH_ID"
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["Branches"] as? String != nil) ? (self.appDelegate.languageData["Branches"] as! String).trim() : "Branches"
        self.labelNoBranches.text = (self.appDelegate.languageData["NO_BRANCHES_AVAILABEL"] as? String != nil) ? (self.appDelegate.languageData["NO_BRANCHES_AVAILABEL"] as! String).trim() : "No Branches available."
        
        self.setupBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        UtilityMethods.addBorderAndShadow(self.buttonGoToMenu, 1)
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) != nil {
            
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        self.labelNoBranches.isHidden = true
        self.setupTableViewDelegateAndDatasource()
        self.webApiGetRestaurantBranches()
        
        if self.isMovedFromCartPage {
            
            let buttonConfirmLocation = (self.appDelegate.languageData["Confirm_Location"] as? String != nil) ? (self.appDelegate.languageData["Confirm_Location"] as! String).trim() : "Confirm Location"
            self.buttonGoToMenu.setTitle(buttonConfirmLocation, for: .normal)
        }else {
            
            self.buttonGoToMenu.setTitle(ConstantStrings.GO_TO_MENU, for: .normal)
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
        
        return self.arrayBranchList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isMovedFromCartPage {
            let cell = Bundle.main.loadNibNamed("SelectBranchTableViewCell", owner: self, options: nil)?.first as! SelectBranchTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.indexPath = indexPath
            let dictionary = self.arrayBranchList[indexPath.row]
            cell.labelLocationName.text = dictionary[JSONKey.BRANCH_RESTAURANT_NAME]
            cell.labelAddress.text = dictionary[JSONKey.BRANCH_ADDRESS]
            cell.labelEmail.text = dictionary[JSONKey.BRANCH_EMAIL]
            cell.labelPhone.text = dictionary[JSONKey.BRANCH_NUMBER]
            
            if self.selectedBranch == indexPath.row {
                cell.imageViewSelect.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
            }else {
                cell.imageViewSelect.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
            }
            
            return cell
        }else {
            
            let cell = Bundle.main.loadNibNamed("BranchesTableViewCell", owner: self, options: nil)?.first as! BranchesTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.indexPath = indexPath
            
            let dictionary = self.arrayBranchList[indexPath.row]
            cell.labelLocationName.text = dictionary[JSONKey.BRANCH_RESTAURANT_NAME]
            cell.labelAddress.text = dictionary[JSONKey.BRANCH_ADDRESS]
            cell.labelEmail.text = dictionary[JSONKey.BRANCH_EMAIL]
            cell.labelPhone.text = dictionary[JSONKey.BRANCH_NUMBER]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isMovedFromCartPage {
            
            let dictionary = self.arrayBranchList[indexPath.row]
            self.selectedBranchID = dictionary[JSONKey.BRANCH_ID]!
            self.selectedBranch = indexPath.row
            self.tableView.reloadData()
        }
    }
    
    //    MARK:- Button Action
    @IBAction func buttonGoToMenuAction(_ sender: UIButton) {
        
        if self.isMovedFromCartPage {
            
            if self.selectedBranch == -1 {
                
                self.showToastWithMessage(self.view, ConstantStrings.PLEASE_SELECT_RESTAURANT_BRANCH)
            }else {
                
                self.placeOrderUrl = self.placeOrderUrl.replacingOccurrences(of: self.SELECTED_BRANCH_ID, with: self.selectedBranchID)
                if self.isOrderTypeDelivery {
                    
                    let addressVC = AddressViewController.init(nibName: "AddressViewController", bundle: nil)
                    addressVC.isAddressSelectable = true
                    addressVC.orderType = self.orderType
                    addressVC.orderTypeString = self.orderTypeString
                    addressVC.placeOrderUrlString = self.placeOrderUrl
                    addressVC.totalAmount = self.totalAmount
                    self.navigationController?.pushViewController(addressVC, animated: true)
                }else {
                    
                    let paymentVC = PaymentViewController.init(nibName: "PaymentViewController", bundle: nil)
                    paymentVC.orderTypeString = self.orderTypeString
                    paymentVC.orderType = self.orderType
                    paymentVC.selectedAddressID = self.selectedAddressID
                    paymentVC.placeOrderUrlString = self.placeOrderUrl
                    paymentVC.totalAmount = self.totalAmount
                    self.navigationController?.pushViewController(paymentVC, animated: true)
                }
            }
        }else {
            
            self.moveOnMenuPage()
        }
    }
    
    //    MARK:- Web Api Code Start
//    Api for get branches
    func webApiGetRestaurantBranches() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_get_restaurant_branch_list.php?lang_code=\(WebApi.LANGUAGE_CODE)&api_key=\(WebApi.API_KEY)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupRestaurantBranchesList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    func setup branches list
    func setupRestaurantBranchesList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
//        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
        
//            if jsonDictionary[JSONKey.ERROR_CODE] as! Int == 0 {
        
                if jsonDictionary[JSONKey.BRANCH_LIST] as? Array<Dictionary<String, Any>> != nil {
                    
                    let arrayBranch = jsonDictionary[JSONKey.BRANCH_LIST] as! Array<Dictionary<String, Any>>
                    
                    for branch in arrayBranch {
                        
                        var dictionaryBranch = Dictionary<String, String>()
                        dictionaryBranch[JSONKey.BRANCH_ID] = (branch[JSONKey.BRANCH_ID] as? Int != nil) ? String(branch[JSONKey.BRANCH_ID] as! Int) : "0"
                        dictionaryBranch[JSONKey.BRANCH_NUMBER] = (branch[JSONKey.BRANCH_NUMBER] as? String != nil) ? (branch[JSONKey.BRANCH_NUMBER] as! String) : " "
                        dictionaryBranch[JSONKey.BRANCH_ADDRESS] = (branch[JSONKey.BRANCH_ADDRESS] as? String != nil) ? (branch[JSONKey.BRANCH_ADDRESS] as! String) : " "
                        dictionaryBranch[JSONKey.BRANCH_POSTAL_CODE] = (branch[JSONKey.BRANCH_POSTAL_CODE] as? String != nil) ? (branch[JSONKey.BRANCH_POSTAL_CODE] as! String) : " "
                        dictionaryBranch[JSONKey.BRANCH_LATITUDE] = (branch[JSONKey.BRANCH_LATITUDE] as? String != nil) ? (branch[JSONKey.BRANCH_LATITUDE] as! String) : " "
                        dictionaryBranch[JSONKey.BRANCH_LONGITUDE] = (branch[JSONKey.BRANCH_LONGITUDE] as? String != nil) ? (branch[JSONKey.BRANCH_LONGITUDE] as! String) : " "
                        dictionaryBranch[JSONKey.BRANCH_DELIVERY_DISTANCE] = (branch[JSONKey.BRANCH_DELIVERY_DISTANCE] as? String != nil) ? (branch[JSONKey.BRANCH_DELIVERY_DISTANCE] as! String) : " "
                        dictionaryBranch[JSONKey.BRANCH_RESTAURANT_NAME] = (branch[JSONKey.BRANCH_RESTAURANT_NAME] as? String != nil) ? (branch[JSONKey.BRANCH_RESTAURANT_NAME] as! String) : " "
                        dictionaryBranch[JSONKey.BRANCH_EMAIL] = (branch[JSONKey.BRANCH_EMAIL] as? String != nil) ? (branch[JSONKey.BRANCH_EMAIL] as! String) : "-"
                        
                        if !dictionaryBranch.isEmpty {
                            
                            self.arrayBranchList.append(dictionaryBranch)
                        }
                    }
//                }
            }else {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil  {
                    
                    self.labelNoBranches.text = (jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }
//        }
        
        if self.arrayBranchList.count > 0 {
            
            self.labelNoBranches.isHidden = true
            self.tableView.reloadData()
        }else {
            self.labelNoBranches.text = (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil) ? (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String) : self.labelNoBranches.text!
            self.labelNoBranches.isHidden = false
        }
    }
}
