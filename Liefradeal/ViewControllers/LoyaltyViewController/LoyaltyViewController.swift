//
//  LoyaltyViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 02/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class LoyaltyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var pointString = String()
    var arrayLoyaltyList = Array<Dictionary<String, String>>()
    var arrayLoyaltyPointList = Array<Dictionary<String, String>>()
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["Loyalty_Points"] as? String != nil) ? (self.appDelegate.languageData["Loyalty_Points"] as! String).trim() : "Loyalty Points"
        
        self.setupBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.setupTableViewDelegateAndDatasource()
        
        self.pointString = (self.appDelegate.languageData["points"] as? String != nil) ? (self.appDelegate.languageData["points"] as! String).trim() : "Points"
        let signupTitle = (self.appDelegate.languageData["Free_Sign_Up"] as? String != nil) ? (self.appDelegate.languageData["Free_Sign_Up"] as! String).trim() : "Free Sign Up"
        let signupDescription = (self.appDelegate.languageData["Free_sign_up_with_Harpers_get"] as? String != nil) ? (self.appDelegate.languageData["Free_sign_up_with_Harpers_get"] as! String).trim() : "Free sign up with us to get"
        let placeFirstOrderTitle = (self.appDelegate.languageData["Place_first_orders"] as? String != nil) ? (self.appDelegate.languageData["Place_first_orders"] as! String).trim() : "Place first order"
        let placeFirstOrderDescription = (self.appDelegate.languageData["Place_first_orders_from_Harpers_get"] as? String != nil) ? (self.appDelegate.languageData["Place_first_orders_from_Harpers_get"] as! String).trim() : "Place first order from us to get"
        let postReviewTitle = (self.appDelegate.languageData["Posting_a_review"] as? String != nil) ? (self.appDelegate.languageData["Posting_a_review"] as! String).trim() : "Posting a review"
        let postReviewDescription = (self.appDelegate.languageData["Posting_a_review_get"] as? String != nil) ? (self.appDelegate.languageData["Posting_a_review_get"] as! String).trim() : "Posting a review to get"
        let groupOrderingTitle = (self.appDelegate.languageData["Group_Ordering"] as? String != nil) ? (self.appDelegate.languageData["Group_Ordering"] as! String).trim() : "Group Ordering"
        let groupOrderingDescription = (self.appDelegate.languageData["Place_grouping_ordering_get"] as? String != nil) ? (self.appDelegate.languageData["Place_grouping_ordering_get"] as! String).trim() : "Place grouping ordering to get"
        let celebrationTitle = (self.appDelegate.languageData["Birthday_Celebrations"] as? String != nil) ? (self.appDelegate.languageData["Birthday_Celebrations"] as! String).trim() : "Birthday Celebrations"
        let celebrationDescription = (self.appDelegate.languageData["Birthday_Celebrations_and_place_orders_from_Harpers_get"] as? String != nil) ? (self.appDelegate.languageData["Birthday_Celebrations_and_place_orders_from_Harpers_get"] as! String).trim() : "Birthday Celebration and place orders from us to get"
        let socialSharingTitle = (self.appDelegate.languageData["Social_Sharing"] as? String != nil) ? (self.appDelegate.languageData["Social_Sharing"] as! String).trim() : "Social Sharing"
        let socialSharingDescription = (self.appDelegate.languageData["Sharing_with_Facebook_Twitter_WhatsApp_etc_get"] as? String != nil) ? (self.appDelegate.languageData["Sharing_with_Facebook_Twitter_WhatsApp_etc_get"] as! String).trim() : "Sharing with Facebook, Twitter, WhatsApp, etc to get"
        let spendEarnTitle = (self.appDelegate.languageData["Spend_Earn"] as? String != nil) ? (self.appDelegate.languageData["Spend_Earn"] as! String).trim() : "Spend Earn"
        let spendEarnDescription = (self.appDelegate.languageData["Earn_1_points_for_every_1_spent_with_Harpers"] as? String != nil) ? (self.appDelegate.languageData["Earn_1_points_for_every_1_spent_with_Harpers"] as! String).trim() : "Earn 1 point for every GBP 1 spent with Us"
        let referFriendTitle = (self.appDelegate.languageData["Refer_a_Friend"] as? String != nil) ? (self.appDelegate.languageData["Refer_a_Friend"] as! String).trim() : "Refer a Friend"
        let referFriendDescription = (self.appDelegate.languageData["Refer_with_friends_when_friend_join_and_place_orders_from_Harper"] as? String != nil) ? (self.appDelegate.languageData["Refer_with_friends_when_friend_join_and_place_orders_from_Harper"] as! String).trim() : "Refer with friends when friend join and place orders from us to get"
        let spentTitle = (self.appDelegate.languageData["250_Spend"] as? String != nil) ? (self.appDelegate.languageData["250_Spend"] as! String).trim() : "250 GBP Spent"
        let spentDescription = (self.appDelegate.languageData["Spend_more_than_250_with_Harpers_with_place_one_orders_get_extra"] as? String != nil) ? (self.appDelegate.languageData["Spend_more_than_250_with_Harpers_with_place_one_orders_get_extra"] as! String).trim() : "Spend more than GBP 250 with us with place one orders to get extra"
        
        self.arrayLoyaltyList = [["title" : signupTitle, "image" : "signup", "description" : signupDescription, "points" : "0 \(pointString)"],
                                ["title" : placeFirstOrderTitle, "image" : "delivery", "description" : placeFirstOrderDescription, "points" : "0 \(pointString)"],
                                ["title" : postReviewTitle, "image" : "review", "description" : postReviewDescription, "points" : "0 \(pointString)"],
                                ["title" : groupOrderingTitle, "image" : "group", "description" : groupOrderingDescription, "points" : "0 \(pointString)"],
                                ["title" : celebrationTitle, "image" : "celebration", "description" : celebrationDescription, "points" : "0 \(pointString)"],
                                ["title" : socialSharingTitle, "image" : "social_share", "description" : socialSharingDescription, "points" : "0 \(pointString)"],
                                ["title" : spendEarnTitle, "image" : "earn", "description" : spendEarnDescription, "points" : "0 \(pointString)"],
                                ["title" : referFriendTitle, "image" : "refer_friend", "description" : referFriendDescription, "points" : "0 \(pointString)"],
                                ["title" : spentTitle, "image" : "spend", "description" : spentDescription, "points" : "0 \(pointString)"]]
        
        self.webApiGetLoyaltyPointsList()
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
        
        return self.arrayLoyaltyPointList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("LoyaltyTableViewCell", owner: self, options: nil)?.first as! LoyaltyTableViewCell
        cell.selectionStyle = .none
        
        let dictionary = self.arrayLoyaltyPointList[indexPath.row]
        print(dictionary)
        
        cell.labelTitle.text = dictionary["title"]
        cell.labelPoints.text = dictionary["points"]
        cell.labelDescription.text = dictionary["description"]
        cell.imageViewLoyalty.image = UIImage.init(named: dictionary["image"]!)
        UtilityMethods.changeImageColor(cell.imageViewLoyalty, Colors.colorWithHexString(Colors.GREEN_COLOR))
        
        let strNumber: NSString = cell.labelPoints.text! as NSString
        let range = (strNumber).range(of: self.pointString)
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 8.0, weight: .regular), range: range)
        cell.labelPoints.attributedText = attribute
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //    MARK:- Button Action
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
        self.moveOnMenuPage()
    }
    
    //    MARK:- Web Api Code Start
