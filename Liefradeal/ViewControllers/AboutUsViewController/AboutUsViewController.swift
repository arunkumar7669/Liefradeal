//
//  AboutUsViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 02/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class AboutUsViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIWebViewDelegate {

    @IBOutlet weak var collectionViewSlider: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelDeliveryRange: UILabel!
    @IBOutlet weak var labelDistance1: UILabel!
    @IBOutlet weak var labelDistance2: UILabel!
    @IBOutlet weak var labelDistance3: UILabel!
    @IBOutlet weak var labelDistance4: UILabel!
    @IBOutlet weak var labelPrice1: UILabel!
    @IBOutlet weak var labelPrice2: UILabel!
    @IBOutlet weak var labelPrice3: UILabel!
    @IBOutlet weak var labelPrice4: UILabel!
    @IBOutlet weak var labelMinimumOrder: UILabel!
    @IBOutlet weak var labelMinimumOrderPrice: UILabel!
    @IBOutlet weak var labelTableBooking: UILabel!
    @IBOutlet weak var labelDineIn: UILabel!
    @IBOutlet weak var buttonGotoMenu: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    var restaurantInfo = RestaurantInfo()
    let SLIDER_CELL = "SliderCell"
    var arraySlider = ["slider", "slider", "slider"]
    
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
        
        self.navigationItem.title = (self.appDelegate.languageData["About_Us"] as? String != nil) ? (self.appDelegate.languageData["About_Us"] as! String).trim() : "About Us"
        
        self.setupBackBarButton()
        self.buttonGotoMenu.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.pageControl.numberOfPages = self.arraySlider.count
        self.pageControl.currentPageIndicatorTintColor = Colors.colorWithHexString(Colors.RED_COLOR)
        self.collectionViewSlider.backgroundColor = .clear
        self.collectionViewSlider.delegate = self
        self.collectionViewSlider.dataSource = self
        self.collectionViewSlider.register(UINib.init(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.SLIDER_CELL)
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as? RestaurantInfo != nil {
            
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
            self.labelName.text = self.restaurantInfo.restaurantName
            self.labelDescription.text = self.restaurantInfo.about
        }
        
        self.setupWebView()
    }
    
    func setupWebView() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = WebApi.BASE_URL + "about_us_web.php"
        let url = URL(string: urlString)
        self.webView.delegate = self
        self.webView.loadRequest(URLRequest(url: url!))
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("finish to load")
        
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    //    Setup stroke in page control
    func setupPageControlStrokeBorder(_ indexPath : IndexPath) -> Void {
        
        for index in 0..<self.arraySlider.count{ // your array.count
            
            let viewDot = self.pageControl.subviews[index]
            viewDot.layer.borderWidth = 0.5
            viewDot.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            if (index == indexPath.row){ // indexPath is the current indexPath of your selected cell or view in the collectionView i.e which needs to be highlighted
                viewDot.backgroundColor = Colors.colorWithHexString(Colors.RED_COLOR)
                viewDot.layer.borderColor = Colors.colorWithHexString(Colors.LIGHT_GRAY_COLOR).cgColor
            }
            else{
                viewDot.backgroundColor = UIColor.white
                viewDot.layer.borderColor = UIColor.black.cgColor
                
            }
        }
    }
    
    //    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arraySlider.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return self.setupSliderCell(collectionView, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        return CGSize.init(width: self.collectionViewSlider.bounds.width, height: self.collectionViewSlider.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        self.setupPageControlStrokeBorder(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth = self.collectionViewSlider.frame.size.width
        let currentPage = Int(self.collectionViewSlider.contentOffset.x / pageWidth)
        
        self.pageControl.currentPage = currentPage
        self.setupPageControlStrokeBorder(IndexPath.init(row: currentPage, section: 0))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    //    MARK:- Setup Cell And method
    //    Setup Cell for slider collection view
    func setupSliderCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> SliderCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.SLIDER_CELL, for: indexPath) as! SliderCollectionViewCell
        cell.imageViewSlider.image = UIImage.init(named: arraySlider[indexPath.row])
        
        return cell
    }
    
    //    MARK:- Button Action
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
        self.moveOnMenuPage()
    }
}
