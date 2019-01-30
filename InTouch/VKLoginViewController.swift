//
//  VKLoginViewController.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 22.12.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import WebKit

class VKLoginViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NetworkingService().authorizeRequest()
        print(request)
        webView.load(request)
    }
}

extension VKLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        print(params)
        
        guard let token = params["access_token"], let userId = Int(params["user_id"] ?? "") else {
            decisionHandler(.cancel)
            return
        }
        
        print(token, userId)
        
        Session.instance.token = token
        Session.instance.userId = userId

        decisionHandler(.cancel)
        performSegue(withIdentifier: "VKLogin", sender: self)
    }
}
