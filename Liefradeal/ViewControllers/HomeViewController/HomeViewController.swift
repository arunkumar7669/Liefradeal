//
//  HomeViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SDWebImage
import Toast_Swift
import SwiftyJSON

class HomeViewController: BaseViewController, UITextFieldDelegate, ModifyItemCountDelegate, UITableViewDelegate, UITableViewDataSource {
    
//    @IBOutlet weak var viewSearch: UIView!
//    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewContainer: UIView!
//    @IBOutlet weak var collectionViewSlider: UICollectionView!
//    @IBOutlet weak var pageControl: UIPageControl!
//    @IBOutlet weak var textFieldSearch: UITextField!
//    @IBOutlet weak var collectionViewCategory: UICollectionView!
//    @IBOutlet weak var heightCategoryCollectionView: NSLayoutConstraint!
    @IBOutlet weak var imageViewCart: UIImageView!
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var imageViewMenu: UIImageView!
    @IBOutlet weak var imageViewMe: UIImageView!
    @IBOutlet weak var imageViewHome: UIImageView!
    @IBOutlet weak var imageViewFilter: UIImageView!
    //    @IBOutlet weak var imageViewMore: UIImageView!
//    @IBOutlet weak var labelHome: UILabel!
//    @IBOutlet weak var labelMenu: UILabel!
//    @IBOutlet weak var labelCart: UILabel!
//    @IBOutlet weak var labelMe: UILabel!
//    @IBOutlet weak var labelMore: UILabel!
    @IBOutlet weak var viewCart: UIView!
    @IBOutlet weak var viewTabContainer: UIView!
//    @IBOutlet weak var imageViewMenu: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let SLIDER_CELL = "SliderCell"
    let CATEGORY_CELL = "NewCategoryCell"
    let RECOMMEND_CELL = "RecommendCell"
    
    let BUTTON_HOME = 1
    let BUTTON_MENU = 2
    let BUTTON_CART = 3
    let BUTTON_MORE = 4
    let BUTTON_ME = 5
    
    let bagButton = CartButton()
    var isNavigationImageAdded = Bool()
    var isDrawerOpened = Bool()
    var userDetails = UserDetails()
    var arraySlider = Array<String>()
    var restaurantInfo = RestaurantInfo()
    var arrayCategory = Array<Dictionary<String, String>>()
    var arrayRecommendItems = Array<Dictionary<String,String>>()
    var arrayDefaultCategoryMenuItems = Array<Dictionary<String,String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isDrawerOpened = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST) as! Array<Dictionary<String, String>>
        self.setupCartButton(arrayCartItems.count)
//        self.labelHome.text = (self.appDelegate.languageData["Home"] as? String != nil) ? (self.appDelegate.languageData["Home"] as! String).trim() : "Home"
//        self.labelCart.text = (self.appDelegate.languageData["Cart"] as? String != nil) ? (self.appDelegate.languageData["Cart"] as! String).trim() : "Cart"
//        self.labelMenu.text = (self.appDelegate.languageData["Menu"] as? String != nil) ? (self.appDelegate.languageData["Menu"] as! String).trim() : "Menu"
//        self.labelMe.text = (self.appDelegate.languageData["More"] as? String != nil) ? (self.appDelegate.languageData["More"] as! String).trim() : "More"
//        self.labelMore.text = (self.appDelegate.languageData["Me"] as? String != nil) ? (self.appDelegate.languageData["Me"] as! String).trim() : "Me"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !self.isDrawerOpened {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
//        super.viewDidLayoutSubviews()
//        let height = self.collectionViewCategory.collectionViewLayout.collectionViewContentSize.height
//        self.heightCategoryCollectionView.constant = height
//        self.view.layoutIfNeeded()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.setupSliderImageList()
        self.setupCategoryMenuList()
        self.setupRecommendItemsList()
        UtilityMethods.changeImageColor(self.imageViewMenu, Colors.colorWithHexString(Colors.APP_COLOR))
