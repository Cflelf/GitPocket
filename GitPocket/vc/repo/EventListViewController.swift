//
//  RepoEventListViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/4/2.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController{
    
    let tableView: MyTableView = MyTableView(frame: .zero, style: .grouped)
    var events:[ReceivedEventModel] = []
    // 底部刷新
    var url:String = ""
    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(TimeLineTableViewCell.self, forCellReuseIdentifier: "event")
        tableView.delegate = self
        tableView.dataSource = self
        
        // 上拉刷新
        tableView.foot.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
    }
    
    @objc func footerRefresh() {
        UserService.shared.getModels(by: url.format(), parameters: ["page":index+1]) { [weak self](models:[ReceivedEventModel]) in
            if models.isEmpty{
                self?.tableView.mj_footer.resetNoMoreData()
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self?.events.append(contentsOf: models)
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData()
                self?.index = (self?.index ?? 0) + 1
            }
        }
        
    }
    
    func setupTable(url:String){
        self.url = url
        UserService.shared.getModels(by: url.format(), parameters: ["page":0]) { [weak self](models:[ReceivedEventModel]) in
            self?.events = models
            self?.tableView.reloadData()
        }
    }
}

extension EventListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as? TimeLineTableViewCell
        if cell == nil {
            cell = TimeLineTableViewCell(style: .default, reuseIdentifier: "event")
        }
        cell?.setCell(timeline: events[indexPath.row])
        return cell!
    }
    
    
}
