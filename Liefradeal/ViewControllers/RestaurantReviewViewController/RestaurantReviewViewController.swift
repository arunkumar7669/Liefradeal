//
//  RestaurantReviewViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON
import MBProgressHUD

class RestaurantReviewViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonGotoMenu: UIButton!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var labelAppName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelNoReview: UILabel!
    @IBOutlet weak var buttonWriteReview: UIButton!
    
    var restaurantInfo = RestaurantInfo()
    var arrayRestaurantReviewList = Array<Dictionary<String, String>>()
    
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
        
        self.navigationItem.title = "Restaurant Review"
        self.navigationItem.title = (self.appDelegate.languageData["Restaurant_Review"] as? String != nil) ? (self.appDelegate.languageData["Restaurant_Review"] as! String).trim() : "Restaurant Review"
        self.labelNoReview.text = (self.appDelegate.languageData["NO_RESTAURANT_REVIEW"] as? String != nil) ? (self.appDelegate.languageData["NO_RESTAURANT_REVIEW"] as! String).trim() : "No restaurant review yet."
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) != nil {
            
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        
        self.setupBackBarButton()
        self.setupTableViewDelegateAndDatasource()
        self.buttonWriteReview.isHidden = true
        self.buttonWriteReview.setImage(UIImage.init(named: "write_review")!.withRenderingMode(.alwaysTemplate), for: .normal)
        self.buttonWriteReview.tintColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        UtilityMethods.addBorder(self.buttonWriteReview, Colors.colorWithHexString(Colors.GREEN_COLOR), self.buttonWriteReview.bounds.height / 2)
        
        self.viewRating.isUserInteractionEnabled = false
        self.buttonGotoMenu.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.labelAppName.text = self.restaurantInfo.restaurantName
        self.buttonGotoMenu.setTitle(ConstantStrings.GO_TO_MENU, for: .normal)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.labelNoReview.isHidden = true
        self.imageViewRestaurant.sd_setImage(with: URL(string: self.restaurantInfo.coverImageUrl), placeholderImage: UIImage(named: "slider"))
        self.imageViewRestaurant.layer.cornerRadius = 5.0
        self.imageViewRestaurant.layer.masksToBounds = true
        self.labelAddress.text = self.restaurantInfo.address
        self.labelRating.text = "(\(self.restaurantInfo.rating))"
        self.viewRating.rating = Double(self.restaurantInfo.rating)!
        self.webApiGetRestaurantReview()
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
        
        return self.arrayRestaurantReviewList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("RestaurantTableViewCell", owner: self, options: nil)?.first as! RestaurantTableViewCell
        cell.selectionStyle = .none
        
        let dictionaryReview = self.arrayRestaurantReviewList[indexPath.row]
        print(dictionaryReview)
        cell.labelUserName.text = dictionaryReview[JSONKey.RESTAURANT_REVIEW_CUSTOMER_NAME]
        cell.labelReview.text = dictionaryReview[JSONKey.RESTAURANT_REVIEW_COMMENT]
        var imageUrl = dictionaryReview[JSONKey.RESTAURANT_REVIEW_IMAGE]!
        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
        cell.imageViewUser.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: ""))
        cell.viewUserReview.backgroundColor = Colors.colorWithHexString(Colors.TEXTFIELD_COLOR)
        cell.viewRating.rating = Double(dictionaryReview[JSONKey.RESTAURANT_REVIEW_RATING]!)!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let currentCell = cell as! RestaurantTableViewCell
        currentCell.viewUserReview.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    //    MARK:- Button Action
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
        self.moveOnMenuPage()
    }
    
    @IBAction func buttonWriteReviewAction(_ sender: UIButton) {
        
        let writeReviewVC = WriteReviewViewController.init(nibName: "WriteReviewViewController", bundle: nil)
        self.navigationController?.pushViewController(writeReviewVC, animated: true)
    }
    
    //    MARK:- Web Code Start
//    web Api get Restaurant Review
    func webApiGetRestaurantReview() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_restaurantReview.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupRestaurantReviewList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup restaurant review list
    func setupRestaurantReviewList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.RESTAURANT_REVIEW_DATA] as? Dictionary<String, Any> != nil {
            
            let dictionaryReview = jsonDictionary[JSONKey.RESTAURANT_REVIEW_DATA] as! Dictionary<String, Any>
            
            if dictionaryReview[JSONKey.RESTAURANT_REVIEW_LIST] as? Array<Dictionary<String, Any>> != nil {
                
                let arrayReviewList = dictionaryReview[JSONKey.RESTAURANT_REVIEW_LIST] as! Array<Dictionary<String, Any>>
                
                for reviewDetails in arrayReviewList {
                    
                    var dictionaryReviewDetails = Dictionary<String, String>()
                    dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_ID] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_ID] as? Int != nil) ? String(reviewDetails[JSONKey.RESTAURANT_REVIEW_ID] as! Int) : "0"
                    dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_COMMENT] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_COMMENT] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_COMMENT] as! String) : ""
                    dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_DATE] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_DATE] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_DATE] as! String) : ""
                    dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_NAME] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_NAME] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_NAME] as! String) : ""
                    dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_IMAGE] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_IMAGE] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_IMAGE] as! String) : ""
                    dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_RATING] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_RATING] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_RATING] as! String) : ""
                    dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_FRIEND_RATING] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_FRIEND_RATING] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_FRIEND_RATING] as! String) : ""
                    dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_DELIVERY_RATING] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_DELIVERY_RATING] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_DELIVERY_RATING] as! String) : ""
                    dictionaryReviewDetails[JSONKey.RESTAURANT_REVIEW_CUSTOMER_NAME] = (reviewDetails[JSONKey.RESTAURANT_REVIEW_CUSTOMER_NAME] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_REVIEW_CUSTOMER_NAME] as! String) : ""
                    dictionaryReviewDetails[JSONKey.RESTAURANT_ORDER_ID] = (reviewDetails[JSONKey.RESTAURANT_ORDER_ID] as? String != nil) ? (reviewDetails[JSONKey.RESTAURANT_ORDER_ID] as! String) : ""
                    
                    if !dictionaryReviewDetails.isEmpty {
                        
                        self.arrayRestaurantReviewList.append(dictionaryReviewDetails)
                    }
                }
            }
        }
        
        if self.arrayRestaurantReviewList.count == 0 {
            
            self.labelNoReview.isHidden = false
        }else {
            
            self.tableView.reloadData()
        }
    }
}