//    Get Loyalty Points List
    func webApiGetLoyaltyPointsList() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_restaurant_loyalty_point_list.php?lang_code=\(WebApi.LANGUAGE_CODE)&api_key=\(WebApi.API_KEY)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupLoyaltyPointsList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup loyalty Points list
    func setupLoyaltyPointsList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
//        For sign up points
        if jsonDictionary[JSONKey.LOYALTY_SIGN_UP_POINT] as? Int != nil {
            
            var dictionary = self.arrayLoyaltyList[0]
            dictionary["points"] = String(jsonDictionary[JSONKey.LOYALTY_SIGN_UP_POINT] as! Int) + pointString
            arrayLoyaltyList[0] = dictionary
        }else {
            
            self.arrayLoyaltyList.remove(at: 0)
        }
        
//        For sign up points
        if jsonDictionary[JSONKey.LOYALTY_FIRST_ORDER] as? Int != nil {
            
            var dictionary = self.arrayLoyaltyList[1]
            dictionary["points"] = String(jsonDictionary[JSONKey.LOYALTY_FIRST_ORDER] as! Int) + pointString
            arrayLoyaltyList[1] = dictionary
        }else {
            
            self.arrayLoyaltyList.remove(at: 1)
        }
        
//        For Post Review
        if jsonDictionary[JSONKey.LOYALTY_POST_REVIEW] as? Int != nil {
            
            var dictionary = self.arrayLoyaltyList[2]
            dictionary["points"] = String(jsonDictionary[JSONKey.LOYALTY_POST_REVIEW] as! Int) + pointString
            arrayLoyaltyList[2] = dictionary
        }else {
            
            self.arrayLoyaltyList.remove(at: 2)
        }
        
