//
//  SplashViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import MBProgressHUD
import Stripe

var appCurrencySymbol = String()

class SplashViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var buttonSkip: UIButton!
    
    let cellID = "CELL"
    var timer = Timer()
    let locationManager = CLLocationManager()
    var arraySplashSreen = Array<Dictionary<String, String>>()
    var isMovedOnHomePage = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer.invalidate()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
//    Setup View Did load method
    func setupViewDidLoadMethod() -> Void {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "SplashCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.cellID)
        self.pageController.isUserInteractionEnabled = false
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.buttonSkip.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
//        self.buttonSkip.layer.cornerRadius = 5.0
        UtilityMethods.addBorder(self.buttonSkip, .white, 5.0)
        self.buttonSkip.isHidden = true
        let setTitle = (self.appDelegate.languageData["Get_Started"] as? String != nil) ? (self.appDelegate.languageData["Get_Started"] as! String) : "Get Started"
        self.buttonSkip.setTitle(setTitle, for: .normal)
//        self.setupSplashImage()
//        self.webApiGetStripePaymentPublishKey()
//        self.webApiHomeSliderImage()
//        self.webApiHomeCategoryList()
//        self.webApiRestaurantInformation()
//        self.webApiSplashScreenImages()
//        self.webApiGetRestaurantBranches()
//        self.webApiGetLanguageData()
    }
    
    func setupSplashImage() -> Void {
        
        self.pageController.numberOfPages = self.arraySplashSreen.count
        self.pageController.pageIndicatorTintColor = Colors.colorWithHexString(Colors.LIGHT_ORANGE_COLOR)
        self.pageController.currentPageIndicatorTintColor = Colors.colorWithHexString(Colors.DARK_ORANGE_COLOR)
    }
    
    @objc func scrollToNextCell(){
        
        if !self.isMovedOnHomePage {
            
            let cellSize = CGSize.init(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
            //get current content Offset of the Collection view
            let contentOffset = collectionView.contentOffset;
            //scroll to next cell
            self.collectionView.scrollRectToVisible(CGRect.init(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
            let currentPage = contentOffset.x / self.view.bounds.width
            if Double(currentPage) == Double(self.arraySplashSreen.count - 1) {
                
                self.timer.invalidate()
                UserDefaultOperations.setBoolObject(ConstantStrings.IS_GUEST_USER, true)
                self.isMovedOnHomePage = true
                self.setupDrawerController()
            }
        }
    }
    
    func startTimer() {
        
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true)
    }
    var isCalledFirstTime = Bool()
//    Get Latitude and logitude for current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if !isCalledFirstTime {
            self.isCalledFirstTime = true
            self.webApiForCheckLocation("\(locValue.latitude)", "\(locValue.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error \(error)")
    }
    
//    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arraySplashSreen.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SplashCollectionViewCell
        
        let dictionary = self.arraySplashSreen[indexPath.row]
        var imageUrl = dictionary["splash_banner_img"]!
        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
        cell.imageViewSplash.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: ""))
        cell.labelTitle1.text = ""
        cell.labelTitle2.text = ""
        cell.labelTitle3.text = ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        return     CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
//        self.pageController.currentPage = indexPath.row
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth = self.collectionView.frame.size.width
        let currentPage = Int(self.collectionView.contentOffset.x / pageWidth)
        
        if Int(currentPage) == (self.arraySplashSreen.count - 1) {
            self.collectionView.bounces = true
        }else {
            self.collectionView.bounces = true
        }
        
        if (Int(currentPage) == (self.arraySplashSreen.count - 1)) && (self.collectionView.contentOffset.x > (self.view.bounds.width * 2) + 20) {
            
            self.timer.invalidate()
            
            if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
                UserDefaultOperations.setBoolObject(ConstantStrings.IS_GUEST_USER, false)
            }else {
                UserDefaultOperations.setBoolObject(ConstantStrings.IS_GUEST_USER, true)
            }
            if !self.isMovedOnHomePage {
                
                self.isMovedOnHomePage = true
                self.setupDrawerController()
            }
        }
        
        self.pageController.currentPage = currentPage
    }
    
//    MARK:- Button Action
    @IBAction func buttonSkipAction(_ sender: UIButton) {
        
        self.timer.invalidate()
        
        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
            UserDefaultOperations.setBoolObject(ConstantStrings.IS_GUEST_USER, false)
        }else {
            UserDefaultOperations.setBoolObject(ConstantStrings.IS_GUEST_USER, true)
        }
        if !self.isMovedOnHomePage {
            
            self.isMovedOnHomePage = true
            self.setupDrawerController()
        }
    }
    
    //    MARK:- Server Operations
