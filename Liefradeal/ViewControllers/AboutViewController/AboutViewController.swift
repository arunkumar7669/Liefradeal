
//
//  AboutViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 03/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {

    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonGoToMenu: UIButton!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
//    var arrayAboutList = [["detail" : "Minimum Order", "amount" : "1.00", "selected" : "1"], ["detail" : "Delivery", "amount" : "30-40 mins &\nCollection 20 mins", "selected" : "0"], ["detail" : "Delivery areas", "amount" : "AL1,AL2,AL3,\nAL4 & AL10", "selected" : "0"], ["detail" : "Telephone Orders", "amount" : "01727 833900", "selected" : "0"]]
    var restaurantInfo = RestaurantInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        let height = self.tableView.contentSize.height
        self.heightTableView.constant = height
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST)
        self.setupCartButtonWithBadge(arrayCartItems.count)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Info"] as? String != nil) ? (self.appDelegate.languageData["Info"] as! String).trim() : "Info"
        self.buttonGoToMenu.setTitle(ConstantStrings.GO_TO_MENU, for: .normal)
        self.setupBackBarButton()
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        self.setupTableViewDelegateAndDatasource()
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) != nil {
            
            self.restaurantInfo = UserDefaultOperations.getStoredObject(ConstantStrings.RESTAURANT_INFO) as! RestaurantInfo
        }
        
        self.imageViewLogo.sd_setImage(with: URL(string: self.restaurantInfo.logoImageUrl), placeholderImage: UIImage(named: ""))
        self.labelTitle.text = self.restaurantInfo.address
        self.labelDescription.text = self.restaurantInfo.about
    }
    
    //    Setup tableView Delegate And datasource
    func setupTableViewDelegateAndDatasource() -> Void {
        
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 40
    }
    
    //    MARK:- UITableView Delegate And Datasource
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return self.arrayAboutList.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = Bundle.main.loadNibNamed("MenuDetailsTableViewCell", owner: self, options: nil)?.first as! MenuDetailsTableViewCell
//        cell.selectionStyle = .none
//        cell.contentView.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
//
//        let dictionary = self.arrayAboutList[indexPath.row]
//
//        if Int(dictionary["selected"]!) == 1 {
//
//            cell.imageViewSelection.image = UIImage.init(named: ConstantStrings.SELECTED_RADIO_BUTTON)
//        }else {
//
//            cell.imageViewSelection.image = UIImage.init(named: ConstantStrings.UNSELECTED_RADIO_BUTTON)
//        }
//        cell.labelPrice.text = ConstantStrings.RUPEES_SYMBOL + dictionary["amount"]!
//        cell.labelMenuDetail.text = dictionary["detail"]
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        var dictionary = self.arrayAboutList[indexPath.row]
//
//        if Int(dictionary["selected"]!) == 0 {
//
//            for i in 0..<self.arrayAboutList.count {
//
//                var dicDetails = self.arrayAboutList[i]
//                dicDetails["selected"] = "0"
//                self.arrayAboutList[i] = dicDetails
//            }
//
//            dictionary["selected"] = "1"
//            self.arrayAboutList[indexPath.row] = dictionary
//            self.tableView.reloadData()
//        }
//    }
    
    //    MARK:- Button Action
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
        self.moveOnMenuPage()
    }
    
    
}
