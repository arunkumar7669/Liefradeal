//
//  ServiceViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 04/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class ServiceViewController: BaseViewController {

    @IBOutlet weak var labelPickup: UILabel!
    @IBOutlet weak var labelDelivery: UILabel!
    @IBOutlet weak var labelNotes: UILabel!
    @IBOutlet weak var labelDetails: UILabel!
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
        
        self.navigationItem.title = "Services"
        
        self.setupBackBarButton()
        self.buttonGotoMenu.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
        self.view.backgroundColor = Colors.colorWithHexString(Colors.APP_BG_COLOR)
    }

    //    MARK:- Button Action
    @IBAction func buttonGotoMenuAction(_ sender: UIButton) {
        
        self.moveOnMenuPage()
    }
    
}
