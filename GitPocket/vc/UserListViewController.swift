//
//  UserListViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/4/1.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class UserListViewController: UIViewController{
    let tableView: MyTableView = MyTableView(frame: .zero, style: .grouped)
    var users:[UserModel] = []
    // 底部刷新
    var url:String = ""
    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(SearchUserResTableViewCell.self, forCellReuseIdentifier: "user")
        tableView.delegate = self
        tableView.dataSource = self
        
        // 上拉刷新
        tableView.foot.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
    }
    
    @objc func footerRefresh() {
        UserService.shared.getModels(by: url.format(), parameters: ["page":index+1]) { [weak self](models:[UserModel]) in
            if models.isEmpty{
                self?.tableView.mj_footer.resetNoMoreData()
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self?.users.append(contentsOf: models)
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData()
                self?.index = (self?.index ?? 0) + 1
            }
        }
        
    }
    
    func setupTable(url:String){
        self.url = url
        UserService.shared.getModels(by: url.format(), parameters: ["page":0]) { [weak self](models:[UserModel]) in
            self?.users = models
            self?.tableView.reloadData()
        }
    }
    
    func setupTable(url:String,model:SearchUserModel){
        self.url = url
        self.users = model.items ?? []
        self.tableView.reloadData()
    }
}

extension UserListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as? SearchUserResTableViewCell
        if cell == nil {
            cell = SearchUserResTableViewCell(style: .default, reuseIdentifier: "user")
        }
        cell?.setup(user: users[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mine") as? MineViewController
        vc?.user = users[indexPath.row]
        vc?.isOwner = false
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            vc?.userView.setupOthers(with: self.users[indexPath.row])
        }
        
        navigationController?.pushViewController(vc!, animated: true)
    }
}