//    check for location according to the latitude and longitude
    func webApiForCheckLocation(_ lat : String, _ log : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_app_open_location.php?customer_lat=\(lat)&customer_long=\(log)&api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            if json.isEmpty {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupLocationChekerDetails(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup Location cheker details
    func setupLocationChekerDetails(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if (!jsonDictionary.isEmpty) {
            
            UserDefaultOperations.setDictionaryObject(ConstantStrings.LOCATION_DATA, jsonDictionary)
            
            var countryName = String()
            var countryCode = String()
            var postalCode = String()
            var fullAddress = String()
            var currencyCode = String()
            var cityName = String()
            var defaultLanguage = String()
            var latitude = String()
            var longitude = String()
            var locality = String()
            
            if jsonDictionary[JSONKey.CUSTOMER_COUNTRY_NAME] as? String != nil {
                countryName = jsonDictionary[JSONKey.CUSTOMER_COUNTRY_NAME] as! String
            }
            if jsonDictionary[JSONKey.CUSTOMER_COUNTRY_CODE] as? String != nil {
                countryCode = jsonDictionary[JSONKey.CUSTOMER_COUNTRY_CODE] as! String
            }
            if jsonDictionary[JSONKey.CUSTOMER_POST_CODE] as? String != nil {
                postalCode = jsonDictionary[JSONKey.CUSTOMER_POST_CODE] as! String
            }
            if jsonDictionary[JSONKey.CUSTOMER_FULL_ADDRESS] as? String != nil {
                fullAddress = jsonDictionary[JSONKey.CUSTOMER_FULL_ADDRESS] as! String
            }
            if jsonDictionary[JSONKey.CUSTOMER_CURRENCY] as? String != nil {
                currencyCode = jsonDictionary[JSONKey.CUSTOMER_CURRENCY] as! String
            }
            if jsonDictionary[JSONKey.CUSTOMER_DEFAULT_LANGUAGE] as? String != nil {
                let languageCode = jsonDictionary[JSONKey.CUSTOMER_DEFAULT_LANGUAGE] as! String
                defaultLanguage = jsonDictionary[JSONKey.CUSTOMER_DEFAULT_LANGUAGE] as! String
                WebApi.LANGUAGE_CODE = languageCode
            }
            if jsonDictionary[JSONKey.CUSTOMER_CITY] as? String != nil {
                cityName = jsonDictionary[JSONKey.CUSTOMER_CITY] as! String
            }
            if jsonDictionary[JSONKey.CUSTOMER_LATITUDE] as? String != nil {
                latitude = jsonDictionary[JSONKey.CUSTOMER_LATITUDE] as! String
            }
            if jsonDictionary[JSONKey.CUSTOMER_LONGITUDE] as? String != nil {
                longitude = jsonDictionary[JSONKey.CUSTOMER_LONGITUDE] as! String
            }
            if jsonDictionary[JSONKey.CUSTOMER_LOCALITY] as? String != nil {
                locality = jsonDictionary[JSONKey.CUSTOMER_LOCALITY] as! String
            }
            if jsonDictionary[JSONKey.API_KEY] as? String != nil {
                let apiKey = jsonDictionary[JSONKey.API_KEY] as! String
                WebApi.API_KEY = apiKey
            }
            if jsonDictionary["customer_min_distance"] as? String != nil {
                let minDistance = jsonDictionary["customer_min_distance"] as! String
                if Double(minDistance) != nil {
                    ConstantStrings.CUSTOMER_MIN_DISTANCE = Double(minDistance)!
                }else {
                    ConstantStrings.CUSTOMER_MIN_DISTANCE = 10
                }
            }
            let currencySymbol = currencyCode.currencySymbol
            UserDefaultOperations.setStringObject(ConstantStrings.COUNTRY_CODE, currencyCode)
            appCurrencySymbol = currencySymbol
            
            let locationInfo = UserLocationInfo.init(locality: locality, countryName: countryName, countryCode: countryCode, postalCode: postalCode, fullAddress: fullAddress, currencySymbol: currencySymbol, currencyCode: currencyCode, cityName: cityName, defaultLanguage: defaultLanguage, latitude: latitude, longitude: longitude, apiKey : WebApi.API_KEY)
            UserDefaultOperations.setStoredObject(ConstantStrings.USER_LOCATION_INFO, locationInfo)
            self.setupSplashImage()
            self.webApiGetStripePaymentPublishKey()
            self.webApiHomeSliderImage()
            self.webApiHomeCategoryList()
            self.webApiRestaurantInformation()
            self.webApiSplashScreenImages()
            self.webApiGetRestaurantBranches()
            self.webApiGetLanguageData()
        }
    }
    
//    Get Home Slider Image list
    func webApiHomeSliderImage() -> Void {
        
        let url = WebApi.BASE_URL + "phpexpert_home_slider.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupHomeSliderImage(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup Home slider image
    func setupHomeSliderImage(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if (!jsonDictionary.isEmpty) {
            
            UserDefaultOperations.setDictionaryObject(ConstantStrings.HOME_SLIDER_IMAGE, jsonDictionary)
        }
    }
    
//    Get Home Category list
    func webApiHomeCategoryList() -> Void {
        
        let url = WebApi.BASE_URL + "phpexpert_restaurantMenuCategory.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupHomeCategoryList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup Home Category List
    func setupHomeCategoryList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if (!jsonDictionary.isEmpty) {
            
            UserDefaultOperations.setDictionaryObject(ConstantStrings.CATEGORY_LIST, jsonDictionary)
            
            if jsonDictionary[JSONKey.MENU_CATEGORY_LIST] as? Array<Dictionary<String, Any>> != nil {
                
                let arrayCategoryList = jsonDictionary[JSONKey.MENU_CATEGORY_LIST] as! Array<Dictionary<String, Any>>
                for categoryData in arrayCategoryList {
                    
                    if categoryData["id"] as? Int != nil {
                        
                        self.webApiHomeCategoryItemList(categoryData[JSONKey.CATEGORY_ID] as! Int)
                        break
                    }
                }
            }
        }
    }
    
//    Get Home Category Item list
    func webApiHomeCategoryItemList(_ categoryID : Int) -> Void {
        
        let url = WebApi.BASE_URL + "phpexpert_food_items.php?Category_ID=\(categoryID)&api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupCategoryItemList(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup Home Category item List
    func setupCategoryItemList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if (!jsonDictionary.isEmpty) {
            
            UserDefaultOperations.setDictionaryObject(ConstantStrings.RECOMMENDED_DATA, jsonDictionary)
        }
    }
    
//    Get Restaurant Information
    func webApiRestaurantInformation() -> Void {
        
        let url = WebApi.BASE_URL + "phpexpert_restaurant_information.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupRestaurantInformation(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Setup Restaurant Information
    func setupRestaurantInformation(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if (!jsonDictionary.isEmpty) {
            
            UserDefaultOperations.setDictionaryObject(ConstantStrings.RESTAURANT_INFORMATION, jsonDictionary)
            
            var cityName = String()
            var restaurantId = String()
            var restaurantName = String()
            var currencySymbol = String()
            var isDineAvailable = Bool()
            var isPickupAvailable = Bool()
            var isHomeDeliveryAvailable = Bool()
            var rating = String()
            var logoImageUrl = String()
            var coverImageUrl = String()
            var address = String()
            var about = String()
            var latitude = String()
            var longitude = String()
            var contactNumber = String()
            var contactEmail = String()
            var isTableBookSupport = Bool()
            var isLoyaltyPointEnable = Bool()
            var isCashOnDeliveryAvailable = Bool()
            var isOnlinePaymentAvailable = Bool()
            var isPaylater = Bool()
            
            if jsonDictionary[JSONKey.RESTAURANT_NAME] as? String != nil {
                
                restaurantName = jsonDictionary[JSONKey.RESTAURANT_NAME] as! String
            }
            if jsonDictionary[JSONKey.RESTAURANT_ID] as? Int != nil {
                
                restaurantId = String(jsonDictionary[JSONKey.RESTAURANT_ID] as! Int)
            }
            if jsonDictionary[JSONKey.RESTAURANT_CURRENCY_SYMBOL] as? String != nil {
                
                currencySymbol = jsonDictionary[JSONKey.RESTAURANT_CURRENCY_SYMBOL] as! String
            }
            if jsonDictionary[JSONKey.RESTAURANT_HOME_DELIVERY_AVAILABLE] as? String != nil {
                
                if jsonDictionary[JSONKey.RESTAURANT_HOME_DELIVERY_AVAILABLE] as! String == ConstantStrings.TRUE_STRING {
                    
                    isHomeDeliveryAvailable = true
                }
            }
            if jsonDictionary[JSONKey.RESTAURANT_PICKUP_AVAILABLE] as? String != nil {
                
                if jsonDictionary[JSONKey.RESTAURANT_PICKUP_AVAILABLE] as! String == ConstantStrings.TRUE_STRING {
                    
                    isPickupAvailable = true
                }
            }
            if jsonDictionary[JSONKey.RESTAURANT_DINING_AVAILABLE] as? String != nil {
                
                if jsonDictionary[JSONKey.RESTAURANT_DINING_AVAILABLE] as! String == ConstantStrings.TRUE_STRING {
                    
                    isDineAvailable = true
                }
            }
            if jsonDictionary[JSONKey.RESTAURANT_TABLE_BOOKING_AVAILABLE] as? String != nil {
                
                if jsonDictionary[JSONKey.RESTAURANT_TABLE_BOOKING_AVAILABLE] as! String == ConstantStrings.TRUE_STRING {
                    
                    isTableBookSupport = true
                }
            }
            if jsonDictionary[JSONKey.RESTAURANT_CASH_ON_DELIVERY_AVAILABLE] as? String != nil {
                
                if jsonDictionary[JSONKey.RESTAURANT_CASH_ON_DELIVERY_AVAILABLE] as! String == ConstantStrings.TRUE_STRING {
                    
                    isCashOnDeliveryAvailable = true
                }
            }
            if jsonDictionary[JSONKey.RESTAURANT_LOYALTY_POINT_AVAILABLE] as? String != nil {
                if jsonDictionary[JSONKey.RESTAURANT_LOYALTY_POINT_AVAILABLE] as! String == ConstantStrings.TRUE_STRING {
                    isLoyaltyPointEnable = true
                }
            }
            if jsonDictionary[JSONKey.RESTAURANT_ONLINE_PAYMENT_AVAILABLE] as? String != nil {
                if jsonDictionary[JSONKey.RESTAURANT_ONLINE_PAYMENT_AVAILABLE] as! String == ConstantStrings.TRUE_STRING {
                    isOnlinePaymentAvailable = true
                }
            }
            if jsonDictionary[JSONKey.RESTAURANT_PAYLATER_AVAILABLE] as? String != nil {
                if jsonDictionary[JSONKey.RESTAURANT_PAYLATER_AVAILABLE] as! String == ConstantStrings.TRUE_STRING {
                    isPaylater = true
                }
            }
            if jsonDictionary[JSONKey.RESTAURANT_CITY] as? String != nil {
                cityName = jsonDictionary[JSONKey.RESTAURANT_CITY] as! String
            }
            if jsonDictionary[JSONKey.RESTAURANT_ADDRESS] as? String != nil {
                address = jsonDictionary[JSONKey.RESTAURANT_ADDRESS] as! String
            }
            if jsonDictionary[JSONKey.RESTAURANT_ABOUT] as? String != nil {
                about = jsonDictionary[JSONKey.RESTAURANT_ABOUT] as! String
            }
            if jsonDictionary[JSONKey.RESTAURANT_LOGO_IMAGE_URL] as? String != nil {
                logoImageUrl = jsonDictionary[JSONKey.RESTAURANT_LOGO_IMAGE_URL] as! String
                logoImageUrl = logoImageUrl.replacingOccurrences(of: " ", with: "%20")
            }
            if jsonDictionary[JSONKey.RESTAURANT_COVER_IMAGE_URL] as? String != nil {
                coverImageUrl = jsonDictionary[JSONKey.RESTAURANT_COVER_IMAGE_URL] as! String
                coverImageUrl = coverImageUrl.replacingOccurrences(of: " ", with: "%20")
            }
            if jsonDictionary[JSONKey.RESTAURANT_CONTACT_NUMBER] as? String != nil {
                contactNumber = jsonDictionary[JSONKey.RESTAURANT_CONTACT_NUMBER] as! String
            }
            if jsonDictionary[JSONKey.RESTAURANT_CONTACT_EMAIL] as? String != nil {
                contactEmail = jsonDictionary[JSONKey.RESTAURANT_CONTACT_EMAIL] as! String
            }
            if jsonDictionary[JSONKey.RESTAURANT_LATITUDE] as? String != nil {
                latitude = jsonDictionary[JSONKey.RESTAURANT_LATITUDE] as! String
            }
            if jsonDictionary[JSONKey.RESTAURANT_LONGITUDE] as? String != nil {
                longitude = jsonDictionary[JSONKey.RESTAURANT_LONGITUDE] as! String
            }
            if jsonDictionary[JSONKey.RESTAURANT_RATING] as? String != nil {
                rating = jsonDictionary[JSONKey.RESTAURANT_RATING] as! String
            }
            
            let restaurantInfo = RestaurantInfo.init(restaurantId: restaurantId, restaurantName: restaurantName, isHomeDeliveryAvailable: isHomeDeliveryAvailable, isPickupAvailable: isPickupAvailable, isDineAvailable: isDineAvailable, currencySymbol: currencySymbol, cityName: cityName, logoImageUrl: logoImageUrl, coverImageUrl: coverImageUrl, rating: rating, latitude: latitude, longitude: longitude, about: about, address: address, contactNumber: contactNumber, contactEmail: contactEmail, isTableBookingAvailable: isTableBookSupport, isLoyaltyPointAvailable: isLoyaltyPointEnable, isCashOnDeliveryAvailable: isCashOnDeliveryAvailable, isOnlinePaymentAvailable: isOnlinePaymentAvailable, isPaylater : isPaylater)
            UserDefaultOperations.setStoredObject(ConstantStrings.RESTAURANT_INFO, restaurantInfo)
        }
    }
    
//    Get Home Slider Image list
    func webApiGetStripePaymentPublishKey() -> Void {
        
        let url = WebApi.BASE_URL + "phpexpert_payment_key.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupStripePaymentPublishKey(json.dictionaryObject!)
                }
            }
        }
    }
        
    //    Setup Home slider image
    func setupStripePaymentPublishKey(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        var paypalClient = String()
        var paypalSecret = String()
        if jsonDictionary["stripe_publishKey"] as? String != nil {
            
            let publishKey = jsonDictionary["stripe_publishKey"] as! String
            UserDefaultOperations.setStringObject(ConstantStrings.STRIPE_PAYMENT_PUBLISH_KEY, publishKey)
            Stripe.setDefaultPublishableKey(publishKey)
        }
        if jsonDictionary["paypal_client_ID"] as? String != nil {
            
            paypalClient = jsonDictionary["paypal_client_ID"] as! String
            UserDefaultOperations.setStringObject(ConstantStrings.PAYPAL_CLIENT_KEY, paypalClient)
        }
        if jsonDictionary["paypal_secret"] as? String != nil {
            
            paypalSecret = jsonDictionary["paypal_secret"] as! String
            UserDefaultOperations.setStringObject(ConstantStrings.PAYPAL_SECRET_KEY, paypalSecret)
        }
        PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: paypalClient, PayPalEnvironmentSandbox: paypalSecret])
    }
    
