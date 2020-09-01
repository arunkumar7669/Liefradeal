//
//  UserLocationInfo.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 11/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class UserLocationInfo: NSObject, NSCoding {
    
    var locality: String
    var countryName: String
    var countryCode: String
    var postalCode: String
    var fullAddress : String
    var currencySymbol : String
    var cityName : String
    var defaultLanguage : String
    var latitude : String
    var longitude : String
    var apiKey : String
    var currencyCode : String
    
    override init() {
        
        self.locality = String()
        self.countryName = String()
        self.countryCode = String()
        self.postalCode = String()
        self.fullAddress = String()
        self.currencySymbol = String()
        self.cityName = String()
        self.defaultLanguage = String()
        self.latitude = String()
        self.longitude = String()
        self.apiKey = String()
        self.currencyCode = String()
    }
    
    init(locality : String, countryName: String, countryCode: String, postalCode: String, fullAddress : String, currencySymbol : String, currencyCode: String, cityName : String, defaultLanguage : String, latitude : String, longitude : String, apiKey : String) {
        
        self.locality = locality
        self.countryName = countryName
        self.countryCode = countryCode
        self.postalCode = postalCode
        self.fullAddress = fullAddress
        self.currencySymbol = currencySymbol
        self.cityName = cityName
        self.defaultLanguage = defaultLanguage
        self.latitude = latitude
        self.longitude = longitude
        self.apiKey = apiKey
        self.currencyCode = currencyCode
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let locality = aDecoder.decodeObject(forKey: "locality") as! String
        let countryName = aDecoder.decodeObject(forKey: "countryName") as! String
        let countryCode = aDecoder.decodeObject(forKey: "countryCode") as! String
        let postalCode = aDecoder.decodeObject(forKey: "postalCode") as! String
        let fullAddress = aDecoder.decodeObject(forKey: "fullAddress") as! String
        let currencySymbol = aDecoder.decodeObject(forKey: "currencySymbol") as! String
        let cityName = aDecoder.decodeObject(forKey: "cityName") as! String
        let defaultLanguage = aDecoder.decodeObject(forKey: "defaultLanguage") as! String
        let latitude = aDecoder.decodeObject(forKey: "latitude") as! String
        let longitude = aDecoder.decodeObject(forKey: "longitude") as! String
        let apiKey = aDecoder.decodeObject(forKey: "apiKey") as! String
        let currencyCode = aDecoder.decodeObject(forKey: "currencyCode") as! String
        
        self.init(locality : locality, countryName: countryName, countryCode: countryCode, postalCode : postalCode, fullAddress : fullAddress, currencySymbol : currencySymbol, currencyCode : currencyCode, cityName : cityName, defaultLanguage : defaultLanguage, latitude : latitude, longitude : longitude, apiKey : apiKey)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(locality, forKey: "locality")
        aCoder.encode(countryName, forKey: "countryName")
        aCoder.encode(countryCode, forKey: "countryCode")
        aCoder.encode(postalCode, forKey: "postalCode")
        aCoder.encode(fullAddress, forKey: "fullAddress")
        aCoder.encode(currencySymbol, forKey: "currencySymbol")
        aCoder.encode(cityName, forKey: "cityName")
        aCoder.encode(defaultLanguage, forKey: "defaultLanguage")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(apiKey, forKey: "apiKey")
        aCoder.encode(apiKey, forKey: "currencyCode")
    }
}



//"customer_city" = "";
//"customer_country" = "";
//"customer_country_code" = "";
//"customer_currency" = USD;
//"customer_default_langauge" = en;
//"customer_full_address" = "";
//"customer_lat" = 232343234234;
//"customer_locality" = "";
//"customer_long" = 42334234234;
//"customer_postcode" = "";
//"customer_search" = "city_with_locaity";
//"customer_search_display" = 2;
//"customer_search_text" = "Search for area, street name/postcode..";
//success = 0;
