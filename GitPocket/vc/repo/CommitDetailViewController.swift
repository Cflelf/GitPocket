//
//  CommitDetailViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/4/3.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import DJTableViewVM

class CommitDetailViewController: UIViewController{
    
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var tableviewVM:DJTableViewVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewVM = DJTableViewVM(tableView: tableview)
        
        tableviewVM.registerRowClass(CommitDetailTableViewRow.self, forCellClass: CommitDetailTableViewCell.self, bundle: nil)
    }
    
    func setup(with commit:CommitResModel){
        nameLabel.text = commit.message
        subtitleLabel.text = "\(commit.authorName ?? "") commited in \(commit.date ?? "")"
    
        RepoService.shared.getModel(by: commit.url?.format() ?? "") { [weak self](model:CommitResModel) in
            self?.addLabel.text = "+\(model.additions ?? 0)"
            self?.deleteLabel.text = "-\(model.deletions ?? 0)"
            
            var dic:[String:[CommitFileModel]] = [:]
            
            if let files = model.files{
                
                for file in files{
                    let filePath = "/\(file.filename?.split(separator: "/").dropLast().joined(separator: "/") ?? "")"
                    
                    if (dic[filePath] != nil){
                        dic[filePath]?.append(file)
                    }else{
                        dic[filePath] = [file]
                    }
                }
                
                for (key,value) in dic{
                    let section = DJTableViewVMSection(headerTitle: key)
                    
                    section.addRows(from: value.map({ (model) -> CommitDetailTableViewRow in
                        let row = CommitDetailTableViewRow()
                        row.file = model
                        row.accessoryType = .disclosureIndicator
                        row.selectionHandler = { _ in
                            let vc = FileContentViewController()
                            vc.title = String(model.filename?.split(separator: "/").last ?? "")
                            vc.setContent(str: model.patch ?? "")
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                        return row
                    }))
                    
                    self?.tableviewVM.addSection(section)
                }
            }
            
            
            self?.tableviewVM.reloadData()
        }
    }
}

class CommitDetailTableViewCell:DJTableViewVMCell{
    lazy var titleLabel:UILabel = UILabel()
    lazy var subTitleLabel:UILabel = UILabel()
    lazy var addLabel:UILabel = UILabel()
    lazy var deleteLabel:UILabel = UILabel()
    
    override func cellDidLoad() {
        super.cellDidLoad()
        
        contentView.addSubview(deleteLabel)
        deleteLabel.textColor = UIColor(netHex: 0xB93538)
        deleteLabel.font = UIFont.systemFont(ofSize: 11)
        deleteLabel.textAlignment = .center
        deleteLabel.backgroundColor = UIColor(netHex: 0xFCEEF0)
        deleteLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-30)
            make.width.equalTo(40)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(addLabel)
        addLabel.textAlignment = .center
        addLabel.textColor = UIColor(netHex: 0x62BA5D)
        addLabel.font = UIFont.systemFont(ofSize: 11)
        addLabel.backgroundColor = UIColor(netHex: 0xEBFEEE)
        addLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-74)
            make.width.equalTo(40)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(8)
            make.top.equalTo(8)
        }
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.font = UIFont.systemFont(ofSize: 11)
        subTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
    
    override func cellWillAppear() {
        super.cellWillAppear()
        
        guard let row = rowVM as? CommitDetailTableViewRow, let model = row.file else{
            return
        }

        titleLabel.text = String(model.filename?.split(separator: "/").last ?? "")
        subTitleLabel.text = model.status
        addLabel.text = "+\(model.additions ?? 0)"
        deleteLabel.text = "-\(model.deletions ?? 0)"
    }
}

class CommitDetailTableViewRow:DJTableViewVMRow{
    var file:CommitFileModel?
}
