
//
//  IssueViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/31.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import DJTableViewVM

class IssueListViewController: UIViewController{
    let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var tableViewVM: DJTableViewVM!
    var issues:[RepoIssueModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewVM = DJTableViewVM(tableView: tableView)
        
        tableViewVM.registerRowClass(IssueTableViewRow.self, forCellClass: IssueTableViewCell.self, bundle: nil)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupTable(issueURL:String){
        RepoService.shared.getModels(by: issueURL.format(), parameters: nil) { [weak self](models:[RepoIssueModel]) in
            self?.issues = models
            
            let section = DJTableViewVMSection()
            section.addRows(from: models.map({ (model) -> IssueTableViewRow in
                let row = IssueTableViewRow()
                row.heightCaculateType = .autoLayout
                row.issue = model
                return row
            }))
            
            self?.tableViewVM.addSection(section)
            self?.tableViewVM.reloadData()
        }
    }
}

class IssueTableViewCell: DJTableViewVMCell{
    
    lazy var imageV:UIImageView = UIImageView()
    lazy var subtitleLabel:UILabel = UILabel()
    lazy var titleLabel:UILabel = UILabel()
    lazy var commentIcon:UIImageView = UIImageView(image: UIImage(named: "comment"))
    lazy var commentLabel:UILabel = UILabel()
    
    override func cellDidLoad() {
        super.cellDidLoad()
        
        commentLabel.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-8)
            make.top.equalTo(8)
        }
        
        contentView.addSubview(commentIcon)
        commentIcon.snp.makeConstraints { (make) in
            make.top.equalTo(7)
            make.trailing.equalTo(commentLabel.snp.leading).offset(-4)
            make.width.height.equalTo(16)
        }
        
        contentView.addSubview(imageV)
        imageV.snp.makeConstraints { (make) in
            make.leading.equalTo(4)
            make.width.height.equalTo(16)
            make.top.equalTo(10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageV.snp.trailing).offset(8)
            make.top.equalTo(8)
            make.trailing.lessThanOrEqualTo(commentIcon.snp.leading).offset(-8)
        }
        subtitleLabel.textColor = UIColor.black.withAlphaComponent(0.7)
        subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.lessThanOrEqualTo(commentIcon.snp.leading).offset(-8)
            make.bottom.equalTo(-8)
        }
    }
    
    override func cellWillAppear() {
        super.cellWillAppear()
        
        titleLabel.text = nil
        subtitleLabel.text = nil
        imageV.image = nil
        commentLabel.text = nil
        
        guard let row = rowVM as? IssueTableViewRow, let model = row.issue else{
            return
        }
        titleLabel.text = model.title
        subtitleLabel.text = "#\(model.number ?? 0) \(model.state ?? "opened") on \(model.created_at?.split(separator: "T").first ?? "") by \(model.user?.login ?? "")"
        imageV.image = UIImage(named: "file")
        commentLabel.text = "\(model.comments ?? 0)"
    }
}

class IssueTableViewRow: DJTableViewVMRow{
    var issue:RepoIssueModel?
}
