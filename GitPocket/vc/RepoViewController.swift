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
    var files:[RepoContentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.backgroundColor = .white
        tableView.tableHeaderView = repoView
        tableViewVM = DJTableViewVM(tableView: tableView)
        
        tableViewVM.registerRowClass(DJTableViewVMRow.self, forCellClass: DJTableViewVMCell.self, bundle: nil)
        
        let section = DJTableViewVMSection(headerTitle: "xxxx")
        tableViewVM.addSection(section)
        
        let row = DJTableViewVMRow()
        row.title = "event"
        row.image = UIImage(named: "file")
        row.accessoryType = .disclosureIndicator
        section.addRow(row)
        tableViewVM.reloadData()
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
        if let startIndex = repo.contents_url.firstIndex(of: "{"){
            RepoService.shared.getModels(by: String(repo.contents_url[..<startIndex])) { [weak self](models:[RepoContentModel]) in
                self?.files = models
                self?.tableView.reloadData()
            }
        }
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
