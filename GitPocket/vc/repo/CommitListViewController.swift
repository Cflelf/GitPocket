//
//  CommitListViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/4/1.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import DJTableViewVM

class CommitListViewController: UIViewController{
    let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var tableViewVM: DJTableViewVM!
    var commits:[CommitResModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewVM = DJTableViewVM(tableView: tableView)
        
        tableViewVM.registerRowClass(CommitTableViewRow.self, forCellClass: CommitTableViewCell.self, bundle: nil)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupTable(url:String,sha:String){
        RepoService.shared.getModels(by: url.format(), parameters: ["sha":sha]) { [weak self](models:[CommitResModel]) in
            self?.commits = models
            
            let section = DJTableViewVMSection()
            section.addRows(from: models.map({ (model) -> CommitTableViewRow in
                let row = CommitTableViewRow()
                row.heightCaculateType = .autoLayout
                row.commit = model
                row.selectionHandler = { _ in
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "commit") as? CommitDetailViewController
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                        vc?.setup(with: model)
                    }
                    self?.navigationController?.pushViewController(vc!, animated: true)
                }
                return row
            }))
            
            self?.tableViewVM.addSection(section)
            self?.tableViewVM.reloadData()
        }
    }
}

class CommitTableViewCell: DJTableViewVMCell{
    
    lazy var imageV:UIImageView = UIImageView()
    lazy var subtitleLabel:UILabel = UILabel()
    lazy var titleLabel:UILabel = UILabel()
    lazy var dateLabel:UILabel = UILabel()
    
    override func cellDidLoad() {
        super.cellDidLoad()
        
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-8)
            make.top.equalTo(8)
        }
        
        contentView.addSubview(imageV)
        imageV.snp.makeConstraints { (make) in
            make.leading.equalTo(4)
            make.width.height.equalTo(16)
            make.top.equalTo(10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageV.snp.trailing).offset(8)
            make.top.equalTo(8)
            make.trailing.lessThanOrEqualTo(dateLabel.snp.leading).offset(-8)
            make.height.equalTo(17)
        }
        
        subtitleLabel.textColor = UIColor.black.withAlphaComponent(0.7)
        subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        subtitleLabel.numberOfLines = 0
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.lessThanOrEqualTo(dateLabel.snp.leading).offset(-8)
            make.bottom.equalTo(-8)
        }
    }
    
    override func cellWillAppear() {
        super.cellWillAppear()
        
        titleLabel.text = nil
        subtitleLabel.text = nil
        imageV.image = nil
        dateLabel.text = nil
        
        guard let row = rowVM as? CommitTableViewRow, let model = row.commit else{
            return
        }
        titleLabel.text = model.authorName
        subtitleLabel.text = model.message
        if let url = URL(string: model.author?.avatar_url ?? ""){
            imageV.sd_setImage(with: url, placeholderImage: UIImage(named: "user"), options: .retryFailed, completed: nil)
        }
        dateLabel.text = String(model.date?.split(separator: "T").first ?? "")
    }
}

class CommitTableViewRow: DJTableViewVMRow{
    var commit:CommitResModel?
}
