//
//  LoginWebViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/3.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import WebKit
import UIKit
import Alamofire
import NVActivityIndicatorView

let GITHUB_ACCESS_KEY = "Github_Access_Key"

var ACCESS_KEY:String?{
    get{
        return UserDefaults.standard.string(forKey: GITHUB_ACCESS_KEY)
    }
    set{
        UserDataService.shared.setDefaultRealmForUser(accessToken: newValue ?? "")
    }
}

class LoginWebViewController: UIViewController,NVActivityIndicatorViewable{
    @IBOutlet weak var webView: WKWebView!
    
    let clientKey = "deef4e3710d4c1666bcb"
    
    let clientSecret = "db652ec4a4f7c6dd252f4172d3babe3c58ee8dc2"
    
    let authorizationEndPoint = "https://github.com/login/oauth/authorize"
    
    let accessTokenEndPoint = "https://github.com/login/oauth/access_token"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        startAuthorization()
    }
    
    func startAuthorization(){
        // 指定响应类型应该是 "code".
        let responseType = "code"
        
        // 创建一个基于时间间隔的随机字符串 (它将是这样的 linkedin12345679).
        let state = "GITHUB\(Int(NSDate().timeIntervalSince1970))"
        
        // 设置首选的范围。
        let scope = "user+repo"
        
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(clientKey)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                 for: records.filter { $0.displayName.lowercased().contains("github") },
                                 completionHandler: {
                                    if let url = URL(string: authorizationURL){
                                        
                                        let req = URLRequest(url: url)
                                        
                                        self.webView.load(req)
                                    }
            })
        }
    }
    
    func reqAccessToken(with code:String){
        startAnimating()
        guard let url = URL(string: accessTokenEndPoint) else{
            stopAnimating()
            return
        }
        Alamofire.request(url, method:.post, parameters: ["client_secret":clientSecret,"code":code,"client_id":clientKey]).responseData(completionHandler: { (response) in
            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                if utf8Text.range(of: "access_token") != nil
                    ,let accessToken = utf8Text.split(separator: "&").first?.split(separator: "=").last{

                    UserDefaults.standard.set(accessToken, forKey: GITHUB_ACCESS_KEY)
                    
                    UserService.shared.getMyInfo{ (model) in
                        self.stopAnimating()
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        })
    }
}

extension LoginWebViewController: WKNavigationDelegate{
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        let url = navigationAction.request.url
        
        if url?.scheme == "iosgitpocket"{
            if url?.absoluteString.range(of: "code") != nil, let urlParts = url?.absoluteString.components(separatedBy: "?")
                ,let code = (urlParts[1].components(separatedBy: "=")[1]).split(separator: "&").first{
                reqAccessToken(with: String(code))
            }
        }
        decisionHandler(.allow)
    }
}
