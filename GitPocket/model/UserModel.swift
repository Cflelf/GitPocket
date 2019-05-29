//
//  UserModel.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/17.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import HandyJSON
import RealmSwift
import Realm

class UserModel: Object, HandyJSON{
    @objc dynamic var avatar_url:String = ""
    @objc dynamic var received_events_url:String = ""
    @objc dynamic var login:String = ""
    @objc dynamic var access_token:String = ""
    @objc dynamic var followers:Int = 0
    @objc dynamic var following:Int = 0
    @objc dynamic var public_repos:Int = 0
    @objc dynamic var followers_url:String = ""
    @objc dynamic var following_url:String = ""
    @objc dynamic var repos_url:String = ""
    @objc dynamic var url:String = ""
    @objc dynamic var events_url:String = ""
    @objc dynamic var blog:String = "-"
    @objc dynamic var location:String = "-"
    @objc dynamic var email:String = "-"
    @objc dynamic var company:String = "-"
    @objc dynamic var starred_url:String = ""
    
    override static func primaryKey() -> String? {
        return "access_token"
    }
}
