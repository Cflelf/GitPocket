//
//  BranchListViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/4/1.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import DJTableViewVM

class BranchListViewController: UIViewController{
    let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var tableViewVM: DJTableViewVM!
    var branches:[BranchModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewVM = DJTableViewVM(tableView: tableView)
        
        tableViewVM.registerRowClass(DJTableViewVMRow.self, forCellClass: DJTableViewVMCell.self, bundle: nil)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        title = "Branches"
    }
    
    func setupTable(url:String,commitURL:String){
        RepoService.shared.getModels(by: url.format(), parameters: nil) { [weak self](models:[BranchModel]) in
            
            let section = DJTableViewVMSection()
            section.addRows(from: models.map({ (model) -> DJTableViewVMRow in
                let row = DJTableViewVMRow()
                row.image = UIImage(named: "branch")
                row.title = model.name
                row.titleColor = UIColor(netHex: 0x2f89fc)
                
                row.selectionHandler = { _ in
                    let vc = CommitListViewController()
                    vc.title = model.name
                    vc.setupTable(url: commitURL ,sha:model.sha ?? "")
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                return row
            }))
            
            self?.tableViewVM.addSection(section)
            self?.tableViewVM.reloadData()
        }
    }
}
