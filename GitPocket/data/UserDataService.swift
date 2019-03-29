//
//  UserDataService.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/25.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import Realm
import RealmSwift

class UserDataService{
    
    public static let shared = UserDataService()
    
    let realm = try! Realm()
    
    func saveUser(user:UserModel){
        if let _ = getUser(by: user.access_token){
            return
        }
        
        try! realm.write {
            realm.add(user)
        }
    }
    
    func getUser(by accessToken:String)->UserModel?{
        return realm.objects(UserModel.self).filter("access_token == '\(accessToken)'").first
    }
    
    func setDefaultRealmForUser(accessToken: String) {
        var config = Realm.Configuration()
        
        // 使用默认的目录，但是使用用户名来替换默认的文件名
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("\(accessToken).realm")
        
        print(config.fileURL?.absoluteString)
        
        // 将这个配置应用到默认的 Realm 数据库当中
        Realm.Configuration.defaultConfiguration = config
    }
}
