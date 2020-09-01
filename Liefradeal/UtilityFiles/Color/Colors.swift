//
//  Colors.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class Colors: NSObject {

    
//    static let GREEN_COLOR = "#02BF67"
    static let GREEN_COLOR = "#277FED"
    static let BLACK_COLOR = "#000000"
    static let APP_COLOR = "#7CCB4F"
    
    static let LIGHT_GRAY_COLOR = "#D3D3D3"
    static let DARK_GRAY_COLOR = "#434343"
    
    static let LIGHT_ORANGE_COLOR = "#FCC76D"
    static let DARK_ORANGE_COLOR = "#F69B00"
    
    static let GRADIANT_LIGHT = "#01b863"
    static let GRADIANT_DARK = "#016c3a"
    
//    static let APP_BG_COLOR = "#FCFCFC"
    static let APP_BG_COLOR = "#FFFFFF"
//    static let TEXTFIELD_COLOR = "#F2F3F7"
    static let TEXTFIELD_COLOR = "#f7f7fa"
    
    static let RED_COLOR = "#E30613"
    static let RED_DISABLE_COLOR = "#CD5C5C"
    
    static let PRIMARY_COLOR = "#E30613"
    static let PRIMARY_DARK = "#ca0511"
    
    //    Convert the hex string in UIColor
    static func colorWithHexString(_ hexString : String) -> UIColor {
        
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        return UIColor.init(red:red, green:green, blue:blue, alpha:1.0)
    }
}
