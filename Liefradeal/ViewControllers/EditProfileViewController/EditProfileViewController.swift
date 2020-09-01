//
//  EditProfileViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 04/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import RPFloatingPlaceholders

protocol ProfileUpdatedDelegate : class {
    
    func setupProfileDetails()
}

class EditProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var textFieldFirstName: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldLastName: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldHouseNo: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldFlatName: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldStreetName: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldPostalCode: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldCityName: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldMobileNumber: RPFloatingPlaceholderTextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var isImageUploaded = Bool()
    var userDetails = UserDetails()
    let imagePicker = UIImagePickerController()
    weak var delegate : ProfileUpdatedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = "Edit Profile"
        self.navigationItem.title = (self.appDelegate.languageData["Edit_Profile"] as? String != nil) ? (self.appDelegate.languageData["Edit_Profile"] as! String).trim() : "Edit Profile"
        let flatNamePlaceholder = (self.appDelegate.languageData["Flat_Name"] as? String != nil) ? (self.appDelegate.languageData["Flat_Name"] as! String).trim() : "Flat Name"
        let streetNamePlaceholder = (self.appDelegate.languageData["Street_Name"] as? String != nil) ? (self.appDelegate.languageData["Street_Name"] as! String).trim() : "Street Name"
        let PostCodePlaceholder = (self.appDelegate.languageData["Postal_Code"] as? String != nil) ? (self.appDelegate.languageData["Postal_Code"] as! String).trim() : "Postcode"
        let cityPlaceholder = (self.appDelegate.languageData["City_Name"] as? String != nil) ? (self.appDelegate.languageData["City_Name"] as! String).trim() : "City Name"
        let phoneNumberPlaceholder = (self.appDelegate.languageData["Mobile_No"] as? String != nil) ? (self.appDelegate.languageData["Mobile_No"] as! String).trim() : "Mobile Number"
        
        let firstNamePlaceholder = (self.appDelegate.languageData["First_Name"] as? String != nil) ? (self.appDelegate.languageData["First_Name"] as! String).trim() : "First Name"
        let lastNamePlaceholder = (self.appDelegate.languageData["Last_Name"] as? String != nil) ? (self.appDelegate.languageData["Last_Name"] as! String).trim() : "Last Name"
        let houseNoPlaceholder = (self.appDelegate.languageData["House_No"] as? String != nil) ? (self.appDelegate.languageData["House_No"] as! String).trim() : "House No."
        let buttonSubmitTitle = (self.appDelegate.languageData["Submit"] as? String != nil) ? (self.appDelegate.languageData["Submit"] as! String).trim() : "Submit"
        self.buttonSubmit.setTitle(buttonSubmitTitle, for: .normal)
        
        self.textFieldFirstName.placeholder = firstNamePlaceholder
        self.textFieldLastName.placeholder = lastNamePlaceholder
        self.textFieldFlatName.placeholder = flatNamePlaceholder
        self.textFieldHouseNo.placeholder = houseNoPlaceholder
        self.textFieldStreetName.placeholder = streetNamePlaceholder
        self.textFieldPostalCode.placeholder = PostCodePlaceholder
        self.textFieldCityName.placeholder = cityPlaceholder
        self.textFieldMobileNumber.placeholder = phoneNumberPlaceholder
        
        
        self.setupBackBarButton()
        UtilityMethods.changeImageColor(self.imageViewUser, .lightGray)
        UtilityMethods.addBorderAndShadow(self.buttonSubmit, self.buttonSubmit.bounds.height / 2)
        
        if UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as? UserDetails != nil {
            
            self.userDetails = UserDefaultOperations.getStoredObject(ConstantStrings.USER_DETAILS) as! UserDetails
        }
        self.textFieldFirstName.text = (self.userDetails.userFirstName == "") ? "" : self.userDetails.userFirstName
        self.textFieldLastName.text = (self.userDetails.userLastName == "") ? "" : self.userDetails.userLastName
        self.textFieldFlatName.text = (self.userDetails.userFlatName == "") ? "" : self.userDetails.userFlatName
        self.textFieldStreetName.text = (self.userDetails.userStreetName == "") ? "" : self.userDetails.userStreetName
        self.textFieldHouseNo.text = (self.userDetails.userHouseNumber == "") ? "" : self.userDetails.userHouseNumber
        self.textFieldCityName.text = (self.userDetails.userCityName == "") ? "" : self.userDetails.userCityName
        self.textFieldMobileNumber.text = (self.userDetails.userPhone == "") ? "" : self.userDetails.userPhone
        self.textFieldPostalCode.text = (self.userDetails.postalCode == "") ? "" : self.userDetails.postalCode
        self.imageViewUser.sd_setImage(with: URL(string: self.userDetails.userPhotoUrl), placeholderImage: UIImage(named: "profile_pic"))
        
        self.imageViewUser.layer.cornerRadius = self.imageViewUser.bounds.height / 2
        self.imageViewUser.layer.masksToBounds = true
    }
    
    //    MARK:- Button Action
