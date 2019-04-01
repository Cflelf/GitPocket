//
//  FileViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/30.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import DJTableViewVM

class FileListViewController: UIViewController{
    
    let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var tableViewVM: DJTableViewVM!
    var files:[RepoContentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewVM = DJTableViewVM(tableView: tableView)
        
        tableViewVM.registerRowClass(DJTableViewVMRow.self, forCellClass: DJTableViewVMCell.self, bundle: nil)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupTable(fileURL:String){
        RepoService.shared.getModels(by: fileURL.format(), parameters: nil) { [weak self](models:[RepoContentModel]) in
            self?.files = models
            
            let section = DJTableViewVMSection()
            section.addRows(from: models.map({ (model) -> DJTableViewVMRow in
                let row = DJTableViewVMRow()
                row.style = .value1
                if model.type == "file"{
                    row.detailText = "\(model.size ?? 0) B"
                    row.selectionHandler = {[weak self] (_) in
                        let vc = FileContentViewController()
                        self?.navigationController?.pushViewController(vc, animated: true)
                        
                        RepoService.shared.getModel(by: model.url ?? "", completionHandler: { (model:RepoContentModel) in
                            vc.setupContent(str: model.content ?? "" , fileName: model.name ?? "")
                        })
                    }
                }else if model.type == "dir"{
                    row.accessoryType = .disclosureIndicator
                    row.selectionHandler = {[weak self] (_) in
                        let vc = FileListViewController()
                        vc.setupTable(fileURL: model.url ?? "")
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                row.backgroundColor = LightGreyColor
                row.titleFont = UIFont.systemFont(ofSize: 12)
                row.title = model.name
                row.detailTextFont = UIFont.systemFont(ofSize: 11)
                row.image = UIImage(named: model.type ?? "file")
                return row
            }))
            self?.tableViewVM.addSection(section)
            self?.tableViewVM.reloadData()
        }
    }
}
