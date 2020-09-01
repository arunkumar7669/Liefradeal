//
//  BookTableViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 09/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import RPFloatingPlaceholders

protocol TableBookedDelegate : class {
    
    func showMessageBookedTable(_ message : String)
}

class BookTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var textFieldCustomerName: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldMobileNumber: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldBookingDate: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldBookingTime: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldInstructions: RPFloatingPlaceholderTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var labelPersonCount: UILabel!
    @IBOutlet weak var heightSelectPerson: NSLayoutConstraint!
    @IBOutlet weak var imageViewUpArrow: UIImageView!
    @IBOutlet weak var imageViewDownArrow: UIImageView!
    @IBOutlet weak var buttonUpArrow: UIButton!
    @IBOutlet weak var buttonDownArrow: UIButton!
    @IBOutlet weak var labelSelectPerson: UILabel!
    @IBOutlet weak var imageViewPerson: UIImageView!
    @IBOutlet weak var viewSelectPersonBottom: UIView!
    @IBOutlet weak var viewPersonNumber: UIView!
    @IBOutlet weak var labelChooseTable: UILabel!
    
    var isSelectedTableView = Bool()
    var selectedTablePersonLimit = Int()
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    var userDetails = UserDetails()
    var selectedTableID = String()
    var selectedTableName = String()
    var selectedTableNumber = String()
    var selectedTableIndex : Int = -1
    weak var delegate : TableBookedDelegate?
    var arrayTableDetailsList = Array<Dictionary<String, String>>()
    var tableDetails = Dictionary<String, String>()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !self.isSelectedTableView {
            
            let height = self.tableView.contentSize.height
            self.heightTableView.constant = height
        }
        self.view.layoutIfNeeded()
    }
    
