//
//  UserService.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/17.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import Alamofire
import HandyJSON

protocol MyServiceProtocol {
    func getModel<Model:HandyJSON>(by url:String,completionHandler:@escaping (_ model:Model)->Void)
    func getModels<Model:HandyJSON>(by url:String,completionHandler:@escaping (_ model:[Model])->Void)
}

extension MyServiceProtocol{
    func getModels<Model:HandyJSON>(by url:String,completionHandler:@escaping (_ model:[Model])->Void){
        guard let url = URL(string: url) else{
            return
        }
        
        Alamofire.request(url).responseString { (response) in
            if response.result.isSuccess {
                
                if var jsonString = response.result.value {
                    jsonString = jsonString.replacingOccurrences(of: "description", with: "desp")
                    if let responseModel = JSONDeserializer<Model>.deserializeModelArrayFrom(json: jsonString) {
                        completionHandler(responseModel.compactMap{$0})
                    }
                }
            }
        }
    }
    
    func getModel<Model:HandyJSON>(by url:String,completionHandler:@escaping (_ model:Model)->Void){
        guard let url = URL(string: url) else{
            return
        }
        
        Alamofire.request(url).responseString { (response) in
            if response.result.isSuccess {
                
                if var jsonString = response.result.value {
                    jsonString = jsonString.replacingOccurrences(of: "description", with: "desp")
                    if let responseModel = JSONDeserializer<Model>.deserializeFrom(json: jsonString) {
                        completionHandler(responseModel)
                    }
                }
            }
        }
    }
}

class UserService:MyServiceProtocol{
    static let shared = UserService()
    
    var currentUser:UserModel?
    
    func getMyInfo(completionHandler:@escaping (_ model:UserModel)->Void){
        if let user = currentUser{
            completionHandler(user)
        }
        
        guard let url = URL(string: "https://api.github.com/user") , let key = ACCESS_KEY else{
            return
        }
        
        Alamofire.request(url, method: .get, parameters: ["access_token":key]).responseString { (response) in
            if response.result.isSuccess {
                
                if let jsonString = response.result.value {
                    
                    if let responseModel = JSONDeserializer<UserModel>.deserializeFrom(json: jsonString) {
                        responseModel.access_token = key
                        self.currentUser = responseModel
                        
                        UserDataService.shared.saveUser(user: responseModel)
                        
                        completionHandler(responseModel)
                    }
                }
            }
        }
    }
}
