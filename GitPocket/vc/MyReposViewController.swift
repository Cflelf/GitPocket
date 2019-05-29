//
//  MyReposViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/5/13.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit

class MyReposViewController: UIViewController{
    var repos:[RepoModel] = []
    // 底部刷新
    var url:String = ""
    var index = 1
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = UserService.shared.currentUser{
            RepoService.shared.getModels(by: user.repos_url.format(), parameters: nil) {[weak self] (repos:[RepoModel]) in
                self?.repos = repos
                self?.tableView.reloadData()
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchRepoResTableViewCell.self, forCellReuseIdentifier: "repo")
    }
}

extension MyReposViewController: UITableViewDelegate,UITableViewDataSource{
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
