//
//  UserDetails.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 16/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class UserDetails: NSObject, NSCoding {
    
    var userID: String
    var userName: String
    var userEmail: String
    var userPhone: String
    var userAddress: String
    var postalCode: String
    var userPhotoUrl: String
    var userFirstName: String
    var userLastName: String
    
    var userFlatName: String
    var userStreetName: String
    var userHouseNumber: String
    var userCityName: String
    
    override init() {
        
        self.userID = String()
        self.userName = String()
        self.userEmail = String()
        self.userPhone = String()
        self.userAddress = String()
        self.postalCode = String()
        self.userPhotoUrl = String()
        self.userFirstName = String()
        self.userLastName = String()
        self.userFlatName = String()
        self.userStreetName = String()
        self.userHouseNumber = String()
        self.userCityName = String()
    }
    
    init(userID : String, userName: String, userEmail: String, userPhone: String, userAddress: String, postalCode: String, userPhotoUrl: String, userFirstName: String, userLastName: String, userFlatName: String, userStreetName: String, userHouseNumber: String, userCityName: String) {
        
        self.userID = userID
        self.userName = userName
        self.userEmail = userEmail
        self.userPhone = userPhone
        self.userAddress = userAddress
        self.postalCode = postalCode
        self.userPhotoUrl = userPhotoUrl
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.userFlatName = userFlatName
        self.userStreetName = userStreetName
        self.userHouseNumber = userHouseNumber
        self.userCityName = userCityName
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let userID = aDecoder.decodeObject(forKey: "userID") as! String
        let userName = aDecoder.decodeObject(forKey: "userName") as! String
        let userEmail = aDecoder.decodeObject(forKey: "userEmail") as! String
        let userPhone = aDecoder.decodeObject(forKey: "userPhone") as! String
        let userAddress = aDecoder.decodeObject(forKey: "userAddress") as! String
        let postalCode = aDecoder.decodeObject(forKey: "postalCode") as! String
        let userPhotoUrl = aDecoder.decodeObject(forKey: "userPhotoUrl") as! String
        let userFirstName = aDecoder.decodeObject(forKey: "userFirstName") as! String
        let userLastName = aDecoder.decodeObject(forKey: "userLastName") as! String
        
        let userFlatName = aDecoder.decodeObject(forKey: "userFlatName") as! String
        let userStreetName = aDecoder.decodeObject(forKey: "userStreetName") as! String
        let userHouseNumber = aDecoder.decodeObject(forKey: "userHouseNumber") as! String
        let userCityName = aDecoder.decodeObject(forKey: "userCityName") as! String
        
        self.init(userID: userID, userName: userName, userEmail: userEmail, userPhone: userPhone, userAddress: userAddress, postalCode: postalCode, userPhotoUrl: userPhotoUrl, userFirstName: userFirstName, userLastName: userLastName, userFlatName: userFlatName, userStreetName: userStreetName, userHouseNumber: userHouseNumber, userCityName: userCityName)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(userID, forKey: "userID")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(userEmail, forKey: "userEmail")
        aCoder.encode(userPhone, forKey: "userPhone")
        aCoder.encode(userAddress, forKey: "userAddress")
        aCoder.encode(postalCode, forKey: "postalCode")
        aCoder.encode(userPhotoUrl, forKey: "userPhotoUrl")
        aCoder.encode(userFirstName, forKey: "userFirstName")
        aCoder.encode(userLastName, forKey: "userLastName")
        aCoder.encode(userFlatName, forKey: "userFlatName")
        aCoder.encode(userStreetName, forKey: "userStreetName")
        aCoder.encode(userHouseNumber, forKey: "userHouseNumber")
        aCoder.encode(userCityName, forKey: "userCityName")
    }
}
