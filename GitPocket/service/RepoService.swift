//
//  RepoService.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/27.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import Alamofire

class RepoService: MyServiceProtocol{
    public static let shared = RepoService()
    
    func getTopics(url:String,completionHander:@escaping (_ result:[String])->Void){
        guard let url = URL(string: url) else{
            return
        }
        
        Alamofire.request(url, method: .get , headers: ["Accept":"application/vnd.github.mercy-preview+json"]).responseJSON { (response) in
            if response.result.isSuccess{
                if let json = response.result.value as? [String:Any] , let strs = json["names"] as? [String]{
                    completionHander(strs)
                }
            }
        }
    }
}