//        self.pageControl.numberOfPages = self.arraySlider.count
//        self.pageControl.currentPageIndicatorTintColor = Colors.colorWithHexString(Colors.RED_COLOR)
//        self.collectionViewCategory.frame = CGRect.init(x: 10, y: self.collectionViewCategory.bounds.origin.x, width: self.screenWidth - 20, height: self.collectionViewCategory.bounds.height)
        if appCurrencySymbol.isEmpty {
            appCurrencySymbol = UserDefaultOperations.getStringObject(ConstantStrings.COUNTRY_CODE).currencySymbol
        }
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) != nil {
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        if isFirstTimeOnHomePage {
            isFirstTimeOnHomePage = false
            self.showToastWithMessage(self.view, firstMessage)
        }
        UtilityMethods.changeImageColor(self.imageViewCart, .white)
        UtilityMethods.changeImageColor(self.imageViewMe, .white)
        UtilityMethods.changeImageColor(self.imageViewFilter, .white)
//        UtilityMethods.changeImageColor(self.imageViewHome, .darkGray)
        
//        self.imageViewLogo.sd_setImage(with: URL(string: self.restaurantInfo.logoImageUrl), placeholderImage: UIImage(named: ""))
//        self.collectionViewSlider.backgroundColor = .clear
//        self.collectionViewCategory.backgroundColor = .clear
        self.viewContainer.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.viewTabContainer.backgroundColor = Colors.colorWithHexString(Colors.APP_COLOR)
        self.setupTableViewDelegateAndDatasource()
        
//        self.collectionViewSlider.delegate = self
//        self.collectionViewSlider.dataSource = self
//        self.collectionViewSlider.register(UINib.init(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.SLIDER_CELL)
//
//        self.collectionViewCategory.delegate = self
//        self.collectionViewCategory.dataSource = self
//        self.collectionViewCategory.register(UINib.init(nibName: "NewCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.CATEGORY_CELL)
        
        let arrayCartItem = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST) as! Array<Dictionary<String, String>>
        self.setupCartButton(arrayCartItem.count)
//        self.startTimer()
        self.webApiGetLoyaltyPoints()
    }
    
    func setupTableViewDelegateAndDatasource() -> Void {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 40.0
        self.tableView.separatorStyle = .none
    }
    
