//
//  RepoListViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/4/1.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class RepoListViewController: UIViewController{
    let tableView: MyTableView = MyTableView(frame: .zero, style: .grouped)
    var repos:[RepoModel] = []
    // 底部刷新
    var url:String = ""
    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(SearchRepoResTableViewCell.self, forCellReuseIdentifier: "repo")
        tableView.delegate = self
        tableView.dataSource = self
        
        // 上拉刷新
        tableView.foot.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
    }
    
    @objc func footerRefresh() {
        UserService.shared.getModels(by: url.format(), parameters: ["page":index+1]) { [weak self](models:[RepoModel]) in
            if models.isEmpty{
                self?.tableView.mj_footer.resetNoMoreData()
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self?.repos.append(contentsOf: models)
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData()
                self?.index = (self?.index ?? 0) + 1
            }
        }
        
    }
    
    func setupTable(url:String){
        self.url = url
        UserService.shared.getModels(by: url.format(), parameters: ["page":0]) { [weak self](models:[RepoModel]) in
            self?.repos = models
            self?.tableView.reloadData()
        }
    }
    
    func setupTable(url:String,repos:SearchRepoModel){
        self.url = url
        self.repos = repos.items ?? []
        self.tableView.reloadData()
    }
}

extension RepoListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "repo", for: indexPath) as? SearchRepoResTableViewCell
        if cell == nil {
            cell = SearchRepoResTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "repo")
        }
        cell?.setup(repo: repos[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "repo") as? RepoViewController
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            vc?.repoView.setup(repo: self.repos[indexPath.row])
            vc?.setupTable(repo: self.repos[indexPath.row])
        }
        navigationController?.pushViewController(vc!, animated: true)
    }
}
