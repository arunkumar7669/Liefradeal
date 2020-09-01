//
//  PrivacyPolicyViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 10/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class PrivacyPolicyViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
//        self.navigationItem.title = "Privacy Policy"
        self.navigationItem.title = (self.appDelegate.languageData["b"] as? String != nil) ? (self.appDelegate.languageData["Privacy_Policy"] as! String).trim() : "Privacy & Policy"
        self.setupBackBarButton()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = WebApi.BASE_URL + "privacy_statement_web.php"
        let url = URL(string: urlString)
        self.webView.delegate = self
        self.webView.loadRequest(URLRequest(url: url!))
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
