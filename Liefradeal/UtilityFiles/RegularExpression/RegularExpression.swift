//
//  RegularExpression.swift
//  Book My Task
//
//  Created by Arun Kumar Rathore on 02/12/18.
//  Copyright © 2018 Arun Kumar Rathore. All rights reserved.
//

import UIKit

class RegularExpression: NSObject {

    static func regularExpressionPatterForValidation(_ regex : String, _ text : String) -> Int {
        
        let regularexp = try! NSRegularExpression.init(pattern: regex, options: .caseInsensitive)
        let numberOfMatches = regularexp.numberOfMatches(in: text, options: .anchored, range: NSMakeRange(0, text.count))
        
        return numberOfMatches
    }
    
//    validate name
    static func validateName(_ name : String) -> Bool {
        
        var matchName = Int()
        
        if name == "" {
            
            return false
        }else{
            
            matchName = regularExpressionPatterForValidation("^(([\\sA-Za-z0-9]+)\\s?[\\sA-Za-z0-9]+\\s?)+$", name)
            if (matchName == 0){
                
                return false
            }
        }
        
        return true
    }
    
//    Validate email id
    static func validateEmail(_ email : String) -> Bool {
        
        var matchName = Int()
        
        if email == "" {
            
            return false
        }else{
            
            matchName = regularExpressionPatterForValidation("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$", email)
            if (matchName == 0){
                
                return false
            }
        }
        
        return true
    }
    
//    Validate Mobile no
    static func validateMobileNo(_ mobileNo : String) -> Bool {
        
        var matchName = Int()
        
        if mobileNo == "" {
            
            return false
        }else{
            
            matchName = regularExpressionPatterForValidation("^[2-9]{2}[0-9]{8}$", mobileNo)
            if (matchName == 0){
                
                return false
            }
        }
        
        return true
    }
}
