//
//  RepoViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/27.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import SDWebImage
import DJTableViewVM

class RepoViewController: UIViewController{
    
    let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var tableViewVM: DJTableViewVM!
    lazy var repoView: RepoView = RepoView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 386))
    lazy var section1:DJTableViewVMSection = DJTableViewVMSection(headerHeight: 20)
    lazy var section2:DJTableViewVMSection = DJTableViewVMSection(headerHeight: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0.001
        tableView.tableHeaderView = repoView
        tableView.separatorColor = UIColor.black.withAlphaComponent(0.2)
        tableViewVM = DJTableViewVM(tableView: tableView)
        
        tableViewVM.registerRowClass(DJTableViewVMRow.self, forCellClass: DJTableViewVMCell.self, bundle: nil)
        
        tableViewVM.addSection(section1)
        tableViewVM.addSection(section2)
        tableViewVM.reloadData()
        
        repoView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    //视图将要消失
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupTable(repo:RepoModel){
        section1.addRows(from: ["Event","Content","Commit","Tags"].map({ (str) -> DJTableViewVMRow in
            let row = DJTableViewVMRow()
            row.backgroundColor = LightGreyColor
            row.titleFont = UIFont.systemFont(ofSize: 12)
            row.title = str
            row.image = UIImage(named: "file")
            row.accessoryType = .disclosureIndicator
            return row
        }))
        
        if let row = (section1.rows?[1] as? DJTableViewVMRow){
            row.selectionHandler = {[weak self](_) in
                let vc = FileListViewController()
                vc.setupTable(fileURL: repo.contents_url)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if let row = (section1.rows?[2] as? DJTableViewVMRow){
            row.selectionHandler = {[weak self](_) in
                let vc = BranchListViewController()
                vc.setupTable(url: repo.branches_url,commitURL:repo.commits_url)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        section2.addRows(from: [("Git url",repo.git_url),("SSH url",repo.ssh_url),("Clone url",repo.clone_url),("Svn url",repo.svn_url)].map({ (key,value) -> DJTableViewVMRow in
            let row = DJTableViewVMRow()
            row.style = .value1
            row.backgroundColor = LightGreyColor
            row.titleFont = UIFont.systemFont(ofSize: 12)
            row.title = key
            row.detailText = value
            row.detailTextFont = UIFont.systemFont(ofSize: 11)
            row.image = UIImage(named: "file")
            return row
        }))
        
        tableViewVM.reloadData()
    }
}

extension RepoViewController:RepoViewDelegate{
    func tapUser(url: String) {
        let vc = UserListViewController()
        vc.setupTable(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tapIssue(url: String) {
        let vc = IssueListViewController()
        vc.setupTable(issueURL: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension RepoViewController:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension Int{
    func format()->String{
        if self >= 1000{
            return String(format: "%.1fk", Float(self)/1000)
        }else{
            return String(self)
        }
    }
}
