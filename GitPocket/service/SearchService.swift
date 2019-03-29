//
//  SearchService.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/20.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import Alamofire
import HandyJSON

enum SearchType:String,CaseIterable{
    case repositories
    case users
    case code
}

class SearchService{
    static let shared = SearchService()
    
    func search<T:HandyJSON>(query:String,type:SearchType,completionHandler:@escaping (_ result:T)->Void){
        let urlStr = "https://api.github.com/search/\(type.rawValue)"
        
        guard let url = URL(string: urlStr) else{
            return
        }
        
        Alamofire.request(url, method: .get, parameters: ["q":query]).responseString { (response) in
            if response.result.isSuccess {
                
                if var jsonString = response.result.value {
                     jsonString = jsonString.replacingOccurrences(of: "description", with: "desp")
                    if let responseModel = JSONDeserializer<T>.deserializeFrom(json: jsonString) {
                        
                        completionHandler(responseModel)
                    }
                }
            }
        }
    }
}
