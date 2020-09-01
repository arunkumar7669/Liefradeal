//
//  SelectTableViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 02/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

protocol BookTableDelegate : class {
    func bookSelectedTable(_ tableID : String)
}

class SelectTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBookNow: UIButton!
    @IBOutlet weak var lableNoTable: UILabel!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var labelRestaurantLocation: UILabel!
    @IBOutlet weak var labelCurrentlyLocation: UILabel!
    @IBOutlet weak var labelPersonCount: UILabel!
    @IBOutlet weak var labelNoOfPerson: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isMovedFromCart = Bool()
    var tableRandomNumber = String()
    var selectedTableID = String()
    var selectedTableIndex : Int = -1
    var selectedTablePersonLimit = Int()
    weak var delegate : BookTableDelegate?
    var datasource = Array<Dictionary<String, String>>()
    var arrayTableDetailsList = Array<Dictionary<String, String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Choose_Table"] as? String != nil) ? (self.appDelegate.languageData["Choose_Table"] as! String).trim() : "Choose Table"
        self.lableNoTable.text = (self.appDelegate.languageData["NO_SITTING_AVAILABLE"] as? String != nil) ? (self.appDelegate.languageData["NO_SITTING_AVAILABLE"] as! String).trim() : "No sitting Table available."
        self.labelCurrentlyLocation.text = (self.appDelegate.languageData["YOU_ARE_CURRENTLY_HERE"] as? String != nil) ? (self.appDelegate.languageData["YOU_ARE_CURRENTLY_HERE"] as! String).trim() : "You are currently in this restaurant"
        self.labelNoOfPerson.text = (self.appDelegate.languageData["No_of_Person"] as? String != nil) ? (self.appDelegate.languageData["No_of_Person"] as! String).trim() : "No. Of Person"
        let buttonBookNowTitle = (self.appDelegate.languageData["Book_Now"] as? String != nil) ? (self.appDelegate.languageData["Book_Now"] as! String).trim() : "Book Now"
        self.buttonBookNow.setTitle(buttonBookNowTitle, for: .normal)
        self.searchBar.placeholder =  (self.appDelegate.languageData["Search_Table_Number"] as? String != nil) ? (self.appDelegate.languageData["Search_Table_Number"] as! String).trim() : "Search Table Number"
        
        self.setupBackBarButton()
        self.setupTableViewDelegateAndDatasource()
        self.lableNoTable.isHidden = true
        self.webApiGetTableDetailsList()
        self.setupKeyboardButton()
        
        let branchDetails = UserDefaultOperations.getDictionaryObject(ConstantStrings.SELECTED_EAT_IN_BRANCH) as! Dictionary<String, String>
        self.labelRestaurantName.text = branchDetails[JSONKey.BRANCH_RESTAURANT_NAME]!
        self.labelRestaurantLocation.text = branchDetails[JSONKey.BRANCH_ADDRESS]!
    }
    
//    Setup button on search keyboard for hide the keyboard
    func setupKeyboardButton() -> Void {
        self.searchBar.delegate = self
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"down_arrow"), for: .normal)
        menuBtn.addTarget(self, action: #selector(removeSearchKeyboard(_:)), for: UIControl.Event.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: menuBtn)
        toolbar.setItems([cancelButton], animated: false)
        self.searchBar.inputAccessoryView = toolbar
    }
    
    @objc func removeSearchKeyboard(_ sender : Any){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.datasource = self.arrayTableDetailsList.filter {
            return (($0["table_number"]!).lowercased().contains(searchText.lowercased()))
        }
        if searchText.isEmpty {
            self.datasource = self.arrayTableDetailsList
        }
        if datasource.count == 0 {
            self.lableNoTable.isHidden = false
        }else {
            self.lableNoTable.isHidden = true
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func setupTableViewDelegateAndDatasource() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 40.0
    }
    
    //    MARK:- UITableView Delegate and Datasource method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("SelectTableTableViewCell", owner: self, options: nil)?.first as! SelectTableTableViewCell
        cell.selectionStyle = .none
        
        if indexPath.row == self.selectedTableIndex {
            cell.imageViewSelect.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
        }else {
            cell.imageViewSelect.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
        }
        
        let dictionary = self.datasource[indexPath.row]
        var imageUrl = dictionary[JSONKey.TABLE_IMAGE_ICON]!
        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
        cell.imageViewTable.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "table"))
        cell.labelUserCount.text = dictionary[JSONKey.TABLE_PEOPLE_NUMBER]
        cell.labelTableCount.text = dictionary[JSONKey.TABLE_NUMBER]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedTableIndex = indexPath.row
        let dictionaryTable = self.datasource[self.selectedTableIndex]
        self.selectedTableID = dictionaryTable[JSONKey.TABLE_ID]!
        self.selectedTablePersonLimit = Int(dictionaryTable[JSONKey.TABLE_PEOPLE_NUMBER]!)!
        self.labelPersonCount.text = "\(self.selectedTablePersonLimit)"
        self.tableView.reloadData()
    }
    
    //    MARK:- Button Action
