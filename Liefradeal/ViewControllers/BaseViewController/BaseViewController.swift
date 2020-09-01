//
//  BaseViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import CoreLocation

class BaseViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        for hide the navigation bar border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
//        For set the navigation title font
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        self.changeStatusBarColor()
    }
    
//    Setup Back Bar Button
    func setupBackBarButton() -> Void {
        
        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(buttonBackBarAction(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
//    Back Bar Button Action
    @objc func buttonBackBarAction(_ sender : UIButton) -> Void {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func changeStatusBarColor() -> Void {
        if #available(iOS 13.0, *) {
           let app = UIApplication.shared
           let statusBarHeight: CGFloat = app.statusBarFrame.size.height

           let statusbarView = UIView()
            statusbarView.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
           view.addSubview(statusbarView)
           statusbarView.translatesAutoresizingMaskIntoConstraints = false
           statusbarView.heightAnchor
             .constraint(equalToConstant: statusBarHeight).isActive = true
           statusbarView.widthAnchor
             .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
           statusbarView.topAnchor
             .constraint(equalTo: view.topAnchor).isActive = true
           statusbarView.centerXAnchor
             .constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
              let statusBar = UIApplication.shared.value(forKeyPath:
           "statusBarWindow.statusBar") as? UIView
              statusBar?.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
        }
    }
    
//    Setup some values before logout
    func setupValuesBeforeLogout() -> Void {
        
        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS, "")
        UserDefaultOperations.setBoolObject(ConstantStrings.IS_COUPON_APPLIED, false)
        UserDefaultOperations.setBoolObject(ConstantStrings.IS_LOYALTY_POINTS_REDEEMED, false)
        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_COUPON_CODE, "")
        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_COUPON_AMOUNT, "")
        UserDefaultOperations.setStringObject(ConstantStrings.APPLIED_LOYALTY_POINTS_AMOUNT, "")
        UserDefaultOperations.setStringObject(ConstantStrings.LOYALTY_POINTS, "")
        UserDefaultOperations.setArrayObject(ConstantStrings.CART_ITEM_LIST, Array<Any>())
        UserDefaultOperations.setBoolObject(ConstantStrings.IS_USER_LOGGED_IN, false)
        UserDefaultOperations.setStringObject(ConstantStrings.SEND_ORDER_KITCHEN_ID, "")
        UserDefaultOperations.setArrayObject(ConstantStrings.SEND_ORDER_KITCHEN_LIST, Array<Any>())
        let userDetails = UserDetails.init()
        UserDefaultOperations.setStoredObject(ConstantStrings.USER_DETAILS, userDetails)
    }
    
//    get distance between two latitude and longitude cordinates
    func isAvailableInRestaurant(_ lat1 : Double, _ long1 : Double,_ lat2 : Double, _ long2 : Double) -> Bool {
        
        let coordinate₀ = CLLocation(latitude: lat1, longitude: long1)
        let coordinate₁ = CLLocation(latitude: lat2, longitude: long2)
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        
        if distanceInMeters >= ConstantStrings.CUSTOMER_MIN_DISTANCE {
            return true
        }else {
            return false
        }
    }
    
    //    Convert time 24 hours to AM/PM
    func convertTimeTo24Hours(_ time : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "h:mm a"
        let convertedTime = dateFormatter.string(from: date!)
        
        return convertedTime
    }
    
    //    Setup cart and cart value
    func setupCartButtonWithBadge(_ cartItemCount : Int) {
        
        let bagButton = CartButton()
        bagButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        bagButton.tintColor = UIColor.white
        bagButton.setImage(UIImage(named: "cart")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        bagButton.badge = "\(cartItemCount)"
        bagButton.addTarget(self, action: #selector(self.buttonCartClickAction(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bagButton)
    }
    
    //    Button cart action
    @objc func buttonCartClickAction(_ sender : UIButton) -> Void {
        
        let cartVC = CartViewController.init(nibName: "CartViewController", bundle: nil)
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    func createGradientLayer(_ view : UIView) {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [Colors.colorWithHexString(Colors.GRADIANT_LIGHT).cgColor, Colors.colorWithHexString(Colors.GRADIANT_DARK).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
//    Setup Drawer Controller
    func setupDrawerController() -> Void {
        
        let dashboardVC = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
        let mainViewController = UINavigationController.init(rootViewController: dashboardVC)
        mainViewController.viewWillAppear(true)
        
        let drawerVC = DrawerViewController.init(nibName: "DrawerViewController", bundle: nil)
        let drawerViewController = UINavigationController.init(rootViewController: drawerVC)
        
        if self.screenWidth == 320 {
            
            self.appDelegate.drawerController.drawerWidth = 270
        }else {
            
            self.appDelegate.drawerController.drawerWidth = 300
        }
        self.appDelegate.drawerController.screenEdgePanGestureEnabled = false
        self.appDelegate.drawerController.mainViewController = mainViewController
        self.appDelegate.drawerController.drawerViewController = drawerViewController
        self.appDelegate.window?.rootViewController = self.appDelegate.drawerController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
//    Setup Login Controller
    func setupLoginController() -> Void {
        
        let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
        let mainViewController = UINavigationController.init(rootViewController: loginVC)
        
        self.appDelegate.window?.rootViewController = mainViewController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
//    Setup Signup Controller
    func setupSignupController() -> Void {
        
        let loginVC = SignupViewController.init(nibName: "SignupViewController", bundle: nil)
        let mainViewController = UINavigationController.init(rootViewController: loginVC)
        
        self.appDelegate.window?.rootViewController = mainViewController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    //    Setup Back Bar Button
    func setupDrawerButton() -> Void {
        
        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(self.buttonDrawerAction(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func buttonDrawerAction(_ sender : UIButton) -> Void {
        
        self.appDelegate.drawerController.setDrawerState(.opened, animated: true)
    }
    
//    On click go to menu Move on Menu Page
    func moveOnMenuPage() -> Void {
        let navigationController = self.appDelegate.drawerController.mainViewController as! UINavigationController
        let homeVC = navigationController.viewControllers.first as! HomeViewController
        
        let menuVC = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
        menuVC.arrayMenuList = homeVC.arrayCategory
        menuVC.arrayMenuItems = homeVC.arrayDefaultCategoryMenuItems
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    
    //    MARK:- Show Alert With Message
    func showAlertWithMessage(_ title : String, _ message : String) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction.init(title: ConstantStrings.OK_STRING, style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //    MARK:- Show Alert With Message
    func showAlertWithPopupViewController(_ title : String, _ message : String) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction.init(title: ConstantStrings.OK_STRING, style: .default) { (action) in
            
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
//    Show View toast
    func showToastWithMessage(_ view : UIView, _ message : String) -> Void {
        
        let windows = UIApplication.shared.windows
        windows.last?.hideAllToasts()
        windows.last?.makeToast(message)
    }
    
    //    Generate 6 digit random number for send otp
    func generate4DigitsRandomNumber(_ digitNumber: Int) -> String {
        
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
    
//    Func change the selected string color
    func changeSelectedStringColor(_ string : String, _ subString : String, _ color : UIColor, _ fontSize : CGFloat) -> NSMutableAttributedString {
        
        let strNumber: NSString = string as NSString
        let range = (strNumber).range(of: subString)
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize, weight: .regular), range: range)
        
        return attribute
    }
}

extension String {
    
    func trim() -> String {
        
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var currencySymbol: String { return Currency.shared.findSymbol(currencyCode: self) }
}
