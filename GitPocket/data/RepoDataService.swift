//
//  RepoDataService.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/5/1.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import Realm
import RealmSwift

class RepoDataService{
    public static let shared = UserDataService()
    
    let realm = try! Realm()
    
    func saveRepos(repos:[RepoModel]){
        try! realm.write {
            realm.add(repos, update: true)
        }
    }
    
    func getRepo(by name:String)->RepoModel?{
        return realm.objects(RepoModel.self).filter("name == '\(name)'").first
    }
}
