//
//  IssueDetailViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/4/2.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import DJTableViewVM
import MarkdownKit

class IssueDetailViewController: UIViewController{
    
    @IBOutlet weak var statusView: UIView!
    let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    lazy var section:DJTableViewVMSection = DJTableViewVMSection()
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var tableViewVM:DJTableViewVM!
    var comments:[RepoIssueModel] = []
    // 底部刷新
    var url:String = ""
    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
//        tableView.separatorColor = ThemeColor
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(statusView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        tableViewVM = DJTableViewVM(tableView: tableView)
        tableViewVM.registerRowClass(IssueDetailTableViewRow.self, forCellClass: IssueDetailTableViewCell.self, bundle: nil)
    }
    
    func setup(with model:RepoIssueModel){
        title = "#\(model.number ?? 0)"
        
        titleLabel.text = model.title
        subTitleLabel.text = "#\(model.number ?? 0) \(model.state ?? "opened") on \(model.created_at?.split(separator: "T").first ?? "") by \(model.user?.login ?? "")"
    
        tableViewVM.addSection(section)
        
        let row = IssueDetailTableViewRow()
        row.issue = model
        section.addRow(row)
        
        tableViewVM.reloadData()
    }
    
    func setupTable(url:String){
        self.url = url
        
        RepoService.shared.getModels(by: url.format(), parameters: nil) { [weak self](models:[RepoIssueModel]) in
            self?.comments = models
            self?.section.addRows(from: models.map({ (model) -> IssueDetailTableViewRow in
                let row = IssueDetailTableViewRow()
                row.issue = model
                return row
            }))
            
            self?.tableViewVM.reloadData()
        }
    }
}

class IssueDetailTableViewCell:DJTableViewVMCell{
    lazy var userAvatar:UIImageView = UIImageView()
    lazy var titleLabel:UILabel = UILabel()
    lazy var body:UITextView = UITextView()
    
    override func cellDidLoad() {
        super.cellDidLoad()
        
        contentView.addSubview(userAvatar)
        userAvatar.snp.makeConstraints { (make) in
            make.top.leading.equalTo(8)
            make.width.height.equalTo(32)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(userAvatar.snp.trailing).offset(8)
            make.top.equalTo(8)
        }
        
        body.isScrollEnabled = false
        body.isEditable = false
        body.layer.borderWidth = 0.3
        body.layer.borderColor = ThemeColor.withAlphaComponent(0.7).cgColor
        contentView.addSubview(body)
        body.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(-8)
            make.bottom.equalTo(-8)
        }
    }
    
    override func cellWillAppear() {
        super.cellWillAppear()
        
        guard let row = rowVM as? IssueDetailTableViewRow, let model = row.issue else{
            return
        }
        body.attributedText = MarkdownParser().parse(model.body ?? "")
//        body.text = model.body
//        body.load(markdown: model.body)
        titleLabel.text = "\(model.user?.login ?? "") commented"
        if let url = URL(string: model.user?.avatar_url ?? ""){
            userAvatar.sd_setImage(with: url, placeholderImage: UIImage(named: "user"), options: .retryFailed, completed: nil)
        }
    }
}

class IssueDetailTableViewRow:DJTableViewVMRow{
    var issue:RepoIssueModel?
    
    override init() {
        super.init()
        
        self.heightCaculateType = .autoLayout
    }
}
