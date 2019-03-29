//
//  RepoView.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/28.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit

class RepoView: UIView {
    @IBOutlet weak var ownerAvatarView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var forkNumLabel: UILabel!
    @IBOutlet weak var watchNumLabel: UILabel!
    @IBOutlet weak var starNumLabel: UILabel!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var despView: UITextView!
    @IBOutlet weak var commitNumLabel: UILabel!
    @IBOutlet weak var branchNumLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var contributorNumLabel: UILabel!
    @IBOutlet weak var issueNumLabel: UILabel!
    @IBOutlet weak var lanLabel: UILabel!
    @IBOutlet weak var topicView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        myInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        myInit()
    }
    
    func myInit(){
        let frameView = loadNib()
        addSubview(frameView)
        frameView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setup(repo:RepoModel){
        if let url = URL(string: repo.owner.avatar_url ){
            bgView.sd_setImage(with: url)
            avatarView.sd_setImage(with: url)
            ownerAvatarView.sd_setImage(with: url)
        }
        
        nameLabel.text = repo.name
        despView.text = repo.desp
        forkNumLabel.text = repo.forks.format()
        starNumLabel.text = repo.stargazers_count.format()
        watchNumLabel.text = repo.subscribers_count.format()
        ownerNameLabel.text = repo.owner.login
        sizeLabel.text = "\(repo.size) KB"
        lanLabel.text = repo.language.isEmpty ? "-" : repo.language
        issueNumLabel.text = "\(repo.open_issues.format()) issues"
        
        RepoService.shared.getModels(by: repo.contributors_url) { [weak self](models:[UserModel]) in
            self?.contributorNumLabel.text = "\(models.count) contributors"
        }
        if let startIndex = repo.commits_url.firstIndex(of: "{"){
            RepoService.shared.getModels(by: String(repo.commits_url[..<startIndex]), completionHandler: { [weak self](models:[CommitResModel]) in
                self?.commitNumLabel.text = "\(models.count.format()) commits"
            })
        }
        if let startIndex = repo.branches_url.firstIndex(of: "{"){
            RepoService.shared.getModels(by: String(repo.branches_url[..<startIndex]), completionHandler: { [weak self](models:[BranchModel]) in
                self?.branchNumLabel.text = "\(models.count.format()) branches"
            })
        }
        
        RepoService.shared.getTopics(url: repo.url+"/topics") { [weak self](models) in
            
            var initialX:CGFloat = 0
            
            for model in models[..<min(4,models.count)]{
                let label = UILabel()
                label.backgroundColor = UIColor(netHex: 0x24282d).withAlphaComponent(0.7)
                label.clipsToBounds = true
                label.layer.cornerRadius = 4
                label.font = UIFont.systemFont(ofSize: 11)
                label.textColor = .white
                label.text = model
                label.textAlignment = .center
                
                let size = model.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 15), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 11)], context: nil).size
                label.frame.size = CGSize(width: size.width+10, height: size.height+2)
                
                label.frame.origin = CGPoint(x: initialX, y: 0)
                
                initialX = initialX + label.frame.width + 8
                
                self?.topicView.addSubview(label)
            }
        }
    }
}
