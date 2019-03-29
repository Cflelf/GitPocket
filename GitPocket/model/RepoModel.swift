//
//  ReceivedEventModel.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/18.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import HandyJSON
import RealmSwift
import Realm

struct ReceivedEventModel: HandyJSON{
    var type:String?
    var actor:ActorModel?
    var repo:RepoModel?
}

struct ActorModel: HandyJSON{
    var login:String?
    var url:String?
    var avatar_url:String?
}

class RepoModel: Object,HandyJSON{
    @objc dynamic var name:String = ""
    @objc dynamic var url:String = ""
    @objc dynamic var full_name:String = ""
    @objc dynamic var owner:UserModel = UserModel()
    @objc dynamic var desp:String = ""
    @objc dynamic var stargazers_count:Int = 0
    @objc dynamic var watchers_count:Int = 0
    @objc dynamic var forks:Int = 0
    @objc dynamic var subscribers_count:Int = 0
    @objc dynamic var forks_url:String = ""
    @objc dynamic var branches_url:String = ""
    @objc dynamic var stargazers_url:String = ""
    @objc dynamic var contributors_url:String = ""
    @objc dynamic var subscribers_url:String = ""
    @objc dynamic var commits_url:String = ""
    @objc dynamic var open_issues:Int = 0
    @objc dynamic var language:String = ""
    @objc dynamic var size:Int = 0
    @objc dynamic var created_at:String = ""
    @objc dynamic var contents_url:String = ""
    @objc dynamic var issues_url:String = ""

    override static func ignoredProperties() -> [String] {
        return ["owner"]
    }
}

struct CommitResModel: HandyJSON{
    var authorName:String?
    var date:String?
    var message:String?
    var additions:Int?
    var deletions:Int?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.authorName <-- "commit.author.name"
        mapper <<<
            self.date <-- "commit.author.date"
        mapper <<<
            self.message <-- "commit.message"
        mapper <<<
            self.additions <-- "stats.additions"
        mapper <<<
            self.deletions <-- "stats.deletions"
    }
}

struct BranchModel: HandyJSON {
    var name:String?
    var url:String?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.url <-- "commit.url"
    }
}

struct RepoContentModel: HandyJSON{
    var name:String?
    var path:String?
    var type:String?
    var content:String?
    var size:Int?
}