//    Button Action for submit edit Profile
    @IBAction func buttonEditProfileSubmitAction(_ sender: UIButton) {
        
        if self.checkValidatation() {
            
            self.webApiEditUserProfile()
        }
    }
    
    @IBAction func buttonUserImageChangeClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.handleCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default , handler:{ (UIAlertAction)in
            self.handlePhotGallery()
        }))
        
        alert.addAction(UIAlertAction(title: ConstantStrings.CANCEL_STRING, style: .cancel, handler:{ (UIAlertAction)in}))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func handleCamera() -> Void {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DEVICE_DOES_NOT_SUPPORT_CAMERA)
        }
    }
    
    func handlePhotGallery() -> Void {
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //    UIImage Picker Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
          self.imageViewUser.image = chosenImage
            self.isImageUploaded = true
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func checkValidatation() -> Bool {
        
        self.view.endEditing(true)
        if self.textFieldFirstName.text!.isEmpty {
            self.textFieldFirstName.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.FIRST_NAME_FIELD_IS_REQUIRED)
            return false
        }
        if self.textFieldCityName.text!.isEmpty {
            self.textFieldCityName.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.CITY_NAME_FIELD_IS_REQUIRED)
            return false
        }
        if self.textFieldMobileNumber.text!.isEmpty {
            self.textFieldMobileNumber.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.MOBILE_NO_FIELD_IS_REQUIRED)
            return false
        }
        if self.textFieldMobileNumber.text!.count > 14 {
            self.textFieldMobileNumber.becomeFirstResponder()
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.PLEASE_ENTER_VALID_MOBILE)
            return false
        }
        return true
    }
    
    //    MARK:- Web Api Code Start
//    Web Api for Edit Profile
    func webApiEditUserProfile() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_profite_update.php"
        let parameters = self.setupParamsDictionary()
        var imageData : Data?
        if self.isImageUploaded {
            imageData = self.imageViewUser.image!.jpegData(compressionQuality: 0.5)!
        }else {
            imageData = nil
        }
        
        WebApi.webApiFormDataRequestWithImage(url, imageData, parameters) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.stringValue.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    let dictionary = json.stringValue.convertToDictionary()
                    self.setupEditProfileData(dictionary!)
                }
            }
        }
    }
    
    var successMessage = String()
