
//
//  IssueViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/31.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import DJTableViewVM
import NVActivityIndicatorView

class IssueListViewController: UIViewController,NVActivityIndicatorViewable{
    let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    var tableViewVM: DJTableViewVM!
    var issues:[RepoIssueModel] = []
    
    lazy var closeView:UIView = UIView()
    lazy var closeIcon:UIImageView = UIImageView(image: UIImage(named: "yes"))
    lazy var closeLabel:UILabel = UILabel()
    
    lazy var openView:UIView = UIView()
    lazy var openIcon:UIImageView = UIImageView(image: UIImage(named: "issue"))
    lazy var openLabel:UILabel = UILabel()
    
    var state:String = "open"
    var url:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 36))
        
        headerView.addSubview(openView)
        openView.snp.makeConstraints { (make) in
            make.leading.equalTo(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(18)
        }
        openView.viewCallBack = {
            self.chooseState(view: self.openView)
        }
        openView.addSubview(openIcon)
        openIcon.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        openLabel.text = "Open"
        openLabel.font = UIFont.boldSystemFont(ofSize: 13)
        openView.addSubview(openLabel)
        openLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(openIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        headerView.addSubview(closeView)
        closeView.viewCallBack = {
            self.chooseState(view: self.closeView)
        }
        closeView.snp.makeConstraints { (make) in
            make.leading.equalTo(openView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(18)
        }
        
        closeView.addSubview(closeIcon)
        closeIcon.addColorImage(imageName: "yes", color: .lightGray)
        closeIcon.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        closeLabel.text = "Closed"
        closeLabel.textColor = .lightGray
        closeLabel.font = UIFont.systemFont(ofSize: 13)
        closeView.addSubview(closeLabel)
        closeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(closeIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        tableView.tableHeaderView = headerView
        tableViewVM = DJTableViewVM(tableView: tableView)
        
        tableViewVM.registerRowClass(IssueTableViewRow.self, forCellClass: IssueTableViewCell.self, bundle: nil)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func chooseState(view:UIView){
        if state == "open" && view == closeView{
            state = "closed"
            setupTable(issueURL: url)
            openLabel.textColor = .lightGray
            closeLabel.textColor = ThemeColor
            openLabel.font = UIFont.systemFont(ofSize: 13)
            closeLabel.font = UIFont.boldSystemFont(ofSize: 13)
            closeIcon.addColorImage(imageName: "yes", color: ThemeColor)
            openIcon.addColorImage(imageName: "issue", color: .lightGray)
        }else if state == "closed" && view == openView{
            state = "open"
            setupTable(issueURL: url)
            openLabel.textColor = ThemeColor
            closeLabel.textColor = .lightGray
            openLabel.font = UIFont.boldSystemFont(ofSize: 13)
            closeLabel.font = UIFont.systemFont(ofSize: 13)
            closeIcon.addColorImage(imageName: "yes", color: .lightGray)
            openIcon.addColorImage(imageName: "issue", color: ThemeColor)
        }
    }
    
    func setupTable(issueURL:String){
        url = issueURL
        startAnimating(CGSize(width: 32, height: 32),type: .lineScale)
        RepoService.shared.getModels(by: issueURL.format(), parameters: ["state":state]) { [weak self](models:[RepoIssueModel]) in
            self?.issues = models
            self?.tableViewVM.removeAllSections()
            let section = DJTableViewVMSection()
            section.addRows(from: models.map({ (model) -> IssueTableViewRow in
                let row = IssueTableViewRow()
                row.heightCaculateType = .autoLayout
                row.issue = model
                row.selectionHandler = { _ in
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "issue") as? IssueDetailViewController
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                        vc?.setup(with: model)
                    }
                    
                    vc?.setupTable(url: model.comments_url ?? "")
                    
                    self?.navigationController?.pushViewController(vc!, animated: true)
                }
                return row
            }))
            self?.stopAnimating()
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
    lazy var topicView:UIView = UIView()
    
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
        
        contentView.addSubview(topicView)
        topicView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.height.equalTo(15)
            make.trailing.lessThanOrEqualTo(commentIcon.snp.leading).offset(-8)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(topicView.snp.bottom).offset(4)
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
        commentLabel.text = "\(model.comments ?? 0)"
        
        if model.state == "open"{
            imageV.addColorImage(imageName: "issue", color: UIColor(hexString: "#56a352"))
        }else{
            imageV.addColorImage(imageName: "issue_close", color: UIColor(hexString: "#b93538"))
        }
        topicView.subviews.forEach{$0.removeFromSuperview()}
        if let labels = model.labels , !labels.isEmpty{
            
            var initialX:CGFloat = 0
            for l in labels[..<min(4,labels.count)]{
                let label = UILabel()
                label.backgroundColor = UIColor(hexString: l.color ?? "")
                label.clipsToBounds = true
                label.layer.cornerRadius = 4
                label.font = UIFont.systemFont(ofSize: 11)
                label.textColor = .white
                label.text = l.name
                label.textAlignment = .center
                
                let size = l.name!.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 15), options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)], context: nil).size
                label.frame.size = CGSize(width: size.width+10, height: size.height+2)
                
                label.frame.origin = CGPoint(x: initialX, y: 0)
                
                initialX = initialX + label.frame.width + 8
                
                topicView.addSubview(label)
            }
        }
    }
}

class IssueTableViewRow: DJTableViewVMRow{
    var issue:RepoIssueModel?
}