//    Get Splash Screen image
    func webApiSplashScreenImages() -> Void {
        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_restaurant_app_splash_gallery.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)&splash_type=0"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print("Splash Images Response : ", json)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupSplashScreenImageList(json.dictionaryObject!)
                }
            }
        }
    }
        
//    Setup Splash screen image list
    func setupSplashScreenImageList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary["SplashBannersList"] as? Array<Dictionary<String, Any>> != nil {

            let arraySplashImage = jsonDictionary["SplashBannersList"] as! Array<Dictionary<String, Any>>
            for splashScreen in arraySplashImage {

                var dictionaryScreen = Dictionary<String, String>()
                dictionaryScreen["id"] = (splashScreen["id"] as? Int != nil) ? String(splashScreen["id"] as! Int) : "0"
                dictionaryScreen["splash_banner_img"] = (splashScreen["splash_banner_img"] as? String != nil) ? String(splashScreen["splash_banner_img"] as! String) : "0"

//                var imageUrl = dictionaryScreen["splash_banner_img"]!
//                imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
//                if UIImage(url: URL(string: imageUrl)) != nil {
//                    self.arraySplashImage.append(UIImage(url: URL(string: imageUrl))!)
//                }
                if !dictionaryScreen.isEmpty {

                    self.arraySplashSreen.append(dictionaryScreen)
                }
            }
        }
        self.pageController.numberOfPages = self.arraySplashSreen.count
        self.pageController.pageIndicatorTintColor = Colors.colorWithHexString(Colors.LIGHT_ORANGE_COLOR)
        self.pageController.currentPageIndicatorTintColor = Colors.colorWithHexString(Colors.DARK_ORANGE_COLOR)
        self.collectionView.reloadData()
        if !self.isMovedOnHomePage {
            self.buttonSkip.isHidden = false
            self.startTimer()
        }
    }
    