//    Func setup viewDidLoadMethod
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Book_a_Table"] as? String != nil) ? (self.appDelegate.languageData["Book_a_Table"] as! String).trim() : "Book a Table"
        
        self.textFieldCustomerName.placeholder = (self.appDelegate.languageData["Customer_Name"] as? String != nil) ? (self.appDelegate.languageData["Customer_Name"] as! String).trim() : "Customer Name"
        self.textFieldMobileNumber.placeholder = (self.appDelegate.languageData["Mobile_Number"] as? String != nil) ? (self.appDelegate.languageData["Mobile_Number"] as! String).trim() : "Mobile No."
        self.textFieldBookingDate.placeholder = (self.appDelegate.languageData["Booking_Date"] as? String != nil) ? (self.appDelegate.languageData["Booking_Date"] as! String).trim() : "Booking Date"
        self.textFieldBookingTime.placeholder = (self.appDelegate.languageData["Booking_Time"] as? String != nil) ? (self.appDelegate.languageData["Booking_Time"] as! String).trim() : "Booking Time"
        self.labelChooseTable.text = (self.appDelegate.languageData["Choose_Table"] as? String != nil) ? (self.appDelegate.languageData["Choose_Table"] as! String).trim() : "Choose Table"
        self.textFieldInstructions.placeholder = (self.appDelegate.languageData["Special_Instructions"] as? String != nil) ? (self.appDelegate.languageData["Special_Instructions"] as! String).trim() : "Special Instructions"
        self.labelPersonCount.text = (self.appDelegate.languageData["No_of_Person"] as? String != nil) ? (self.appDelegate.languageData["No_of_Person"] as! String).trim() : "No. Of Person"
        let buttonSubmit = (self.appDelegate.languageData["Submit"] as? String != nil) ? (self.appDelegate.languageData["Submit"] as! String).trim() : "Submit"
        self.buttonSubmit.setTitle(buttonSubmit, for: .normal)
        
        self.showDatePicker()
        self.showTimePicker()
        self.setupBackBarButton()
        self.webApiGetTableDetailsList()
        self.setupTableViewDelegateAndDatasource()
        UtilityMethods.addBorderAndShadow(self.buttonSubmit, self.buttonSubmit.bounds.height / 2)
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        self.textFieldCustomerName.text = self.userDetails.userName
        self.textFieldMobileNumber.text = self.userDetails.userPhone
        self.hideSelectPersonView()
    }
    
    //    Setup tableView Delegate And datasource
    func setupTableViewDelegateAndDatasource() -> Void {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 40
    }
    
    //    MARK:- UITableView Delegate and Datasource method
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayTableDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("SelectTableTableViewCell", owner: self, options: nil)?.first as! SelectTableTableViewCell
        cell.selectionStyle = .none
        
        if indexPath.row == self.selectedTableIndex {
            cell.imageViewSelect.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
        }else {
            cell.imageViewSelect.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
        }
        
        let dictionary = self.arrayTableDetailsList[indexPath.row]
        var imageUrl = dictionary[JSONKey.TABLE_IMAGE_ICON]!
        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
        cell.imageViewTable.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "table"))
        cell.labelUserCount.text = dictionary[JSONKey.TABLE_PEOPLE_NUMBER]
        cell.labelTableCount.text = dictionary[JSONKey.TABLE_NUMBER]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dictionaryTable = self.arrayTableDetailsList[indexPath.row]
        if dictionaryTable[JSONKey.TABLE_IS_AVAILABLE] == ConstantStrings.FALSE_STRING {
            
            var stringMessage = (self.appDelegate.languageData["TABLE_NUMBER_HAS_BEEN_BOOKED"] as? String != nil) ? (self.appDelegate.languageData["TABLE_NUMBER_HAS_BEEN_BOOKED"] as! String).trim() : "Table no $ has been already booked. So please choose another table."
            stringMessage = stringMessage.replacingOccurrences(of: "$", with: "\(dictionaryTable[JSONKey.TABLE_PEOPLE_NUMBER]!)")
            self.showToastWithMessage(self.view, stringMessage)
        }else {
            self.tableDetails = self.arrayTableDetailsList[indexPath.row]
            self.selectedTableIndex = indexPath.row
            self.selectedTableID = dictionaryTable[JSONKey.TABLE_ID]!
            self.selectedTableName = dictionaryTable[JSONKey.TABLE_NAME]!
            self.selectedTableNumber = dictionaryTable[JSONKey.TABLE_NUMBER]!
            self.selectedTablePersonLimit = Int(dictionaryTable[JSONKey.TABLE_PEOPLE_NUMBER]!)!
            self.labelPersonCount.text = "\(self.selectedTablePersonLimit)"
            self.isSelectedTableView = true
            self.tableView.reloadData()
            self.showSelectPersonView()
        }
    }
    
    //    Show date picker
    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(selectDate(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: ConstantStrings.CANCEL_STRING, style: UIBarButtonItem.Style.done, target: self, action: #selector(removeDatePicker(_:)))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        self.textFieldBookingDate.inputAccessoryView = toolbar
        // add datepicker to textField
        self.textFieldBookingDate.inputView = datePicker
        
    }
    
    @objc func selectDate(_ sender : Any){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        self.textFieldBookingDate.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func removeDatePicker(_ sender : Any){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func showTimePicker(){
        //Formate Date
        self.timePicker.datePickerMode = .time
        self.timePicker.minimumDate = Date()
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(selectTime(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: ConstantStrings.CANCEL_STRING, style: UIBarButtonItem.Style.done, target: self, action: #selector(removeTimePicker(_:)))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        self.textFieldBookingTime.inputAccessoryView = toolbar
        // add datepicker to textField
        self.textFieldBookingTime.inputView = self.timePicker
        
    }
    
    @objc func selectTime(_ sender : Any){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        self.textFieldBookingTime.text = formatter.string(from: self.timePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func removeTimePicker(_ sender : Any){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    //    MARK:- Button Action
//    Button Action for submit a form
    @IBAction func buttonBookTableFormSubmitAction(_ sender: UIButton) {
        
        if self.checkValidation() {
            
//            self.webApiBookATable()
            let bookTableVC = ConfirmationTableViewController.init(nibName: "ConfirmationTableViewController", bundle: nil)
            bookTableVC.tableInformation = self.tableDetails
            bookTableVC.tableName = "\(self.selectedTableNumber)(\(self.selectedTableName))"
            bookTableVC.personCount = self.labelPersonCount.text!
            bookTableVC.bookingDate = self.textFieldBookingDate.text!
            bookTableVC.bookingTime = self.textFieldBookingTime.text!
            bookTableVC.customerName = self.textFieldCustomerName.text!
            bookTableVC.specialInstruction = self.textFieldInstructions.text!
            bookTableVC.customerContactNumber = self.textFieldMobileNumber.text!
            self.navigationController?.pushViewController(bookTableVC, animated: true)
        }
    }
    
    func checkValidation() -> Bool {
        
        self.view.endEditing(true)
        if self.textFieldCustomerName.text!.isEmpty {
            
            self.textFieldCustomerName.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.CUSTOMER_NAME_IS_REQUIRED)
            return false
        }
        
        if self.textFieldMobileNumber.text!.isEmpty {
            
            self.textFieldMobileNumber.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.CUSTOMER_MOBILE_NUMBER_IS_REQUIRED)
            return false
        }
        
        if self.textFieldBookingDate.text!.isEmpty {
            
            self.textFieldBookingDate.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.BOOKING_DATE_IS_REQUIRED)
            return false
        }
        
        if self.textFieldBookingTime.text!.isEmpty {
            
            self.textFieldBookingTime.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.BOOKING_TIME_IS_REQUIRED)
            return false
        }
        
        if self.selectedTableIndex == -1 {
            
            self.showToastWithMessage(self.view, ConstantStrings.PLEASE_SELECT_TABLE_NUMBER)
            return false
        }
        return true
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
    
//    Hide select person view
    func hideSelectPersonView() -> Void {
        
        self.heightSelectPerson.constant = 0.5
        self.viewPersonNumber.isHidden = true
        self.labelSelectPerson.isHidden = true
        self.buttonUpArrow.isHidden = true
        self.buttonDownArrow.isHidden = true
        self.imageViewUpArrow.isHidden = true
        self.imageViewDownArrow.isHidden = true
        self.imageViewPerson.isHidden = true
        self.viewSelectPersonBottom.isHidden = true
    }
    
//    Show select person view
    func showSelectPersonView() -> Void {
        
        self.heightSelectPerson.constant = 45.0
        self.viewPersonNumber.isHidden = false
        self.labelSelectPerson.isHidden = false
        self.buttonUpArrow.isHidden = false
        self.buttonDownArrow.isHidden = false
        self.imageViewUpArrow.isHidden = false
        self.imageViewDownArrow.isHidden = false
        self.imageViewPerson.isHidden = false
        self.viewSelectPersonBottom.isHidden = false
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
                dictionaryTable[JSONKey.TABLE_NUMBER] = (table[JSONKey.TABLE_NUMBER] as? String != nil) ? (table[JSONKey.TABLE_NUMBER] as! String) : " "
                dictionaryTable[JSONKey.TABLE_IMAGE_ICON] = (table[JSONKey.TABLE_IMAGE_ICON] as? String != nil) ? (table[JSONKey.TABLE_IMAGE_ICON] as! String) : " "
                dictionaryTable[JSONKey.TABLE_IS_AVAILABLE] = (table[JSONKey.TABLE_IS_AVAILABLE] as? String != nil) ? (table[JSONKey.TABLE_IS_AVAILABLE] as! String) : " "
                dictionaryTable[JSONKey.TABLE_PEOPLE_NUMBER] = (table[JSONKey.TABLE_PEOPLE_NUMBER] as? String != nil) ? (table[JSONKey.TABLE_PEOPLE_NUMBER] as! String) : " "
                dictionaryTable[JSONKey.TABLE_SERVICE_CHARGE] = (table[JSONKey.TABLE_SERVICE_CHARGE] as? Int != nil) ? String(table[JSONKey.TABLE_SERVICE_CHARGE] as! Int) : "0"
                dictionaryTable[JSONKey.TABLE_CHARGE_PER_PERSON] = (table[JSONKey.TABLE_CHARGE_PER_PERSON] as? String != nil) ? (table[JSONKey.TABLE_CHARGE_PER_PERSON] as! String) : "0"
                dictionaryTable[JSONKey.TABLE_DISCOUNT_PERCENTAGE] = (table[JSONKey.TABLE_DISCOUNT_PERCENTAGE] as? Int != nil) ? String(table[JSONKey.TABLE_DISCOUNT_PERCENTAGE] as! Int) : "0"
                dictionaryTable[JSONKey.TABLE_MINIMUM_DIPOSIT_PERCENTAGE] = (table[JSONKey.TABLE_MINIMUM_DIPOSIT_PERCENTAGE] as? String != nil) ? (table[JSONKey.TABLE_MINIMUM_DIPOSIT_PERCENTAGE] as! String) : "0"
                dictionaryTable[JSONKey.TABLE_DISCOUNT_AVAILABLE_DAYS] = (table[JSONKey.TABLE_DISCOUNT_AVAILABLE_DAYS] as? String != nil) ? (table[JSONKey.TABLE_DISCOUNT_AVAILABLE_DAYS] as! String) : ""
                
                print(Date().dayOfWeek()!)
                let dayAvailableOffer = dictionaryTable[JSONKey.TABLE_DISCOUNT_AVAILABLE_DAYS]!.lowercased()
                let currentDay = Date().dayOfWeek()!.lowercased()
                if dayAvailableOffer.range(of: currentDay) == nil {
                    dictionaryTable[JSONKey.TABLE_DISCOUNT_PERCENTAGE] = "0"
                }
                if !dictionaryTable.isEmpty {
                    self.arrayTableDetailsList.append(dictionaryTable)
                }
            }
        }else {
            
            if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil  {
                self.showToastWithMessage(self.view, (jsonDictionary[JSONKey.ERROR_MESSAGE] as! String))
            }
        }
        if self.arrayTableDetailsList.count > 0 {
            self.tableView.reloadData()
        }else {
            self.showToastWithMessage(self.view, (jsonDictionary[JSONKey.ERROR_MESSAGE] as! String))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            self.view.setNeedsLayout()
        }
    }
    
//    Web Api Book Table
    func webApiBookATable() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_table_booking.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&CustomerId=\(self.userDetails.userID)&table_number_assign=\(selectedTableID)&booking_mobile=\(self.textFieldMobileNumber.text!)&booking_date=\(self.textFieldBookingDate.text!)&booking_time=\(self.textFieldBookingTime.text!)&booking_instruction=\(self.textFieldInstructions.text!)"
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
                    
                    self.delegate?.showMessageBookedTable((jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String))
                    self.navigationController?.popViewController(animated: true)
                }
            }else {
                
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    
                    self.showToastWithMessage(self.view, (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String))
                }
            }
        }
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}

//["table_name": Super,
//"tabl_per_person_charge": 100,
//"table_discount_amount": ,
//"minimum_deposit_percentage": 10,
//"table_icon_img": https://www.dmd.foodsdemo.com/OPCPnl/directoryImage/restaurantImg/table_4.png,
//"discount_available_days": , "error": 0,
//"table_number": 1003,
//"available_for_book": Yes,
//"table_service_charge_amount": ,
//"number_of_people": 4,
//"id": 3]


//["id": 3, "error": 0, "discount_available_days": Sunday,Monday,Tuesday,Wednesday,Saturday, "table_discount_amount": 50, "minimum_deposit_percentage": 10, "table_service_charge_amount": 10, "table_number": 1003, "tabl_per_person_charge": 100, "table_name": Super, "available_for_book": Yes, "table_icon_img": https://www.dmd.foodsdemo.com/OPCPnl/directoryImage/restaurantImg/table_4.png, "number_of_people": 4]
