//
//  TermsConditionViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 10/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class TermsConditionViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = (self.appDelegate.languageData["Terms_of_Services"] as? String != nil) ? (self.appDelegate.languageData["Terms_of_Services"] as! String).trim() : "Terms of Service"
        self.setupBackBarButton()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = WebApi.BASE_URL + "terms_of_use_web.php"
        let url = URL(string: urlString)
        self.webView.delegate = self
        self.webView.loadRequest(URLRequest(url: url!))
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("finish to load")
        
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
}