//    Button Action for Table Book Now
    @IBAction func buttonTableBookNowAction(_ sender: UIButton) {
        
        if self.datasource.count == 0 {
            self.showToastWithMessage(self.view, self.lableNoTable.text!)
            return
        }
        if self.selectedTableIndex >= 0 {
            UserDefaultOperations.setStringObject(ConstantStrings.TABLE_PERSON_COUNT, self.labelPersonCount.text!)
            if self.tableRandomNumber.isEmpty {
                self.delegate?.bookSelectedTable(self.selectedTableID)
                self.navigationController?.popViewController(animated: true)
            }else {
                if self.isMovedFromCart {
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: CartViewController.self) {
                            let cartVC = controller as! CartViewController
                            cartVC.bookSelectedTable(self.selectedTableID)
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }else {
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: MenuViewController.self) {
                            let menuVC = controller as! MenuViewController
                            menuVC.bookSelectedTable(self.selectedTableID)
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }
        }else {
            let messageString =  (self.appDelegate.languageData["please_select_table"] as? String != nil) ? (self.appDelegate.languageData["please_select_table"] as! String).trim() : "Please select table."
            self.showToastWithMessage(self.view, messageString)
        }
    }
    
//    Button Count action
    @IBAction func buttonAddPersonAction(_ sender: UIButton) {
        
        if self.selectedTablePersonLimit <= Int(self.labelPersonCount.text!)! {
            let notSelectMoreThanLimit = (self.appDelegate.languageData["YOU_CAN_NOT_SELECT_MORE_THAN_TABLE_LIMIT"] as? String != nil) ? (self.appDelegate.languageData["YOU_CAN_NOT_SELECT_MORE_THAN_TABLE_LIMIT"] as! String).trim() : "You can not select person more than table limit."
            self.showToastWithMessage(self.view, notSelectMoreThanLimit)
        }else {
            
            var personCount = Int(self.labelPersonCount.text!)!
            personCount += 1
            self.labelPersonCount.text = "\(personCount)"
        }
    }
    
    @IBAction func buttonMinusPersonAction(_ sender: UIButton) {
        
        var personCount = Int(self.labelPersonCount.text!)!
        if personCount <= 1 {
            let notSelectLessThanLimit = (self.appDelegate.languageData["YOU_CAN_NOT_SELECT_LESS_PERSON"] as? String != nil) ? (self.appDelegate.languageData["YOU_CAN_NOT_SELECT_LESS_PERSON"] as! String).trim() : "You can not select less than 1 person."
            self.showToastWithMessage(self.view, notSelectLessThanLimit)
        }else {
            
            personCount -= 1
            self.labelPersonCount.text = "\(personCount)"
        }
    }
    
    //    MARK:- Web Api Code Start
//    Get Table list
    func webApiGetTableDetailsList() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_table_list.php?lang_code=\(WebApi.LANGUAGE_CODE)&api_key=\(WebApi.API_KEY)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupTableDetailsList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    func setup table list
    func setupTableDetailsList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.TABLE_LIST] as? Array<Dictionary<String, Any>> != nil {
            let arrayTableDetails = jsonDictionary[JSONKey.TABLE_LIST] as! Array<Dictionary<String, Any>>
            for table in arrayTableDetails {
                
                var dictionaryTable = Dictionary<String, String>()
                dictionaryTable[JSONKey.TABLE_ID] = (table[JSONKey.TABLE_ID] as? Int != nil) ? String(table[JSONKey.TABLE_ID] as! Int) : "0"
                dictionaryTable[JSONKey.TABLE_NAME] = (table[JSONKey.TABLE_NAME] as? String != nil) ? (table[JSONKey.TABLE_NAME] as! String) : " "
                dictionaryTable[JSONKey.TABLE_NUMBER] = (table[JSONKey.TABLE_NUMBER] as? String != nil) ? (table[JSONKey.TABLE_NUMBER] as! String) : "0"
                dictionaryTable[JSONKey.TABLE_IMAGE_ICON] = (table[JSONKey.TABLE_IMAGE_ICON] as? String != nil) ? (table[JSONKey.TABLE_IMAGE_ICON] as! String) : " "
                dictionaryTable[JSONKey.TABLE_IS_AVAILABLE] = (table[JSONKey.TABLE_IS_AVAILABLE] as? String != nil) ? (table[JSONKey.TABLE_IS_AVAILABLE] as! String) : " "
                dictionaryTable[JSONKey.TABLE_PEOPLE_NUMBER] = (table[JSONKey.TABLE_PEOPLE_NUMBER] as? String != nil) ? (table[JSONKey.TABLE_PEOPLE_NUMBER] as! String) : "0"
                dictionaryTable[JSONKey.TABLE_BOOK_RANDOM_NUMBER] = (table[JSONKey.TABLE_BOOK_RANDOM_NUMBER] as? String != nil) ? (table[JSONKey.TABLE_BOOK_RANDOM_NUMBER] as! String) : "0"
                
                if !dictionaryTable.isEmpty {
                    self.arrayTableDetailsList.append(dictionaryTable)
                }
            }
        }else {
            if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil  {
                self.lableNoTable.text = (jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
            }
        }
        if !self.tableRandomNumber.isEmpty {
            for i in 0..<self.arrayTableDetailsList.count {
                let tableInfo = self.arrayTableDetailsList[i]
                if tableInfo[JSONKey.TABLE_BOOK_RANDOM_NUMBER] == self.tableRandomNumber {
                    self.selectedTableIndex = i
                    self.selectedTableID = tableInfo[JSONKey.TABLE_ID]!
                    self.selectedTablePersonLimit = Int(tableInfo[JSONKey.TABLE_PEOPLE_NUMBER]!)!
                    self.labelPersonCount.text = "\(self.selectedTablePersonLimit)"
                    break
                }
            }
        }
        self.datasource = self.arrayTableDetailsList
        if self.arrayTableDetailsList.count > 0 {
            self.lableNoTable.isHidden = true
            self.tableView.reloadData()
        }else {
            self.lableNoTable.isHidden = false
        }
    }
}
