//
//  OfferViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 05/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class OfferViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonGotoMenu: UIButton!
    @IBOutlet weak var labelNoOffer: UILabel!
    
    var arrayOfferList = Array<Dictionary<String, String>>()
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["Offer"] as? String != nil) ? (self.appDelegate.languageData["Offer"] as! String).trim() : "Offer"
        self.labelNoOffer.isHidden = true
        self.labelNoOffer.text = ConstantStrings.NO_OFFER_AVAILABLE
        self.setupBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.buttonGotoMenu.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.buttonGotoMenu.setTitle(ConstantStrings.GO_TO_MENU, for: .normal)
        self.setupTableViewDelegateAndDatasource()
        self.webApiGetOfferList()
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
        
        return self.arrayOfferList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("OfferTableViewCell", owner: self, options: nil)?.first as! OfferTableViewCell
        cell.selectionStyle = .none
        
        let dictionaryOffer = self.arrayOfferList[indexPath.row]
        cell.labelOffer.text = dictionaryOffer[JSONKey.OFFER_TITLE_NAME]
        cell.labelCode.text = dictionaryOffer[JSONKey.OFFER_COUPON_CODE]
        cell.labelOfferFor.text = " "
        cell.labelTillValid.text = (self.appDelegate.languageData["Valid_till"] as? String != nil) ? (self.appDelegate.languageData["Valid_till"] as! String).trim() :"Valid till"
        cell.labelOfferDate.text = dictionaryOffer[JSONKey.OFFER_COUPON_LIMIT]
        cell.labelDescription.text = dictionaryOffer[JSONKey.OFFER_DESCRIPTION]
        var imageUrl = dictionaryOffer[JSONKey.OFFER_COUPON_IMAGE]!
        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
        cell.imageViewOffer.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "offer_icon"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    //    MARK:- Button Action
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
        self.moveOnMenuPage()
    }
    
//    MARK:- Web Code Start
//    Web Api for get offer list
    func webApiGetOfferList() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_restaurant_Offers.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json[JSONKey.ERROR_CODE] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupOfferList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    func setup Offer list
    func setupOfferList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary["RestaurantDiscountCouponList"] as? Array<Dictionary<String, Any>> != nil {
            
            let arrayDictionary = jsonDictionary["RestaurantDiscountCouponList"] as! Array<Dictionary<String, Any>>
            for offerDictionary in arrayDictionary {
                
                var offer = Dictionary<String, String>()
                offer[JSONKey.OFFER_ID] = (offerDictionary[JSONKey.OFFER_ID] as? Int != nil) ? (String(offerDictionary[JSONKey.OFFER_ID] as! Int)) : "0"
                offer[JSONKey.OFFER_TITLE_NAME] = (offerDictionary[JSONKey.OFFER_TITLE_NAME] as? String != nil) ? (offerDictionary[JSONKey.OFFER_TITLE_NAME] as! String) : "-"
                offer[JSONKey.OFFER_DESCRIPTION] = (offerDictionary[JSONKey.OFFER_DESCRIPTION] as? String != nil) ? (offerDictionary[JSONKey.OFFER_DESCRIPTION] as! String) : "-"
                offer[JSONKey.OFFER_COUPON_CODE] = (offerDictionary[JSONKey.OFFER_COUPON_CODE] as? String != nil) ? (offerDictionary[JSONKey.OFFER_COUPON_CODE] as! String) : "-"
                offer[JSONKey.OFFER_COUPON_IMAGE] = (offerDictionary[JSONKey.OFFER_COUPON_IMAGE] as? String != nil) ? (offerDictionary[JSONKey.OFFER_COUPON_IMAGE] as! String) : ""
                offer[JSONKey.OFFER_COUPON_LIMIT] = (offerDictionary[JSONKey.OFFER_COUPON_LIMIT] as? String != nil) ? (offerDictionary[JSONKey.OFFER_COUPON_LIMIT] as! String) : ""
                
                if !offer.isEmpty {
                    
                    self.arrayOfferList.append(offer)
                }
            }
        }
        
        if self.arrayOfferList.count == 0 {
            
            self.labelNoOffer.isHidden = false
        }else {
            
            self.labelNoOffer.isHidden = true
            self.tableView.reloadData()
        }
    }
}

//{"RestaurantDiscountCouponList":[{"CouponTitle":"10% OFF","id":39,"CouponCode":"AF04160","coupon_description":"Covid19 Offers Today: Fill your cart with a minimum value of GBP 100, valid on all categories AF04160","CouponValidTill":"Always","coupon_img":"https:\/\/www.dmd.foodsdemo.com\/images\/no_coupon.png","error":"0","error_msg":"success"}]}
