//
//  RestaurantInfo.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 11/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class RestaurantInfo: NSObject, NSCoding {
    
    var restaurantId: String
    var restaurantName: String
    var isHomeDeliveryAvailable: Bool
    var isPickupAvailable: Bool
    var isDineAvailable : Bool
    var currencySymbol : String
    var cityName : String
    var logoImageUrl : String
    var coverImageUrl : String
    var rating : String
    var latitude : String
    var longitude : String
    var about : String
    var address : String
    var contactNumber : String
    var contactEmail : String
    var isTableBookingAvailable : Bool
    var isLoyaltyPointAvailable : Bool
    var isCashOnDeliveryAvailable : Bool
    var isOnlinePaymentAvailable : Bool
    var isPaylater : Bool
    
    override init() {
        
        self.restaurantId = String()
        self.restaurantName = String()
        self.isHomeDeliveryAvailable = Bool()
        self.isPickupAvailable = Bool()
        self.isDineAvailable = Bool()
        self.currencySymbol = String()
        self.cityName = String()
        self.logoImageUrl = String()
        self.coverImageUrl = String()
        self.rating = String()
        self.latitude = String()
        self.longitude = String()
        self.about = String()
        self.address = String()
        self.contactNumber = String()
        self.contactEmail = String()
        self.isTableBookingAvailable = Bool()
        self.isLoyaltyPointAvailable = Bool()
        self.isCashOnDeliveryAvailable = Bool()
        self.isOnlinePaymentAvailable = Bool()
        self.isPaylater = Bool()
    }
    
    init(restaurantId : String, restaurantName: String, isHomeDeliveryAvailable: Bool, isPickupAvailable: Bool, isDineAvailable : Bool, currencySymbol : String, cityName : String, logoImageUrl : String, coverImageUrl : String, rating : String, latitude : String, longitude : String, about : String, address : String, contactNumber : String, contactEmail : String, isTableBookingAvailable : Bool, isLoyaltyPointAvailable : Bool, isCashOnDeliveryAvailable : Bool, isOnlinePaymentAvailable : Bool, isPaylater : Bool) {
        
        self.restaurantId = restaurantId
        self.restaurantName = restaurantName
        self.isHomeDeliveryAvailable = isHomeDeliveryAvailable
        self.isPickupAvailable = isPickupAvailable
        self.isDineAvailable = isDineAvailable
        self.currencySymbol = currencySymbol
        self.cityName = cityName
        self.logoImageUrl = logoImageUrl
        self.coverImageUrl = coverImageUrl
        self.rating = rating
        self.latitude = latitude
        self.longitude = longitude
        self.about = about
        self.address = address
        self.contactNumber = contactNumber
        self.contactEmail = contactEmail
        self.isTableBookingAvailable = isTableBookingAvailable
        self.isLoyaltyPointAvailable = isLoyaltyPointAvailable
        self.isCashOnDeliveryAvailable = isCashOnDeliveryAvailable
        self.isOnlinePaymentAvailable = isOnlinePaymentAvailable
        self.isPaylater = isPaylater
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let restaurantId = aDecoder.decodeObject(forKey: "restaurantId") as! String
        let restaurantName = aDecoder.decodeObject(forKey: "restaurantName") as! String
        let isHomeDeliveryAvailable = aDecoder.decodeBool(forKey: "isHomeDeliveryAvailable")
        let isPickupAvailable = aDecoder.decodeBool(forKey: "isPickupAvailable")
        let isDineAvailable = aDecoder.decodeBool(forKey: "isDineAvailable")
        let currencySymbol = aDecoder.decodeObject(forKey: "currencySymbol") as! String
        let cityName = aDecoder.decodeObject(forKey: "cityName") as! String
        let logoImageUrl = aDecoder.decodeObject(forKey: "logoImageUrl") as! String
        let coverImageUrl = aDecoder.decodeObject(forKey: "coverImageUrl") as! String
        let rating = aDecoder.decodeObject(forKey: "rating") as! String
        let latitude = aDecoder.decodeObject(forKey: "latitude") as! String
        let longitude = aDecoder.decodeObject(forKey: "longitude") as! String
        let about = aDecoder.decodeObject(forKey: "about") as! String
        let address = aDecoder.decodeObject(forKey: "address") as! String
        let contactNumber = aDecoder.decodeObject(forKey: "contactNumber") as! String
        let contactEmail = aDecoder.decodeObject(forKey: "contactEmail") as! String
        let isTableBookingAvailable = aDecoder.decodeBool(forKey: "isTableBookingAvailable")
        let isLoyaltyPointAvailable = aDecoder.decodeBool(forKey: "isLoyaltyPointAvailable")
        let isCashOnDeliveryAvailable = aDecoder.decodeBool(forKey: "isCashOnDeliveryAvailable")
        let isOnlinePaymentAvailable = aDecoder.decodeBool(forKey: "isOnlinePaymentAvailable")
        let isPaylater = aDecoder.decodeBool(forKey: "isPaylater")
        
        self.init(restaurantId: restaurantId, restaurantName: restaurantName, isHomeDeliveryAvailable: isHomeDeliveryAvailable, isPickupAvailable: isPickupAvailable, isDineAvailable: isDineAvailable, currencySymbol: currencySymbol, cityName: cityName, logoImageUrl: logoImageUrl, coverImageUrl: coverImageUrl, rating: rating, latitude: latitude, longitude: longitude, about: about, address: address, contactNumber: contactNumber, contactEmail: contactEmail, isTableBookingAvailable : isTableBookingAvailable, isLoyaltyPointAvailable : isLoyaltyPointAvailable, isCashOnDeliveryAvailable : isCashOnDeliveryAvailable, isOnlinePaymentAvailable : isOnlinePaymentAvailable, isPaylater : isPaylater)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(restaurantId, forKey: "restaurantId")
        aCoder.encode(restaurantName, forKey: "restaurantName")
        aCoder.encode(isHomeDeliveryAvailable, forKey: "isHomeDeliveryAvailable")
        aCoder.encode(isPickupAvailable, forKey: "isPickupAvailable")
        aCoder.encode(isDineAvailable, forKey: "isDineAvailable")
        aCoder.encode(currencySymbol, forKey: "currencySymbol")
        aCoder.encode(cityName, forKey: "cityName")
        aCoder.encode(logoImageUrl, forKey: "logoImageUrl")
        aCoder.encode(coverImageUrl, forKey: "coverImageUrl")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(about, forKey: "about")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(contactNumber, forKey: "contactNumber")
        aCoder.encode(contactEmail, forKey: "contactEmail")
        aCoder.encode(isTableBookingAvailable, forKey: "isTableBookingAvailable")
        aCoder.encode(isLoyaltyPointAvailable, forKey: "isLoyaltyPointAvailable")
        aCoder.encode(isCashOnDeliveryAvailable, forKey: "isCashOnDeliveryAvailable")
        aCoder.encode(isOnlinePaymentAvailable, forKey: "isOnlinePaymentAvailable")
        aCoder.encode(isPaylater, forKey: "isPaylater")
    }
}