//    Func setup edit profile data
    func setupEditProfileData(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
            if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 1 {
                if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                    self.successMessage = jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String
                }
                self.webApiGetUserDetails(self.userDetails.userID)
            }else {
                self.showToastWithMessage(self.view, ConstantStrings.YOUR_PROFILE_COULD_NOT_UPDATED)
            }
        }
    }
    
    func setupParamsDictionary() -> Dictionary<String, String> {

        let postalCode = (!self.textFieldPostalCode.text!.isEmpty) ? (self.textFieldPostalCode.text!) : ""
        let flatName = (!self.textFieldFlatName.text!.isEmpty) ? (self.textFieldFlatName.text!) : ""
        let streetName = (!self.textFieldStreetName.text!.isEmpty) ? (self.textFieldStreetName.text!) : ""
        let lastName = (!self.textFieldLastName.text!.isEmpty) ? (self.textFieldLastName.text!) : ""
        let houseNumber = (!self.textFieldHouseNo.text!.isEmpty) ? (self.textFieldHouseNo.text!) : ""

        let parameters = ["api_key" : WebApi.API_KEY, "lang_code" : WebApi.LANGUAGE_CODE, "CustomerId" : self.userDetails.userID, "CustomerFirstName" : self.textFieldFirstName.text!, "CustomerLastName" : lastName, "CustomerPhone" : self.textFieldMobileNumber.text!, "customerFloor_House_Number" : houseNumber, "customerFlat_Name" : flatName, "customerStreet" : streetName, "customerZipcode" : postalCode, "customerCity" : self.textFieldCityName.text!]
        
        return parameters
    }
    
    func webApiGetUserDetails(_ userID : String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_customer_profile_inform.php?CustomerId=\(userID)"
        
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        WebApi.webApiForGetRequest(updatedUrl) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json["error"] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupExistingUserDetails(json.dictionaryObject!)
                }
            }
        }
    }
    
    //    func for setup user details
    func setupExistingUserDetails(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.ERROR_CODE] as? Int != nil {
            
            if jsonDictionary[JSONKey.ERROR_CODE] as! Int != 0 {
                
                if jsonDictionary[JSONKey.ERROR_MESSAGE] as? String != nil {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, jsonDictionary[JSONKey.ERROR_MESSAGE] as! String)
                }
            }
        }else {
            
            if jsonDictionary[JSONKey.SUCCESS_CODE] as? Int != nil {
                
                if jsonDictionary[JSONKey.SUCCESS_CODE] as! Int == 0 {
                    
                    if jsonDictionary[JSONKey.CUSTOMER_ID] as? String != nil {
                        
                        let userID = jsonDictionary[JSONKey.CUSTOMER_ID] as! String
                        var userName = String()
                        var userEmail = String()
                        var userPhone = String()
                        var userAddress = String()
                        var userFirstName = String()
                        var userLastName = String()
                        var userPostalCode = String()
                        var userPhotoUrl = String()
                        var userFlatName = String()
                        var userStreetName = String()
                        var userHouseNumber = String()
                        var userCityName = String()
                        
                        if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                            isFirstTimeOnHomePage = true
                            firstMessage = ConstantStrings.SUCCESSFULLY_LOGGED_IN
                        }
                        
                        if jsonDictionary[JSONKey.USER_NAME] as? String != nil {
                            userName = jsonDictionary[JSONKey.USER_NAME] as! String
                        }
                        if jsonDictionary[JSONKey.USER_EMAIL] as? String != nil {
                            userEmail = jsonDictionary[JSONKey.USER_EMAIL] as! String
                        }
                        if jsonDictionary[JSONKey.USER_PHONE] as? String != nil {
                            userPhone = jsonDictionary[JSONKey.USER_PHONE] as! String
                        }
                        if jsonDictionary[JSONKey.USER_PROFILE_ADDRESS] as? String != nil {
                            userAddress = jsonDictionary[JSONKey.USER_PROFILE_ADDRESS] as! String
                        }
                        if jsonDictionary[JSONKey.USER_POSTALCODE] as? String != nil {
                            userPostalCode = jsonDictionary[JSONKey.USER_POSTALCODE] as! String
                        }
                        if jsonDictionary[JSONKey.USER_FIRST_NAME] as? String != nil {
                            userFirstName = jsonDictionary[JSONKey.USER_FIRST_NAME] as! String
                        }
                        if jsonDictionary[JSONKey.USER_LAST_NAME] as? String != nil {
                            userLastName = jsonDictionary[JSONKey.USER_LAST_NAME] as! String
                        }
                        if jsonDictionary[JSONKey.USER_PHOTO_URL] as? String != nil {
                            userPhotoUrl = jsonDictionary[JSONKey.USER_PHOTO_URL] as! String
                            userPhotoUrl = userPhotoUrl.replacingOccurrences(of: " ", with: "%20")
                        }
                        if jsonDictionary[JSONKey.USER_FLAT_NAME] as? String != nil {
                            userFlatName = jsonDictionary[JSONKey.USER_FLAT_NAME] as! String
                        }
                        if jsonDictionary[JSONKey.USER_STREET_NAME] as? String != nil {
                            userStreetName = jsonDictionary[JSONKey.USER_STREET_NAME] as! String
                        }
                        if jsonDictionary[JSONKey.USER_HOUSE_NUMBER] as? String != nil {
                            userHouseNumber = jsonDictionary[JSONKey.USER_HOUSE_NUMBER] as! String
                        }
                        if jsonDictionary[JSONKey.USER_CITY_NAME] as? String != nil {
                            userCityName = jsonDictionary[JSONKey.USER_CITY_NAME] as! String
                        }
                        
                        let userInfo = UserDetails.init(userID: userID, userName: userName, userEmail: userEmail, userPhone: userPhone, userAddress: userAddress, postalCode: userPostalCode, userPhotoUrl: userPhotoUrl, userFirstName: userFirstName, userLastName: userLastName, userFlatName: userFlatName, userStreetName: userStreetName, userHouseNumber: userHouseNumber, userCityName: userCityName)
                        UserDefaultOperations.setStoredObject(ConstantStrings.USER_DETAILS, userInfo)
                        self.delegate?.setupProfileDetails()
                        self.showToastWithMessage(self.view, self.successMessage)
                    }
                }else {
                    
                    if jsonDictionary[JSONKey.SUCCESS_MESSAGE] as? String != nil {
                        
                        self.showToastWithMessage(self.view, jsonDictionary[JSONKey.SUCCESS_MESSAGE] as! String)
                    }
                }
            }
        }
    }
}


extension String {
    
    func convertToDictionary() -> [String: Any]? {
        
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