//    Setup Cart Button for navigation bar
    func setupCartButton(_ cartItemCount : Int) -> Void {
        
        bagButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        bagButton.tintColor = UIColor.white
        bagButton.setImage(UIImage(named: "cart")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        bagButton.badge = "\(cartItemCount)"
        bagButton.addTarget(self, action: #selector(self.buttonHomeCartClickAction(_:)), for: .touchUpInside)
        self.viewCart.addSubview(bagButton)
        self.viewCart.backgroundColor = .clear
    }
    
    //    Button cart action
    @objc func buttonHomeCartClickAction(_ sender : UIButton) -> Void {
        
        let cartVC = CartViewController.init(nibName: "CartViewController", bundle: nil)
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    //    Setup stroke in page control
//    func setupPageControlStrokeBorder(_ indexPath : IndexPath) -> Void {
//
//        for index in 0..<self.arraySlider.count{ // your array.count
//
//            let viewDot = self.pageControl.subviews[index]
//            viewDot.layer.borderWidth = 0.5
//            viewDot.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//
//            if (index == indexPath.row){ // indexPath is the current indexPath of your selected cell or view in the collectionView i.e which needs to be highlighted
//                viewDot.backgroundColor = Colors.colorWithHexString(Colors.RED_COLOR)
//                viewDot.layer.borderColor = Colors.colorWithHexString(Colors.LIGHT_GRAY_COLOR).cgColor
//            }
//            else{
//                viewDot.backgroundColor = UIColor.white
//                viewDot.layer.borderColor = UIColor.black.cgColor
//
//            }
//        }
//    }
    
//    @objc func scrollToNextCell(){
//
//        if let coll  = self.collectionViewSlider {
//            for cell in coll.visibleCells {
//                let indexPath: IndexPath? = coll.indexPath(for: cell)
//                if ((indexPath?.row)! < self.arraySlider.count - 1){
//                    let indexPath1: IndexPath?
//                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
//
//                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
//                }
//                else{
//                    let indexPath1: IndexPath?
//                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
//                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
//                }
//
//            }
//        }
//    }
    
//    UITableViewDelegate And Datasource Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("RestaurantListTVC", owner: self, options: nil)?.first as! RestaurantListTVC
        cell.selectionStyle = .none
        return cell
    }
    
////    Invokes Timer to start Automatic Animation with repeat enabled
//    func startTimer() {
//
//        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true)
//    }
//
////    UICollectionView Delegate and datasource Method
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        if collectionView == self.collectionViewSlider {
//
//            return self.arraySlider.count
//        }else if collectionView == self.collectionViewCategory {
//
//            return self.arrayCategory.count
//        }else {
//
//            return 0
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if collectionView == self.collectionViewSlider {
//
//            return self.setupSliderCell(collectionView, indexPath)
//        }else {
//
//            return self.setupCategoryCell(collectionView, indexPath)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        if collectionView == self.collectionViewSlider {
//
//            return CGSize.init(width: self.collectionViewSlider.bounds.width, height: self.collectionViewSlider.bounds.height)
//        }else if collectionView == self.collectionViewCategory {
//
//            return CGSize.init(width: (self.screenWidth - 30) / 2, height: ((self.screenWidth - 30) / 2))
//        }else {
//
//            return CGSize.init(width: (self.collectionViewCategory.bounds.width - 10) / 2, height: ((self.collectionViewCategory.bounds.width - 10) / 2) + 120)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        if collectionView == self.collectionViewSlider {
//
//            return 0
//        }else if collectionView == self.collectionViewCategory {
//
//            return 10
//        }else {
//
//            return 10
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//        self.setupPageControlStrokeBorder(indexPath)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let pageWidth = self.collectionViewSlider.frame.size.width
//        let currentPage = Int(self.collectionViewSlider.contentOffset.x / pageWidth)
//
//        self.pageControl.currentPage = currentPage
//        self.setupPageControlStrokeBorder(IndexPath.init(row: currentPage, section: 0))
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if collectionView == self.collectionViewCategory {
//
//            let menuVC = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
//            menuVC.selectedPageMenu = indexPath.row
//            menuVC.arrayMenuList = self.arrayCategory
//            menuVC.arrayMenuItems = self.arrayDefaultCategoryMenuItems
//            self.navigationController?.pushViewController(menuVC, animated: true)
//        }
//    }
//
//    //    MARK:- Setup Cell And method
////    Setup Cell for slider collection view
//    func setupSliderCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> SliderCollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.SLIDER_CELL, for: indexPath) as! SliderCollectionViewCell
//        var imageUrl = self.arraySlider[indexPath.row]
//        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
//        cell.imageViewSlider.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "slider"))
//        cell.imageViewSlider.layer.cornerRadius = 5.0
//        cell.imageViewSlider.layer.masksToBounds = true
//
//        return cell
//    }
//
////    Setup Cell for Category Collection view
//    func setupCategoryCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> NewCategoryCollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CATEGORY_CELL, for: indexPath) as! NewCategoryCollectionViewCell
//        let dictionary = self.arrayCategory[indexPath.row]
//        cell.labelCategoryName.text = dictionary[JSONKey.CATEGORY_NAME]
//        var imageUrl = dictionary[JSONKey.CATEGORY_IMAGE]!
//        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
//        cell.imageViewCategory.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: ConstantStrings.CATGORY_PLACEHOLDER))
//        cell.imageViewCategory.layer.cornerRadius = 3.0
//        cell.imageViewCategory.layer.masksToBounds = true
//
//        cell.viewCategoryName.frame = CGRect.init(x: 0, y: 0, width: (self.collectionViewCategory.bounds.width - 10) / 2, height: cell.viewCategoryName.bounds.height)
//        UtilityMethods.roundCorners(view: cell.viewCategoryName, corners: [.topRight, .topLeft], radius: 3.0)
//
//        return cell
//    }
//
////    Setup Cell for Recommend Collection View
//    func setupRecommendCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> RecommendCollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.RECOMMEND_CELL, for: indexPath) as! RecommendCollectionViewCell
////        cell.delegate = self
//        cell.indexPath = indexPath
//        cell.contentView.backgroundColor = .clear
//        let dictionary = self.arrayRecommendItems[indexPath.row]
//        cell.labelMenuName.text = dictionary[JSONKey.ITEM_NAME]
////        cell.imageViewItem.sd_setImage(with: URL(string: dictionary[JSONKey.ITEM_FOOD_IMAGE]!), placeholderImage: UIImage(named: ConstantStrings.CATGORY_PLACEHOLDER))
//        cell.labelCount.text = dictionary[JSONKey.ITEM_QUANTITY]
//        cell.labelAmount.text = ConstantStrings.RUPEES_SYMBOL + dictionary[JSONKey.ITEM_OFFER_PRICE]!
//        cell.labelMenuDetails.text = dictionary[JSONKey.ITEM_DESCRIPTION]
////        cell.imageViewItemCart.isHidden = true
//        cell.buttonMinus.isHidden = true
//        cell.buttonPlus.isHidden = true
//        cell.labelCount.isHidden = true
//
//        if cell.labelMenuDetails.text!.isEmpty {
//
//            cell.labelMenuDetails.text = " "
//        }
//
//        if dictionary[JSONKey.ITEM_IS_EDITABLE] == ConstantStrings.TRUE_STRING {
//
//            cell.viewItemBG.isHidden = false
//        }else if dictionary[JSONKey.ITEM_IS_EDITABLE] == ConstantStrings.FALSE_STRING {
//
//            cell.viewItemBG.isHidden = true
//        }
//
//        return cell
//    }
    
//    Recommend cell update item quantity delegate method
    func updateItemQuantity(_ count: String, _ indexPath: IndexPath, _ buttonTag : Int) {
        
        var dictionary = self.arrayRecommendItems[indexPath.row]
        
        if dictionary["isAddedToCart"] == ConstantStrings.ITEM_ADDED_TO_CART {
            
            dictionary["quantity"] = count
            self.arrayRecommendItems[indexPath.row] = dictionary
        }else {
        
            self.showToastWithMessage(self.view, ConstantStrings.FIRSTLY_PLEASE_ADD_INTO_CART)
        }
    }
    
//    Recommend cell item Added into cart delegate method
    func itemAddedIntoCart( _ indexPath: IndexPath) {
        
    }
    
    //    MARK:- UITextField Delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        if textField == self.textFieldSearch {
//
//            self.textFieldSearch.resignFirstResponder()
//        }
        
        return true
    }
    
    //    MARK:- Button Action
    //    Button Action for Search
    @IBAction func buttonSearchAction(_ sender: UIButton) {
        
//        self.textFieldSearch.becomeFirstResponder()
    }
    
    //    Button Action For filter use
    @IBAction func buttonFilterAction(_ sender: UIButton) {
        
        
    }
    
//    Button Action for show all category items
    @IBAction func buttonShowAllCategoryAction(_ sender: UIButton) {
        
        let menuVC = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
        menuVC.arrayMenuList = self.arrayCategory
        menuVC.arrayMenuItems = self.arrayDefaultCategoryMenuItems
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    
//    Button Action for show Recommend
    @IBAction func buttonRecommendAction(_ sender: UIButton) {
        
        let menuVC = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
        menuVC.arrayMenuList = self.arrayCategory
        menuVC.arrayMenuItems = self.arrayDefaultCategoryMenuItems
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    
//    Button Action For menu
    @IBAction func buttonMenuAction(_ sender: UIButton) {
        
        self.isDrawerOpened = true
        self.appDelegate.drawerController.setDrawerState(.opened, animated: true)
    }
    
//    Button Tab bar menu action
    @IBAction func buttonTabBarMenuAction(_ sender: UIButton) {
        
        if sender.tag == self.BUTTON_HOME {
            
            
        }else if sender.tag == self.BUTTON_MENU {
            
            let menuVC = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
            menuVC.arrayMenuList = self.arrayCategory
            menuVC.arrayMenuItems = self.arrayDefaultCategoryMenuItems
            self.navigationController?.pushViewController(menuVC, animated: true)
        }else if sender.tag == self.BUTTON_CART {
            
            let cartVC = CartViewController.init(nibName: "CartViewController", bundle: nil)
            self.navigationController?.pushViewController(cartVC, animated: true)
        }else if sender.tag == self.BUTTON_ME {
            
            if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
                
                let profileVC = MyProfileViewController.init(nibName: "MyProfileViewController", bundle: nil)
                self.navigationController?.pushViewController(profileVC, animated: true)
            }else {
                
                self.showToastWithMessage(self.view, ConstantStrings.PLEASE_LOGIN_FIRSTLY)
            }
        }else if sender.tag == self.BUTTON_MORE {
            
            let optionVC = OptionViewController.init(nibName: "OptionViewController", bundle: nil)
            self.navigationController?.pushViewController(optionVC, animated: true)
        }
    }
    
    //    MARK:- Parse the data for display
//    Setup Slider Image List
    func setupSliderImageList() -> Void {
        
        let dictionarySliderImage = UserDefaultOperations.getDictionaryObject(ConstantStrings.HOME_SLIDER_IMAGE)
        
        if dictionarySliderImage[JSONKey.SLIDER_BANNER_LIST] as? Array<Dictionary<String, Any>> != nil {
            
            let arraySliderImage = dictionarySliderImage[JSONKey.SLIDER_BANNER_LIST] as! Array<Dictionary<String, Any>>
            for sliderImage in arraySliderImage {
                
                if sliderImage[JSONKey.ERROR_CODE] as? String != nil {
                    
                    if sliderImage[JSONKey.ERROR_CODE] as! String == "0" {
                        
                        if sliderImage[JSONKey.SLIDER_IMAGE] as? String != nil {
                            
                            self.arraySlider.append(sliderImage[JSONKey.SLIDER_IMAGE] as! String)
                        }
                    }
                }
            }
        }
    }
    
//    Setup Category menu list
    func setupCategoryMenuList() -> Void {
        
        let dictionaryCategoryList = UserDefaultOperations.getDictionaryObject(ConstantStrings.CATEGORY_LIST)
        if dictionaryCategoryList[JSONKey.MENU_CATEGORY_LIST] as? Array<Dictionary<String, Any>> != nil {
            
            let arrayCategoryList = dictionaryCategoryList[JSONKey.MENU_CATEGORY_LIST] as! Array<Dictionary<String, Any>>
            for categoryData in arrayCategoryList {
                
                var dictionaryCategory = Dictionary<String, String>()
                if categoryData[JSONKey.CATEGORY_ID] as? Int != nil {
                    
                    dictionaryCategory[JSONKey.CATEGORY_ID] = "\(categoryData[JSONKey.CATEGORY_ID] as! Int)"
                }
                
                if categoryData[JSONKey.CATEGORY_NAME] as? String != nil {
                    
                    dictionaryCategory[JSONKey.CATEGORY_NAME] = (categoryData[JSONKey.CATEGORY_NAME] as! String)
                }
                
                if categoryData[JSONKey.CATEGORY_IMAGE] as? String != nil {
                    
                    dictionaryCategory[JSONKey.CATEGORY_IMAGE] = (categoryData[JSONKey.CATEGORY_IMAGE] as! String)
                }
                
                if categoryData[JSONKey.CATEGORY_RESTAURANT_ID] as? Int != nil {
                    
                    dictionaryCategory[JSONKey.CATEGORY_RESTAURANT_ID] = "\(categoryData[JSONKey.CATEGORY_RESTAURANT_ID] as! Int)"
                }
                
                if categoryData[JSONKey.CATEGORY_SUB_CATEGORY_OBJECT_ID] as? Int != nil {
                    
                    dictionaryCategory[JSONKey.CATEGORY_SUB_CATEGORY_OBJECT_ID] = "\(categoryData[JSONKey.CATEGORY_SUB_CATEGORY_OBJECT_ID] as! Int)"
                }
                
                if categoryData[JSONKey.CATEGORY_DESCRIPTION] as? String != nil {
                    
                    dictionaryCategory[JSONKey.CATEGORY_DESCRIPTION] = (categoryData[JSONKey.CATEGORY_DESCRIPTION] as! String)
                }
                
                if !dictionaryCategory.isEmpty {
                    
                    self.arrayCategory.append(dictionaryCategory)
                }
            }
        }
    }
    
//    Setup Recommend items list
    func setupRecommendItemsList() -> Void {
        
        let dictionaryList = UserDefaultOperations.getDictionaryObject(ConstantStrings.RECOMMENDED_DATA)
        if dictionaryList[JSONKey.MENU_CATEGORY] as? Array<Array<Dictionary<String, Any>>> != nil {
            
            let arrayRecommendData = dictionaryList[JSONKey.MENU_CATEGORY] as! Array<Array<Dictionary<String, Any>>>
            var arrayRecommendList = Array<Dictionary<String, Any>>()
            var arrayRecommendItems = Array<Dictionary<String, Any>>()
            if arrayRecommendData.count > 0 {
                
                arrayRecommendList = arrayRecommendData[0]
                if arrayRecommendList.count > 0 {
                    
                    let dictionaryRecommendList = arrayRecommendList[0]
                    if dictionaryRecommendList[JSONKey.MENU_SUB_CATEGORY] as? Array<Dictionary<String, Any>> != nil {
                        
                        arrayRecommendItems = dictionaryRecommendList[JSONKey.MENU_SUB_CATEGORY] as! Array<Dictionary<String, Any>>
                        for recommendItem in arrayRecommendItems {
                            
                            var dictionaryRecommend = Dictionary<String, String>()
                            if recommendItem[JSONKey.ITEM_ID] as? Int != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_ID] = String(recommendItem[JSONKey.ITEM_ID] as! Int)
                            }
                            if recommendItem[JSONKey.ITEM_NAME] as? String != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_NAME] = (recommendItem[JSONKey.ITEM_NAME] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_SIZE] as? String != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_SIZE] = (recommendItem[JSONKey.ITEM_SIZE] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_OFFER_PRICE] as? String != nil {
                                
                                if (recommendItem[JSONKey.ITEM_OFFER_PRICE] as! String).isEmpty {
                                    
                                    dictionaryRecommend[JSONKey.ITEM_OFFER_PRICE] = "0.00"
                                    dictionaryRecommend[JSONKey.ITEM_UPDATED_PRICE] = "0.00"
                                }else {
                                    
                                    dictionaryRecommend[JSONKey.ITEM_OFFER_PRICE] = (recommendItem[JSONKey.ITEM_OFFER_PRICE] as! String)
                                    dictionaryRecommend[JSONKey.ITEM_UPDATED_PRICE] = dictionaryRecommend[JSONKey.ITEM_OFFER_PRICE]
                                }
                            }
                            if recommendItem[JSONKey.ITEM_DESCRIPTION] as? String != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_DESCRIPTION] = (recommendItem[JSONKey.ITEM_DESCRIPTION] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_FOOD_TYPE] as? String != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_FOOD_TYPE] = (recommendItem[JSONKey.ITEM_FOOD_TYPE] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_FOOD_IMAGE] as? String != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_FOOD_IMAGE] = (recommendItem[JSONKey.ITEM_FOOD_IMAGE] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_IS_SIZE_AVAILABLE] as? String != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_IS_SIZE_AVAILABLE] = (recommendItem[JSONKey.ITEM_IS_SIZE_AVAILABLE] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_IS_EXTRA_AVAILABLE] as? String != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_IS_EXTRA_AVAILABLE] = (recommendItem[JSONKey.ITEM_IS_EXTRA_AVAILABLE] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_IS_POPULAR] as? String != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_IS_POPULAR] = (recommendItem[JSONKey.ITEM_IS_POPULAR] as! String)
                            }
                            if recommendItem[JSONKey.ITEM_ORIGINAL_PRICE] as? String != nil {
                                
                                if (recommendItem[JSONKey.ITEM_ORIGINAL_PRICE] as! String).isEmpty {
                                    
                                    dictionaryRecommend[JSONKey.ITEM_ORIGINAL_PRICE] = "0.00"
                                    dictionaryRecommend[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE] = "0.00"
                                }else {
                                    
                                    dictionaryRecommend[JSONKey.ITEM_ORIGINAL_PRICE] = (recommendItem[JSONKey.ITEM_ORIGINAL_PRICE] as! String)
                                    dictionaryRecommend[JSONKey.ITEM_UPDATED_ORIGINAL_PRICE] = (recommendItem[JSONKey.ITEM_ORIGINAL_PRICE] as! String)
                                }
                            }
                            if recommendItem[JSONKey.ITEM_FOOD_TAX_APPLICABLE] as? String != nil {
                                
                                dictionaryRecommend[JSONKey.ITEM_FOOD_TAX_APPLICABLE] = (recommendItem[JSONKey.ITEM_FOOD_TAX_APPLICABLE] as! String)
                            }
                                
                            dictionaryRecommend[JSONKey.ITEM_IS_ADDED_TO_CART] = ConstantStrings.ITEM_NOT_ADDED_TO_CART
                            dictionaryRecommend[JSONKey.ITEM_QUANTITY] = "0"
                            dictionaryRecommend[JSONKey.ITEM_SIZE_ID] = ""
                            dictionaryRecommend[JSONKey.ITEM_SIZE_NAME] = ""
                            dictionaryRecommend[JSONKey.ITEM_SIZE_QUANTITY] = ""
                            dictionaryRecommend[JSONKey.ITEM_SIZE_PRICE] = "0.00"
                            dictionaryRecommend[JSONKey.ITEM_EXTRA_ID] = ""
                            dictionaryRecommend[JSONKey.ITEM_EXTRA_NAME] = ""
                            dictionaryRecommend[JSONKey.ITEM_EXTRA_QUANTITY] = ""
                             dictionaryRecommend[JSONKey.ITEM_EXTRA_PRICE] = "0.00"
                            dictionaryRecommend[JSONKey.ITEM_CHOOSE_CHAUCE_ID] = ""
                            dictionaryRecommend[JSONKey.ITEM_IS_EDITABLE] = ConstantStrings.FALSE_STRING
                            dictionaryRecommend[JSONKey.ITEM_CART_PRICE] = "0"
                            dictionaryRecommend[JSONKey.ITEM_CART_ORIGINAL_PRICE] = "0"
                            
                            if !dictionaryRecommend.isEmpty {
                                
                                self.arrayDefaultCategoryMenuItems.append(dictionaryRecommend)
                            }
                        }
                    }
                }
            }
        }
        
        for i in 0..<self.arrayDefaultCategoryMenuItems.count {
            
            self.arrayRecommendItems.append(self.arrayDefaultCategoryMenuItems[i])
            if i > 8 {
                
                break
            }
        }
    }
    
    //    MARK:- Web Api Code Start
//    Get loyalty Points
    func webApiGetLoyaltyPoints() -> Void {
        
        let url = WebApi.BASE_URL + "phpexpert_customer_loyalty_point.php?lang_code=\(WebApi.LANGUAGE_CODE)&api_key=\(WebApi.API_KEY)&CustomerId=\(self.userDetails.userID)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            if json.isEmpty {
                
//                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
//                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupLoyaltyPoints(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Func setup Loyalty Points
    func setupLoyaltyPoints(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 0 {
                
                if jsonDictionary[JSONKey.TOTAL_LOYALTY_POINTS] as? String != nil {
                    
                    
                    UserDefaultOperations.setStringObject(ConstantStrings.LOYALTY_POINTS, jsonDictionary[JSONKey.TOTAL_LOYALTY_POINTS] as! String)
                }
            }
        }
    }
}

