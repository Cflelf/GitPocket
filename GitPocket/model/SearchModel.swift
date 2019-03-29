//
//  SearchModel.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/20.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import HandyJSON

struct SearchUserModel:HandyJSON{
    var total_count:Int?
    var items:[UserModel]?
}

struct SearchRepoModel:HandyJSON{
    var total_count:Int?
    var items:[RepoModel]?
}
