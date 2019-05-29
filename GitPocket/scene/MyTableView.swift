//
//  MyTableView.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/4/1.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import MJRefresh

class MyTableView: UITableView{
    let foot = MJRefreshAutoNormalFooter()
    
    var index:Int = 1
    
    var url:String = ""
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.mj_footer = foot
        
        foot.setTitle("Load more", for: .idle)
        foot.setTitle("Loading...", for: .refreshing)
        foot.setTitle("No more data", for: .noMoreData)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
