//
//  OpeningHoursViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 04/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class OpeningHoursViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightContentView: NSLayoutConstraint!
    @IBOutlet weak var buttonGotoMenu: UIButton!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelSpecialOpening: UILabel!
    @IBOutlet weak var viewSpecialHours: UIView!
    
    var arrayOpeningHours = Array<Dictionary<String, String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        let height = self.tableView.contentSize.height
        self.heightContentView.constant = height
        self.view.layoutIfNeeded()
        UtilityMethods.addBorderAndShadow(self.viewContent, 5.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST)
        self.setupCartButtonWithBadge(arrayCartItems.count)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Opening_Hours"] as? String != nil) ? (self.appDelegate.languageData["Opening_Hours"] as! String).trim() : "Opening Hours"
        self.labelSpecialOpening.text = (self.appDelegate.languageData["SPECIAL_OPENING_HOURS"] as? String != nil) ? (self.appDelegate.languageData["SPECIAL_OPENING_HOURS"] as! String).trim() : "Specials Opening hours"
//        self.labelClosed.text = (self.appDelegate.languageData["CLOSED"] as? String != nil) ? (self.appDelegate.languageData["CLOSED"] as! String).trim() : "Closed"
        self.setupBackBarButton()
        UtilityMethods.addBorderAndShadow(self.viewContent, 5.0)
        self.buttonGotoMenu.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewContent.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        self.buttonGotoMenu.setTitle(ConstantStrings.GO_TO_MENU, for: .normal)
        self.setupTableViewDelegateAndDatasource()
        self.webApiGetOpeningHours()
        
        self.labelDate.isHidden = true
        self.labelStatus.isHidden = true
        self.labelSpecialOpening.isHidden = true
        self.viewSpecialHours.isHidden = true
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
        
        return self.arrayOpeningHours.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("OpeningHoursTableViewCell", owner: self, options: nil)?.first as! OpeningHoursTableViewCell
        cell.selectionStyle = .none
        
        let dictionary = self.arrayOpeningHours[indexPath.row]
        print(dictionary)
        
        cell.labelDay.text = dictionary["day"]
        cell.labelTime.text = dictionary["time"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    //    MARK:- Button Action
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
        self.moveOnMenuPage()
    }
    
//    MARK:- Web Api Code Start
//    Get opening hours
    func webApiGetOpeningHours() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_restaurant_opening_hours.php?lang_code=\(WebApi.LANGUAGE_CODE)&api_key=\(WebApi.API_KEY)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupOpeningHours(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Func Setup Opening hours
    func setupOpeningHours(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.SUCCESS_CODE] as? String != nil {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as! String == "0" {
                
                let mondayText = (jsonDictionary["MondayText"] as? String != nil) ? (jsonDictionary["MondayText"] as! String) : "-"
                let tuesdayText = (jsonDictionary["MondayText"] as? String != nil) ? (jsonDictionary["MondayText"] as! String) : "-"
                let wednesDayText = (jsonDictionary["MondayText"] as? String != nil) ? (jsonDictionary["MondayText"] as! String) : "-"
                let thursdayText = (jsonDictionary["MondayText"] as? String != nil) ? (jsonDictionary["MondayText"] as! String) : "-"
                let fridayText = (jsonDictionary["MondayText"] as? String != nil) ? (jsonDictionary["MondayText"] as! String) : "-"
                let saturdayText = (jsonDictionary["MondayText"] as? String != nil) ? (jsonDictionary["MondayText"] as! String) : "-"
                let sundayText = (jsonDictionary["MondayText"] as? String != nil) ? (jsonDictionary["MondayText"] as! String) : "-"
                
                 let monday = (self.appDelegate.languageData["Monday"] as? String != nil) ? (self.appDelegate.languageData["Monday"] as! String).trim() : "Monday"
                let tuesday = (self.appDelegate.languageData["Tuesday"] as? String != nil) ? (self.appDelegate.languageData["Tuesday"] as! String).trim() : "Tuesday"
                let wednesday = (self.appDelegate.languageData["Wednesday"] as? String != nil) ? (self.appDelegate.languageData["Wednesday"] as! String).trim() : "Wednesday"
                let thursday = (self.appDelegate.languageData["Thursday"] as? String != nil) ? (self.appDelegate.languageData["Thursday"] as! String).trim() : "Thursday"
                let friday = (self.appDelegate.languageData["Friday"] as? String != nil) ? (self.appDelegate.languageData["Friday"] as! String).trim() : "Friday"
                let saturday = (self.appDelegate.languageData["Saturday"] as? String != nil) ? (self.appDelegate.languageData["Saturday"] as! String).trim() : "Saturday"
                let sunday = (self.appDelegate.languageData["Sunday"] as? String != nil) ? (self.appDelegate.languageData["Sunday"] as! String).trim() : "Sunday"
                arrayOpeningHours = [["day" : monday, "time" : mondayText],
                                     ["day" : tuesday, "time" : tuesdayText],
                                     ["day" : wednesday, "time" : wednesDayText],
                                     ["day" : thursday, "time" : thursdayText],
                                     ["day" : friday, "time" : fridayText],
                                     ["day" : saturday, "time" : saturdayText],
                                     ["day" : sunday, "time" : sundayText]]
                self.tableView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    self.view.setNeedsLayout()
                }
            }else {
                
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    
                    self.showToastWithMessage(self.view, (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String))
                }
            }
        }else {
            
            if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                
                self.showToastWithMessage(self.view, (jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String))
            }
        }
    }
}


//phpexpert_restaurant_opening_hours.php?api_key=food&lang_code=en
