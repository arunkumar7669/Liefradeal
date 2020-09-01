//
//  ThankyouTableViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 18/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class ThankyouTableViewController: BaseViewController {

    
//    @IBOutlet weak var labelThankYou: UILabel!
    @IBOutlet weak var labelSuccessfully: UILabel!
    @IBOutlet weak var labelBookingNumber: UILabel!
    @IBOutlet weak var labelTransactionNumber: UILabel!
    @IBOutlet weak var labelTableNumber: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var buttonBackToHome: UIButton!
    
    var BOOKING_NUMBER = "Your booking number is "
//    let TRANSACTION_NUMBER = "Transaction Number : "
    var TABLE_NUMBER = "Table Number : "
    var NOTE_STRING = "Note: "
    
    var thankyouString = String()
    var tableNumber = String()
    var tableName = String()
    var transactionNumber = String()
    var bookingNumber = String()
    var bookingDate = String()
    var bookingTime = String()
    var noteString = String()
    var bookingConfirmation = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Thank_You"] as? String != nil) ? (self.appDelegate.languageData["Thank_You"] as! String).trim() : "Thank You"
        self.navigationItem.title = (self.appDelegate.languageData["your_booking_confirmation_has_been_successfully_send_to_restaura"] as? String != nil) ? (self.appDelegate.languageData["your_booking_confirmation_has_been_successfully_send_to_restaura"] as! String).trim() : "Your booking confirmation has been successfully send to restaurant."
        let tableNumber = (self.appDelegate.languageData["Table_No"] as? String != nil) ? (self.appDelegate.languageData["Table_No"] as! String).trim() : "Table Number"
        
        let yourBookingNumber = (self.appDelegate.languageData["Your_booking_number"] as? String != nil) ? (self.appDelegate.languageData["Your_booking_number"] as! String).trim() : "Your booking number is"
        let noteString = (self.appDelegate.languageData["Note_string"] as? String != nil) ? (self.appDelegate.languageData["Note_string"] as! String).trim() : "Note"
        let buttonGotoHomeTitle = (self.appDelegate.languageData["GO_TO_HOME"] as? String != nil) ? (self.appDelegate.languageData["GO_TO_HOME"] as! String).trim() : "Go to Home"
        self.buttonBackToHome.setTitle(buttonGotoHomeTitle, for: .normal)
        self.BOOKING_NUMBER = yourBookingNumber + " "
        self.NOTE_STRING = noteString + " : "
        self.tableNumber = tableNumber + " : "
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        self.labelTransactionNumber.text = ""
        self.labelSuccessfully.text = self.bookingConfirmation
        self.labelNote.text = self.NOTE_STRING + self.noteString
        self.labelBookingNumber.text = self.BOOKING_NUMBER + self.bookingNumber
        self.labelTableNumber.text = self.TABLE_NUMBER + "\(self.tableNumber) at \(self.bookingDate) \(self.bookingTime)"
        
        self.labelBookingNumber.attributedText = self.changeSelectedStringColor(self.labelBookingNumber.text!, self.bookingNumber, Colors.colorWithHexString(Colors.GREEN_COLOR), 17.0)
        self.labelTransactionNumber.attributedText = self.changeSelectedStringColor(self.labelTransactionNumber.text!, self.transactionNumber, Colors.colorWithHexString(Colors.GREEN_COLOR), 17.0)
    }
    
//    MARK:- Button Action
    @IBAction func buttonBackToHomeAction(_ sender: UIButton) {
        
        let homeVC = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}
