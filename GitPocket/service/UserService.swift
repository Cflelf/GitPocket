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
    func getModels<Model:HandyJSON>(by url:String,parameters:[String:Any]?,completionHandler:@escaping (_ model:[Model])->Void)
}

extension MyServiceProtocol{
    func getModels<Model:HandyJSON>(by url:String,parameters:[String:Any]?,completionHandler:@escaping (_ model:[Model])->Void){
        guard let url = URL(string: url) else{
            return
        }
        
        Alamofire.request(url,parameters:parameters).responseString { (response) in
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
    
    func checkStar(repoName:String,ownerName:String,completionHandler:@escaping (_ bool:Bool)->Void){
        guard let url = URL(string: "https://api.github.com/user/starred/\(ownerName)/\(repoName)") , let key = ACCESS_KEY else{
            completionHandler(false)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: ["access_token":key]).responseString { (response) in
            if response.result.isSuccess{
                if let jsonString = response.result.value , jsonString.isEmpty {
                    completionHandler(true)
                }else{
                    completionHandler(false)
                }
            }
        }
    }
    
    func starRepo(method:HTTPMethod = .put,repoName:String,ownerName:String,completionHandler:@escaping (_ b:Bool)->Void){
        guard let url = URL(string: "https://api.github.com/user/starred/\(ownerName)/\(repoName)") , let key = ACCESS_KEY else{
            completionHandler(false)
            return
        }
        
        Alamofire.request(url, method: method, parameters: ["access_token":key]).responseString { (response) in
            if response.result.isSuccess{
                completionHandler(true)
            }
        }
    }
    
    func getMyInfo(completionHandler:@escaping (_ model:UserModel)->Void){
        guard let url = URL(string: "https://api.github.com/user") , let key = ACCESS_KEY else{
            return
        }
        
        print(key)
        
        Alamofire.request(url, method: .get, parameters: ["access_token":key]).responseString { (response) in
            if response.result.isSuccess {
                
                if let jsonString = response.result.value {
                    
                    if let responseModel = JSONDeserializer<UserModel>.deserializeFrom(json: jsonString) {
                        responseModel.access_token = key
                        self.currentUser = responseModel
                        
                        NotificationCenter.default.post(Notification(name: Notification.Name.init("LoginSuccess")))
                        
                        UserDataService.shared.saveUser(user: responseModel)
                        
                        completionHandler(responseModel)
                    }
                }
            }
        }
    }
}