//        For Group order
        if jsonDictionary[JSONKey.LOYALTY_GROUP_ORDERING] as? Int != nil {
            
            var dictionary = self.arrayLoyaltyList[3]
            dictionary["points"] = String(jsonDictionary[JSONKey.LOYALTY_GROUP_ORDERING] as! Int) + pointString
            arrayLoyaltyList[3] = dictionary
        }else {
            
            self.arrayLoyaltyList.remove(at: 3)
        }
        
//        For Birthday celebration
        if jsonDictionary[JSONKey.LOYALTY_BIRTHDAY_CELEBRATION] as? Int != nil {
            
            var dictionary = self.arrayLoyaltyList[4]
            dictionary["points"] = String(jsonDictionary[JSONKey.LOYALTY_BIRTHDAY_CELEBRATION] as! Int) + pointString
            arrayLoyaltyList[4] = dictionary
        }else {
            
            self.arrayLoyaltyList.remove(at: 4)
        }
        
//        For Social Sharing
        if jsonDictionary[JSONKey.LOYALTY_MEDIA_SHARE] as? Int != nil {
            
            var dictionary = self.arrayLoyaltyList[5]
            dictionary["points"] = String(jsonDictionary[JSONKey.LOYALTY_MEDIA_SHARE] as! Int) + pointString
            arrayLoyaltyList[5] = dictionary
        }else {
            
            self.arrayLoyaltyList.remove(at: 5)
        }
        
//        For Spend & Earning
        if jsonDictionary[JSONKey.LOYALTY_SPEND_MORE] as? Int != nil {
            
            var dictionary = self.arrayLoyaltyList[6]
            dictionary["points"] = String(jsonDictionary[JSONKey.LOYALTY_SPEND_MORE] as! Int) + pointString
            arrayLoyaltyList[6] = dictionary
        }else {
            
            self.arrayLoyaltyList.remove(at: 6)
        }
        
//        For Refer a Friend
        if jsonDictionary[JSONKey.LOYALTY_REFER_FRIEND] as? Int != nil {
            
            var dictionary = self.arrayLoyaltyList[7]
            dictionary["points"] = String(jsonDictionary[JSONKey.LOYALTY_REFER_FRIEND] as! Int) + pointString
            arrayLoyaltyList[7] = dictionary
        }else {
            
            self.arrayLoyaltyList.remove(at: 7)
        }
        
//        For Refer a Friend
        if jsonDictionary[JSONKey.LOYALTY_PER_ORDER] as? Int != nil {
            
            var dictionary = self.arrayLoyaltyList[8]
            dictionary["points"] = String(jsonDictionary[JSONKey.LOYALTY_PER_ORDER] as! Int) + pointString
            arrayLoyaltyList[8] = dictionary
        }else {
            
            self.arrayLoyaltyList.remove(at: 8)
        }
        
        self.arrayLoyaltyPointList = self.arrayLoyaltyList
        self.tableView.reloadData()
    }
}
