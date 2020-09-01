//
//  OptionViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 06/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class OptionViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TableBookedDelegate {
    
    
    func showMessageBookedTable(_ message: String) {
        
        self.showToastWithMessage(self.view, message)
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    let CELL_ID = "OptionCell"
    var restaurantInfo = RestaurantInfo()
    var arrayOptionList = Array<Dictionary<String, String>>()
    
//    var INFO_INDEX = 0
    var RESTAURANT_INDEX = 0
    var OPENING_TIME_INDEX = 1
    var BRANCHES_INDEX = 2
    var DELIVERY_AREA_INDEX = 3
    var BOOK_TABLE_INDEX = 4
    var CONTACT_US_INDEX = 5
    var GALLERY_INDEX = 6
    var OFFER_INDEX = 7
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["More"] as? String != nil) ? (self.appDelegate.languageData["More"] as! String).trim() : "More"
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as? RestaurantInfo != nil {
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        self.setupBackBarButton()
        self.collectionView.backgroundColor = .clear
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.setupOptionList()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "OptionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.CELL_ID)
    }
    
//    Setup Option List
    func setupOptionList() -> Void {
        
//        let info = (self.appDelegate.languageData["Info"] as? String != nil) ? (self.appDelegate.languageData["Info"] as! String).trim() : "Info"
        let review = (self.appDelegate.languageData["Review"] as? String != nil) ? (self.appDelegate.languageData["Review"] as! String).trim() : "Review"
        
        let openingHours = (self.appDelegate.languageData["Opening_Hours"] as? String != nil) ? (self.appDelegate.languageData["Opening_Hours"] as! String).trim() : "Opening Hours"
        let branches = (self.appDelegate.languageData["Branches"] as? String != nil) ? (self.appDelegate.languageData["Branches"] as! String).trim() : "Branches"
        let deliveryArea = (self.appDelegate.languageData["delivery_area"] as? String != nil) ? (self.appDelegate.languageData["delivery_area"] as! String).trim() : "Delivery Area"
        let bookTable = (self.appDelegate.languageData["Book_a_Table"] as? String != nil) ? (self.appDelegate.languageData["Book_a_Table"] as! String).trim() : "Book a Table"
        let contactUs = (self.appDelegate.languageData["contact_us"] as? String != nil) ? (self.appDelegate.languageData["contact_us"] as! String).trim() : "Contact Us"
        let gallery = (self.appDelegate.languageData["Gallery"] as? String != nil) ? (self.appDelegate.languageData["Gallery"] as! String).trim() : "Gallery"
        let offer = (self.appDelegate.languageData["Offer"] as? String != nil) ? (self.appDelegate.languageData["Offer"] as! String).trim() : "Offer"
        
        if self.restaurantInfo.isDineAvailable {
//            self.arrayOptionList = [["name" : info, "image" : "tab_info", "color" : "#02BF67"],
//                                   ["name" : review, "image" : "tab_review_restaurant", "color" : "#FF1435"],
//                                   ["name" : openingHours, "image" : "tab_opening_hours", "color" : "#81EC62"],
//                                   ["name" : branches, "image" : "tab_branches", "color" : "#EC7734"],
//                                   ["name" : deliveryArea, "image" : "delivery_area_tab", "color" : "#39BFE2"],
//                                   ["name" : bookTable, "image" : "book_table_tab", "color" : "#DFC000"],
//                                   ["name" : contactUs, "image" : "contact_us_tab", "color" : "#02BF67"],
//                                   ["name" : gallery, "image" : "gallery_tab", "color" : "#39BFE2"],
//                                   ["name" : offer, "image" : "tab_offer", "color" : "#DE2EFF"]]
            self.arrayOptionList = [["name" : review, "image" : "tab_review_restaurant", "color" : "#FF1435"],
                                    ["name" : openingHours, "image" : "tab_opening_hours", "color" : "#81EC62"],
                                    ["name" : branches, "image" : "tab_branches", "color" : "#EC7734"],
                                    ["name" : deliveryArea, "image" : "delivery_area_tab", "color" : "#39BFE2"],
                                    ["name" : bookTable, "image" : "book_table_tab", "color" : "#DFC000"],
                                    ["name" : contactUs, "image" : "contact_us_tab", "color" : "#02BF67"],
                                    ["name" : gallery, "image" : "gallery_tab", "color" : "#39BFE2"],
                                    ["name" : offer, "image" : "tab_offer", "color" : "#DE2EFF"]]
            self.RESTAURANT_INDEX = 0
            self.OPENING_TIME_INDEX = 1
            self.BRANCHES_INDEX = 2
            self.DELIVERY_AREA_INDEX = 3
            self.BOOK_TABLE_INDEX = 4
            self.CONTACT_US_INDEX = 5
            self.GALLERY_INDEX = 6
            self.OFFER_INDEX = 7
        }else {
            self.arrayOptionList = [["name" : review, "image" : "tab_review_restaurant", "color" : "#FF1435"],
                                    ["name" : openingHours, "image" : "tab_opening_hours", "color" : "#81EC62"],
                                    ["name" : branches, "image" : "tab_branches", "color" : "#EC7734"],
                                    ["name" : deliveryArea, "image" : "delivery_area_tab", "color" : "#39BFE2"],
                                    ["name" : contactUs, "image" : "contact_us_tab", "color" : "#02BF67"],
                                    ["name" : gallery, "image" : "gallery_tab", "color" : "#39BFE2"],
                                    ["name" : offer, "image" : "tab_offer", "color" : "#DE2EFF"]]
            self.RESTAURANT_INDEX = 0
            self.OPENING_TIME_INDEX = 1
            self.BRANCHES_INDEX = 2
            self.DELIVERY_AREA_INDEX = 3
            self.CONTACT_US_INDEX = 4
            self.GALLERY_INDEX = 5
            self.OFFER_INDEX = 6
        }
    }
    
    //    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrayOptionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CELL_ID, for: indexPath) as! OptionCollectionViewCell
        
        let dictionary = self.arrayOptionList[indexPath.row]
        cell.labelOptionName.text = dictionary["name"]
        cell.imageViewOption.image = UIImage.init(named: dictionary["image"]!)
        cell.viewBg.backgroundColor = Colors.colorWithHexString(dictionary["color"]!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (self.collectionView.bounds.width - 10) / 2, height: ((self.collectionView.bounds.width - 10) / 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
//        case self.INFO_INDEX:
//            let aboutVC = AboutViewController.init(nibName: "AboutViewController", bundle: nil)
//            self.navigationController?.pushViewController(aboutVC, animated: true)
//            break
            
        case self.BRANCHES_INDEX:
            let branchesVC = BranchesViewController.init(nibName: "BranchesViewController", bundle: nil)
            self.navigationController?.pushViewController(branchesVC, animated: true)
            break
            
        case self.CONTACT_US_INDEX:
            let contactVC = ContactViewController.init(nibName: "ContactViewController", bundle: nil)
            self.navigationController?.pushViewController(contactVC, animated: true)
            break
            
        case self.OPENING_TIME_INDEX:
            let openingHoursVC = OpeningHoursViewController.init(nibName: "OpeningHoursViewController", bundle: nil)
            self.navigationController?.pushViewController(openingHoursVC, animated: true)
            break
            
        case self.RESTAURANT_INDEX:
            let restaurantReviewVC = RestaurantReviewViewController.init(nibName: "RestaurantReviewViewController", bundle: nil)
            self.navigationController?.pushViewController(restaurantReviewVC, animated: true)
            break
            
        case self.OFFER_INDEX:
            let offerVC = OfferViewController.init(nibName: "OfferViewController", bundle: nil)
            self.navigationController?.pushViewController(offerVC, animated: true)
            break
            
        case self.DELIVERY_AREA_INDEX:
            let deliveryAreaVC = DeliveryViewController.init(nibName: "DeliveryViewController", bundle: nil)
            self.navigationController?.pushViewController(deliveryAreaVC, animated: true)
            break
            
        case self.BOOK_TABLE_INDEX:
            
            if !UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
                
                let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
                loginVC.isMovedFromOptionPage = true
                self.navigationController?.pushViewController(loginVC, animated: true)
            }else {
                
                let bookTable = BookTableViewController.init(nibName: "BookTableViewController", bundle: nil)
                bookTable.delegate = self
                self.navigationController?.pushViewController(bookTable, animated: true)
            }
            break
            
        case self.GALLERY_INDEX:
            let galleryVC = GalleryViewController.init(nibName: "GalleryViewController", bundle: nil)
            self.navigationController?.pushViewController(galleryVC, animated: true)
            break
            
        default:
            break
        }
    }
}
