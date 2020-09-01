//
//  UserDefaultOperations.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 03/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class UserDefaultOperations: NSObject {

//    Setter/Getter Method for String
    static func setStringObject(_ keyForValue : String, _ userType : String) {
        
        UserDefaults.standard.set(userType, forKey: keyForValue)
    }
    
    static func getStringObject(_ keyForValue : String) -> String {
        
        
        if UserDefaults.standard.string(forKey: keyForValue) == nil {
            
            return ""
        }else{
            
            return UserDefaults.standard.string(forKey: keyForValue)!
        }
    }

//    Setter/Getter Method for Bool
    static func setBoolObject(_ keyForValue : String, _ isUserLogin : Bool) {
        
        UserDefaults.standard.set(isUserLogin, forKey: keyForValue)
    }
    
    static func getBoolObject(_ keyForValue : String) -> Bool {
        
        return UserDefaults.standard.bool(forKey: keyForValue)
    }
    
//    Setter/Getter Method for Int
    static func setIntValue(_ keyForValue : String, _ intValue : Int) {
        
        UserDefaults.standard.set(intValue, forKey: keyForValue)
    }
    
    static func getIntValue(_ keyForValue : String) -> Int {
        
        return UserDefaults.standard.integer(forKey: keyForValue)
    }
    
//    Setter/Getter Method for Array
    static func setArrayObject(_ keyForValue : String, _ arrayObject : Array<Any>) {
        
        UserDefaults.standard.set(arrayObject, forKey: keyForValue)
    }
    
    static func getArrayObject(_ arrayObject : String) -> Array<Any> {
        
        if UserDefaults.standard.array(forKey: arrayObject) == nil {
            
            return Array<Any>()
        }else {
            
            return UserDefaults.standard.array(forKey: arrayObject)!
        }
    }
    
//    Setter/Getter Method for Dictionary
    static func setDictionaryObject(_ keyForValue : String, _ dictionaryObject : Dictionary<String, Any>) {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: dictionaryObject)
        UserDefaults.standard.set(data, forKey: keyForValue)
    }
    
    static func getDictionaryObject(_ keyForValue : String) -> Dictionary<String, Any> {
        
        let outData = UserDefaults.standard.data(forKey: keyForValue)
        
        if outData == nil {
            
            return Dictionary<String,Any>()
        }else {
            
            let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! Dictionary<String, Any>
            return dict
        }
    }
    
//    Setter/Getter Method for NSObject
    static func setStoredObject(_ keyForValue : String, _ object : Any) {
        
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: object)
        userDefaults.set(encodedData, forKey: keyForValue)
        userDefaults.synchronize()
    }
    
    static func getStoredObject(_ keyForValue : String) -> Any? {
        
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: keyForValue)
        
        if decoded == nil {
            
            return nil
        }else {
            
            return NSKeyedUnarchiver.unarchiveObject(with: decoded!)
        }
    }
}