//    Api for get branches
    func webApiGetRestaurantBranches() -> Void {
        
        let url = WebApi.BASE_URL + "phpexpert_get_restaurant_branch_list.php?lang_code=\(WebApi.LANGUAGE_CODE)&api_key=\(WebApi.API_KEY)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
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
        
        var arrayBranchList = Array<Dictionary<String, String>>()
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
                    arrayBranchList.append(dictionaryBranch)
                }
            }
        }
        UserDefaultOperations.setArrayObject(ConstantStrings.RESTAURANT_BRANCH_LIST, arrayBranchList)
    }
    
//    Api for get Multi Language Data
    func webApiGetLanguageData() -> Void {
        
        let url = WebApi.BASE_URL + "phpexpert_customer_app_langauge.php?lang_code=\(WebApi.LANGUAGE_CODE)&api_key=\(WebApi.API_KEY)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupLanguageJson(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupLanguageJson(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        if !jsonDictionary.isEmpty {
            UserDefaultOperations.setDictionaryObject(ConstantStrings.MULTI_LANGUAGE_JSON_DATA, jsonDictionary)
            self.appDelegate.languageData = jsonDictionary
             
            ConstantStrings.ALERT = (jsonDictionary["AlertText"] as? String != nil) ? (jsonDictionary["AlertText"] as! String) : ConstantStrings.ALERT
            ConstantStrings.INVALID = (jsonDictionary["InvalidText"] as? String != nil) ? (jsonDictionary["InvalidText"] as! String) : ConstantStrings.INVALID
            ConstantStrings.NETORK_ISSUE = (jsonDictionary["Network_Issue"] as? String != nil) ? (jsonDictionary["Network_Issue"] as! String) : ConstantStrings.NETORK_ISSUE
            ConstantStrings.ITEMS = (jsonDictionary["items"] as? String != nil) ? (jsonDictionary["items"] as! String) : ConstantStrings.ITEMS
            
            ConstantStrings.DATA_IS_NOT_AVAILABLE = (jsonDictionary["DATA_IS_NOT_AVAILABLE"] as? String != nil) ? (jsonDictionary["DATA_IS_NOT_AVAILABLE"] as! String) : ConstantStrings.DATA_IS_NOT_AVAILABLE
            ConstantStrings.FIRST_NAME_FIELD_IS_REQUIRED = (jsonDictionary["FIRST_NAME_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["FIRST_NAME_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.FIRST_NAME_FIELD_IS_REQUIRED
            ConstantStrings.USERNAME_FIELD_IS_REQUIRED = (jsonDictionary["USERNAME_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["USERNAME_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.USERNAME_FIELD_IS_REQUIRED
            ConstantStrings.PASSWORD_FIELD_IS_REQUIRED = (jsonDictionary["PASSWORD_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["PASSWORD_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.PASSWORD_FIELD_IS_REQUIRED
            ConstantStrings.MOBILE_NO_FIELD_IS_REQUIRED = (jsonDictionary["MOBILE_NO_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["MOBILE_NO_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.MOBILE_NO_FIELD_IS_REQUIRED
            ConstantStrings.MESSAGE_FIELD_IS_REQUIRED = (jsonDictionary["MESSAGE_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["MESSAGE_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.MESSAGE_FIELD_IS_REQUIRED
            ConstantStrings.EMAIL_FIELD_IS_REQUIRED = (jsonDictionary["EMAIL_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["EMAIL_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.EMAIL_FIELD_IS_REQUIRED
            ConstantStrings.PLEASE_ENTER_VALID_MOBILE = (jsonDictionary["PLEASE_ENTER_VALID_MOBILE"] as? String != nil) ? (jsonDictionary["PLEASE_ENTER_VALID_MOBILE"] as! String) : ConstantStrings.PLEASE_ENTER_VALID_MOBILE
            ConstantStrings.PLEASE_ENTER_VALID_EMAIL = (jsonDictionary["PLEASE_ENTER_VALID_EMAIL"] as? String != nil) ? (jsonDictionary["PLEASE_ENTER_VALID_EMAIL"] as! String) : ConstantStrings.PLEASE_ENTER_VALID_EMAIL
            ConstantStrings.ADDRESS_FIELD_IS_REQUIRED = (jsonDictionary["ADDRESS_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["ADDRESS_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.ADDRESS_FIELD_IS_REQUIRED
            ConstantStrings.DEVICE_DOES_NOT_SUPPORT_CAMERA = (jsonDictionary["DEVICE_DOES_NOT_SUPPORT_CAMERA"] as? String != nil) ? (jsonDictionary["DEVICE_DOES_NOT_SUPPORT_CAMERA"] as! String) : ConstantStrings.DEVICE_DOES_NOT_SUPPORT_CAMERA
            ConstantStrings.COULD_NOT_CONNECT_TO_SERVER = (jsonDictionary["COULD_NOT_CONNECT_TO_SERVER"] as? String != nil) ? (jsonDictionary["COULD_NOT_CONNECT_TO_SERVER"] as! String) : ConstantStrings.COULD_NOT_CONNECT_TO_SERVER
            ConstantStrings.FIRSTLY_PLEASE_ADD_INTO_CART = (jsonDictionary["FIRSTLY_PLEASE_ADD_INTO_CART"] as? String != nil) ? (jsonDictionary["FIRSTLY_PLEASE_ADD_INTO_CART"] as! String) : ConstantStrings.FIRSTLY_PLEASE_ADD_INTO_CART
            ConstantStrings.ITEM_HAS_BEEN_ADDED_INTO_CART = (jsonDictionary["ITEM_HAS_BEEN_ADDED_INTO_CART"] as? String != nil) ? (jsonDictionary["ITEM_HAS_BEEN_ADDED_INTO_CART"] as! String) : ConstantStrings.ITEM_HAS_BEEN_ADDED_INTO_CART
            ConstantStrings.SUCCESSFULLY_LOGGED_IN = (jsonDictionary["SUCCESSFULLY_LOGGED_IN"] as? String != nil) ? (jsonDictionary["SUCCESSFULLY_LOGGED_IN"] as! String) : ConstantStrings.SUCCESSFULLY_LOGGED_IN
            ConstantStrings.ADDRESS_TITLE_FIELD_IS_REQUIRED = (jsonDictionary["ADDRESS_TITLE_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["ADDRESS_TITLE_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.ADDRESS_TITLE_FIELD_IS_REQUIRED
            ConstantStrings.POSTAL_CODE_FIELD_IS_REQUIRED = (jsonDictionary["POSTAL_CODE_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["POSTAL_CODE_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.POSTAL_CODE_FIELD_IS_REQUIRED
            ConstantStrings.CITY_NAME_FIELD_IS_REQUIRED = (jsonDictionary["CITY_NAME_FIELD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["CITY_NAME_FIELD_IS_REQUIRED"] as! String) : ConstantStrings.CITY_NAME_FIELD_IS_REQUIRED
            ConstantStrings.PLEASE_ENTER_VALID_POSTAL_CODE = (jsonDictionary["PLEASE_ENTER_VALID_POSTAL_CODE"] as? String != nil) ? (jsonDictionary["PLEASE_ENTER_VALID_POSTAL_CODE"] as! String) : ConstantStrings.PLEASE_ENTER_VALID_POSTAL_CODE
            ConstantStrings.PLEASE_SELECT_ORDER_TYPE = (jsonDictionary["PLEASE_SELECT_ORDER_TYPE"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_ORDER_TYPE"] as! String) : ConstantStrings.PLEASE_SELECT_ORDER_TYPE
            ConstantStrings.APPLY_COUPON_IS_REQUIRED = (jsonDictionary["APPLY_COUPON_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["APPLY_COUPON_IS_REQUIRED"] as! String) : ConstantStrings.APPLY_COUPON_IS_REQUIRED
            ConstantStrings.YOUR_COUPON_HAS_BEEN_APPLIED_SUCCESSFULLY = (jsonDictionary["YOUR_COUPON_HAS_BEEN_APPLIED_SUCCESSFULLY"] as? String != nil) ? (jsonDictionary["YOUR_COUPON_HAS_BEEN_APPLIED_SUCCESSFULLY"] as! String) : ConstantStrings.YOUR_COUPON_HAS_BEEN_APPLIED_SUCCESSFULLY
            ConstantStrings.PLEASE_SELECT_ADDRESS = (jsonDictionary["PLEASE_SELECT_ADDRESS"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_ADDRESS"] as! String) : ConstantStrings.PLEASE_SELECT_ADDRESS
            ConstantStrings.PLEASE_SELECT_PAYMENT_MODE = (jsonDictionary["PLEASE_SELECT_PAYMENT_MODE"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_PAYMENT_MODE"] as! String) : ConstantStrings.PLEASE_SELECT_PAYMENT_MODE
            ConstantStrings.YOUR_CART_IS_EMPTY = (jsonDictionary["YOUR_CART_IS_EMPTY"] as? String != nil) ? (jsonDictionary["YOUR_CART_IS_EMPTY"] as! String) : ConstantStrings.YOUR_CART_IS_EMPTY
            ConstantStrings.NO_ORDER_YET = (jsonDictionary["NO_ORDER_YET"] as? String != nil) ? (jsonDictionary["NO_ORDER_YET"] as! String) : ConstantStrings.NO_ORDER_YET
            ConstantStrings.HOME_NUMBER_IS_REQUIRED = (jsonDictionary["HOME_NUMBER_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["HOME_NUMBER_IS_REQUIRED"] as! String) : ConstantStrings.HOME_NUMBER_IS_REQUIRED
            ConstantStrings.STREET_NAME_IS_REQUIRED = (jsonDictionary["STREET_NAME_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["STREET_NAME_IS_REQUIRED"] as! String) : ConstantStrings.STREET_NAME_IS_REQUIRED
            ConstantStrings.PLEASE_ENTER_VALID_POSTAL_CODE = (jsonDictionary["PLEASE_ENTER_VALID_POSTAL_CODE"] as? String != nil) ? (jsonDictionary["PLEASE_ENTER_VALID_POSTAL_CODE"] as! String) : ConstantStrings.PLEASE_ENTER_VALID_POSTAL_CODE
            ConstantStrings.PLEASE_LOGIN_FIRSTLY = (jsonDictionary["PLEASE_LOGIN_FIRSTLY"] as? String != nil) ? (jsonDictionary["PLEASE_LOGIN_FIRSTLY"] as! String) : ConstantStrings.PLEASE_LOGIN_FIRSTLY
            ConstantStrings.FLAT_NAME_IS_REQUIRED = (jsonDictionary["FLAT_NAME_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["FLAT_NAME_IS_REQUIRED"] as! String) : ConstantStrings.FLAT_NAME_IS_REQUIRED
            ConstantStrings.WRITE_REVIEW_IS_REQUIRED = (jsonDictionary["WRITE_REVIEW_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["WRITE_REVIEW_IS_REQUIRED"] as! String) : ConstantStrings.WRITE_REVIEW_IS_REQUIRED
            ConstantStrings.RATING_REVIEW_COULD_NOT_SUBMITTED = (jsonDictionary["RATING_REVIEW_COULD_NOT_SUBMITTED"] as? String != nil) ? (jsonDictionary["RATING_REVIEW_COULD_NOT_SUBMITTED"] as! String) : ConstantStrings.RATING_REVIEW_COULD_NOT_SUBMITTED
            ConstantStrings.OLD_PASSWORD_IS_REQUIRED = (jsonDictionary["OLD_PASSWORD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["OLD_PASSWORD_IS_REQUIRED"] as! String) : ConstantStrings.OLD_PASSWORD_IS_REQUIRED
            ConstantStrings.NEW_PASSWORD_IS_REQUIRED = (jsonDictionary["NEW_PASSWORD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["NEW_PASSWORD_IS_REQUIRED"] as! String) : ConstantStrings.NEW_PASSWORD_IS_REQUIRED
            ConstantStrings.RE_TYPE_PASSWORD_IS_REQUIRED = (jsonDictionary["RE_TYPE_PASSWORD_IS_REQUIRED"] as? String != nil) ? (jsonDictionary["RE_TYPE_PASSWORD_IS_REQUIRED"] as! String) : ConstantStrings.RE_TYPE_PASSWORD_IS_REQUIRED
            ConstantStrings.BOTH_PASSWORD_SHOULD_BE_SAME = (jsonDictionary["BOTH_PASSWORD_SHOULD_BE_SAME"] as? String != nil) ? (jsonDictionary["BOTH_PASSWORD_SHOULD_BE_SAME"] as! String) : ConstantStrings.BOTH_PASSWORD_SHOULD_BE_SAME
            ConstantStrings.YOU_HAVE_ZERO_LOYALTY_POINTS = (jsonDictionary["YOU_HAVE_ZERO_LOYALTY_POINTS"] as? String != nil) ? (jsonDictionary["YOU_HAVE_ZERO_LOYALTY_POINTS"] as! String) : ConstantStrings.YOU_HAVE_ZERO_LOYALTY_POINTS
            ConstantStrings.ARE_YOU_SURE_YOU_WANT_TO_LOGOUT = (jsonDictionary["ARE_YOU_SURE_YOU_WANT_TO_LOGOUT"] as? String != nil) ? (jsonDictionary["ARE_YOU_SURE_YOU_WANT_TO_LOGOUT"] as! String) : ConstantStrings.ARE_YOU_SURE_YOU_WANT_TO_LOGOUT
            ConstantStrings.PLEASE_CHOOSE_ONE_OPTION = (jsonDictionary["PLEASE_CHOOSE_ONE_OPTION"] as? String != nil) ? (jsonDictionary["PLEASE_CHOOSE_ONE_OPTION"] as! String) : ConstantStrings.PLEASE_CHOOSE_ONE_OPTION
            ConstantStrings.YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE = (jsonDictionary["PLEASE_LOGIN_FIRSTLY"] as? String != nil) ? (jsonDictionary["PLEASE_LOGIN_FIRSTLY"] as! String) : ConstantStrings.YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE
            ConstantStrings.LOYALTY_POINT_FIELD_IS_REQUIRED = (jsonDictionary["Enter_your_loyalty_points"] as? String != nil) ? (jsonDictionary["Enter_your_loyalty_points"] as! String) : ConstantStrings.LOYALTY_POINT_FIELD_IS_REQUIRED
            ConstantStrings.PLEASE_SELECT_PAYMENT_MODE = (jsonDictionary["PLEASE_SELECT_PAYMENT_MODE"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_PAYMENT_MODE"] as! String) : ConstantStrings.PLEASE_SELECT_PAYMENT_MODE
            ConstantStrings.GO_TO_MENU = (jsonDictionary["Go_to_Menu"] as? String != nil) ? (jsonDictionary["Go_to_Menu"] as! String) : ConstantStrings.GO_TO_MENU
            ConstantStrings.CONFIRM_DELIVERY_ADDRESS = (jsonDictionary["Confirm_Delivery_Address"] as? String != nil) ? (jsonDictionary["Confirm_Delivery_Address"] as! String) : ConstantStrings.CONFIRM_DELIVERY_ADDRESS
            ConstantStrings.CONFIRM_AND_PAY = (jsonDictionary["Confirm_and_Pay"] as? String != nil) ? (jsonDictionary["Confirm_and_Pay"] as! String) : ConstantStrings.CONFIRM_AND_PAY
            ConstantStrings.WRITE_A_REVIEW = (jsonDictionary["write_a_review"] as? String != nil) ? (jsonDictionary["write_a_review"] as! String) : ConstantStrings.WRITE_A_REVIEW
            ConstantStrings.CONTINUE_ORDER = (jsonDictionary["continue_order"] as? String != nil) ? (jsonDictionary["continue_order"] as! String) : ConstantStrings.CONTINUE_ORDER
            ConstantStrings.YOU_ARE_NOT_AVAILABLE_AT_ANY_BRANCH = (jsonDictionary["sorry_you_are_not_available_Text"] as? String != nil) ? (jsonDictionary["sorry_you_are_not_available_Text"] as! String) : ConstantStrings.YOU_ARE_NOT_AVAILABLE_AT_ANY_BRANCH
            ConstantStrings.CONTINUE_ORDER = (jsonDictionary["continue_order"] as? String != nil) ? (jsonDictionary["continue_order"] as! String) : ConstantStrings.CONTINUE_ORDER
            
            ConstantStrings.YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE = (jsonDictionary["YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE"] as? String != nil) ? (jsonDictionary["YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE"] as! String) : ConstantStrings.YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE
            ConstantStrings.NO_CORDINATES_AVAILABLE = (jsonDictionary["NO_CORDINATES_AVAILABLE"] as? String != nil) ? (jsonDictionary["NO_CORDINATES_AVAILABLE"] as! String) : ConstantStrings.NO_CORDINATES_AVAILABLE
            ConstantStrings.NO_PICTURE_UPLOADED_YET = (jsonDictionary["NO_PICTURE_UPLOADED_YET"] as? String != nil) ? (jsonDictionary["NO_PICTURE_UPLOADED_YET"] as! String) : ConstantStrings.NO_PICTURE_UPLOADED_YET
            ConstantStrings.NO_OFFER_AVAILABLE = (jsonDictionary["NO_OFFER_AVAILABLE"] as? String != nil) ? (jsonDictionary["NO_OFFER_AVAILABLE"] as! String) : ConstantStrings.NO_OFFER_AVAILABLE
            ConstantStrings.PLEASE_ENTER_MORE_THAN_POINTS = (jsonDictionary["PLEASE_ENTER_MORE_THAN_POINTS"] as? String != nil) ? (jsonDictionary["PLEASE_ENTER_MORE_THAN_POINTS"] as! String) : ConstantStrings.PLEASE_ENTER_MORE_THAN_POINTS
            ConstantStrings.YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS = (jsonDictionary["YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS"] as? String != nil) ? (jsonDictionary["YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS"] as! String) : ConstantStrings.YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS
            ConstantStrings.YOUR_ORDER_COULD_NOT_PLACED = (jsonDictionary["YOUR_ORDER_COULD_NOT_PLACED"] as? String != nil) ? (jsonDictionary["YOUR_ORDER_COULD_NOT_PLACED"] as! String) : ConstantStrings.YOUR_ORDER_COULD_NOT_PLACED
            ConstantStrings.PHONE_NUMBER = (jsonDictionary["Mobile_Number"] as? String != nil) ? (jsonDictionary["Mobile_Number"] as! String) : "Mobile Number"
            ConstantStrings.PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING = (jsonDictionary["PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING"] as? String != nil) ? (jsonDictionary["PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING"] as! String) : ConstantStrings.PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING
            ConstantStrings.NEW_ITEM_ADDED = (jsonDictionary["NEW_ITEM_ADDED"] as? String != nil) ? (jsonDictionary["NEW_ITEM_ADDED"] as! String) : ConstantStrings.NEW_ITEM_ADDED
            ConstantStrings.SEND_ORDER_TO_KITCHEN = (jsonDictionary["SEND_ORDER_TO_KITCHEN"] as? String != nil) ? (jsonDictionary["SEND_ORDER_TO_KITCHEN"] as! String) : ConstantStrings.SEND_ORDER_TO_KITCHEN
            ConstantStrings.YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW = (jsonDictionary["YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW"] as? String != nil) ? (jsonDictionary["YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW"] as! String) : ConstantStrings.YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW
            ConstantStrings.PLEASE_SELECT_OPTION = (jsonDictionary["PLEASE_SELECT_OPTION"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_OPTION"] as! String) : ConstantStrings.PLEASE_SELECT_OPTION
            
            ConstantStrings.ORDER_TYPE_DELIVERY_STRING = (jsonDictionary["Delivery"] as? String != nil) ? (jsonDictionary["Delivery"] as! String) : ConstantStrings.ORDER_TYPE_DELIVERY_STRING
            ConstantStrings.ORDER_TYPE_PICKUP_STRING = (jsonDictionary["Pickup"] as? String != nil) ? (jsonDictionary["Pickup"] as! String) : ConstantStrings.ORDER_TYPE_PICKUP_STRING
            ConstantStrings.ORDER_TYPE_DINING_STRING = (jsonDictionary["EAT_IN"] as? String != nil) ? (jsonDictionary["EAT_IN"] as! String) : ConstantStrings.ORDER_TYPE_DINING_STRING
            ConstantStrings.ORDER_STATUS_CANCELLED = (jsonDictionary["Cancelled"] as? String != nil) ? (jsonDictionary["Cancelled"] as! String) : ConstantStrings.ORDER_STATUS_CANCELLED
            ConstantStrings.PLEASE_SELECT_RESTAURANT_BRANCH = (jsonDictionary["PLEASE_SELECT_RESTAURANT_BRANCH"] as? String != nil) ? (jsonDictionary["PLEASE_SELECT_RESTAURANT_BRANCH"] as! String) : ConstantStrings.PLEASE_SELECT_RESTAURANT_BRANCH
            ConstantStrings.ARE_YOU_SURE_YOU_WANT_DELETE_ADDRESS = (jsonDictionary["ARE_YOU_SURE_YOU_WANT_DELETE_ADDRESS"] as? String != nil) ? (jsonDictionary["ARE_YOU_SURE_YOU_WANT_DELETE_ADDRESS"] as! String) : ConstantStrings.ARE_YOU_SURE_YOU_WANT_DELETE_ADDRESS
            
            ConstantStrings.CUSTOMER_NAME_IS_REQUIRED = (jsonDictionary["please_enter_customer_name"] as? String != nil) ? (jsonDictionary["please_enter_customer_name"] as! String) : ConstantStrings.CUSTOMER_NAME_IS_REQUIRED
            ConstantStrings.CUSTOMER_MOBILE_NUMBER_IS_REQUIRED = (jsonDictionary["please_enter_customer_mobile"] as? String != nil) ? (jsonDictionary["please_enter_customer_mobile"] as! String) : ConstantStrings.CUSTOMER_MOBILE_NUMBER_IS_REQUIRED
            ConstantStrings.BOOKING_TIME_IS_REQUIRED = (jsonDictionary["please_enter_booking_time"] as? String != nil) ? (jsonDictionary["please_enter_booking_time"] as! String) : ConstantStrings.BOOKING_TIME_IS_REQUIRED
            ConstantStrings.BOOKING_DATE_IS_REQUIRED = (jsonDictionary["please_enter_booting_date"] as? String != nil) ? (jsonDictionary["please_enter_booting_date"] as! String) : ConstantStrings.BOOKING_DATE_IS_REQUIRED
            ConstantStrings.PLEASE_SELECT_TABLE_NUMBER = (jsonDictionary["please_select_table"] as? String != nil) ? (jsonDictionary["please_select_table"] as! String) : ConstantStrings.PLEASE_SELECT_TABLE_NUMBER
            ConstantStrings.YOUR_ORDER_COUNT_NOT_CANCEL = (jsonDictionary["YOUR_ORDER_COUNT_NOT_CANCEL"] as? String != nil) ? (jsonDictionary["YOUR_ORDER_COUNT_NOT_CANCEL"] as! String) : ConstantStrings.YOUR_ORDER_COUNT_NOT_CANCEL
            ConstantStrings.WE_COULD_NOT_TRACK_ORDER = (jsonDictionary["WE_COULD_NOT_TRACK_ORDER"] as? String != nil) ? (jsonDictionary["WE_COULD_NOT_TRACK_ORDER"] as! String) : ConstantStrings.WE_COULD_NOT_TRACK_ORDER
            ConstantStrings.NO_ANY_COMPLAINT = (jsonDictionary["NO_ANY_COMPLAINT"] as? String != nil) ? (jsonDictionary["NO_ANY_COMPLAINT"] as! String) : ConstantStrings.NO_ANY_COMPLAINT
            ConstantStrings.SIZE_NOT_AVAILABLE = (jsonDictionary["SIZE_NOT_AVAILABLE"] as? String != nil) ? (jsonDictionary["SIZE_NOT_AVAILABLE"] as! String) : ConstantStrings.SIZE_NOT_AVAILABLE
            ConstantStrings.ORDER_SENT_TO_THE_KITCHEN = (jsonDictionary["Your_order_has_been_sent_to_kitchen_successfully"] as? String != nil) ? (jsonDictionary["Your_order_has_been_sent_to_kitchen_successfully"] as! String) : ConstantStrings.ORDER_SENT_TO_THE_KITCHEN
            
            ConstantStrings.CANCEL_STRING = (jsonDictionary["Cancel"] as? String != nil) ? (jsonDictionary["Cancel"] as! String) : ConstantStrings.CANCEL_STRING
            ConstantStrings.OK_STRING = (jsonDictionary["Ok"] as? String != nil) ? (jsonDictionary["Ok"] as! String) : ConstantStrings.OK_STRING
            
            ConstantStrings.YOUR_PROFILE_COULD_NOT_UPDATED = (jsonDictionary["YOUR_PROFILE_COULD_NOT_UPDATED"] as? String != nil) ? (jsonDictionary["YOUR_PROFILE_COULD_NOT_UPDATED"] as! String) : ConstantStrings.YOUR_PROFILE_COULD_NOT_UPDATED
        }
    }
}

import UIKit

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
