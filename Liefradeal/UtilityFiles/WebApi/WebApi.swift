//
//  WebApi.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 10/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WebApi: NSObject {
    
    static var API_KEY = ""
    static var LANGUAGE_CODE = ""
    static let BASE_URL = "https://www.dmd.foodsdemo.com/restaurantAPI/"

    //    Request for Post data
    static func webApiForPostRequest(_ url : String, _ parameters : Dictionary<String, String>, completion: @escaping (_ JSON: JSON)->()) {
        
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        Alamofire.request(updatedUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                completion(swiftyJsonVar)
            }else{
                let json:JSON = [:]
                completion(json)
            }
        }
    }
    
    //    Request for Get data
    static func webApiForGetRequest(_ url : String, completion: @escaping (_ JSON: JSON)->()) {
        
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        Alamofire.request(updatedUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    completion(swiftyJsonVar)
                }else{
                    let json:JSON = [:]
                    completion(json)
                }
        }
    }
    
    //    Request for Upload Image
    static func webApiFormDataRequestWithImage(_ url : String, _ imageData : Data?, _ params : Dictionary<String, String>, completion: @escaping (_ JSON: JSON)->()) {
        
        Alamofire.upload(multipartFormData: { (form) in
            if imageData != nil {
                form.append(imageData!, withName: "user_photo", fileName: "user_photo", mimeType: "image/jpg")
            }
            
            for (key, value) in params {
                print("key is - \(key) and value is - \(value)")
                
                form.append(value.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
            }
            
        }, to: url, encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseString { response in
                    
                    if response.result.value != nil {
                        
                        let swiftyJsonVar = JSON(response.result.value!)
                        completion(swiftyJsonVar)
                    }else {
                        
                        let json:JSON = [:]
                        completion(json)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                let json:JSON = [:]
                completion(json)
            }
        })
    }
}
