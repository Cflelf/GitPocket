//
//  RepoView.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/28.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import Toaster
import Toast_Swift

protocol RepoViewDelegate: NSObjectProtocol {
    func tapIssue(url:String)
    func tapUser(url:String)
}

class RepoView: UIView {
    @IBOutlet weak var ownerAvatarView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var forkNumLabel: UILabel!
    @IBOutlet weak var watchNumLabel: UILabel!
    @IBOutlet weak var starNumLabel: UILabel!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var despView: UITextView!
    @IBOutlet weak var branchNumLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var contributorNumLabel: UILabel!
    @IBOutlet weak var issueNumLabel: UILabel!
    @IBOutlet weak var lanLabel: UILabel!
    @IBOutlet weak var topicView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate:RepoViewDelegate?
    let backIcon:UIImageView = UIImageView(image: UIImage(named: "back"))
    var isStar:Bool?
    var repo:RepoModel?
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
        
        frameView.addSubview(backIcon)
        backIcon.snp.makeConstraints { (make) in
            make.top.equalTo(isIphoneX() ? 38:8)
            make.leading.equalTo(20)
            make.width.height.equalTo(24)
        }
        
        starImageView.viewCallBack = {
            guard let b = self.isStar,let repo = self.repo else{
                return
            }
            
            UserService.shared.starRepo(method: b ? .delete:.put, repoName: repo.name, ownerName: repo.owner.login){[weak self](bool) in
                if bool{
                    self?.isStar = !b
                    if b{
                        self?.setStarStyle(star: false)
//                       Toast(text: "Unstar success").show()
                        self?.superview?.makeToast("Unstar success", duration: 1.0, position: .center)

                    }else{
                        self?.setStarStyle(star: true)
//                        Toast(text: "Star success").show()
                        self?.superview?.makeToast("Star success", duration: 1.0, position: .center)
                    }
                }
            }
        }
    }
    
    func setStarStyle(star:Bool){
        if star{
            starImageView.addColorImage(imageName: "star", color: UIColor(netHex: 0xe4508f))
            starNumLabel.textColor = UIColor(netHex: 0xe4508f)
        }else{
            starImageView.addColorImage(imageName: "star", color: .white)
            starNumLabel.textColor = .white
        }
    }
    
    func setup(repo:RepoModel){
        self.repo = repo
        
        UserService.shared.checkStar(repoName: repo.name, ownerName: repo.owner.login) { [weak self](b) in
            self?.isStar = b
            if b{
                self?.setStarStyle(star: true)
            }
        }
        
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
        dateLabel.text = "\(repo.created_at.split(separator: "T").first ?? "") created"
        
        issueNumLabel.superview?.viewCallBack = {
            self.delegate?.tapIssue(url: repo.issues_url)
        }
        
        starNumLabel.viewCallBack = {
            self.delegate?.tapUser(url:repo.stargazers_url)
        }
        
        contributorNumLabel.viewCallBack = {
            self.delegate?.tapUser(url:repo.contributors_url)
        }
        
        watchNumLabel.viewCallBack = {
            self.delegate?.tapUser(url: repo.subscribers_url)
        }
        
        RepoService.shared.getModels(by: repo.contributors_url, parameters: nil) { [weak self](models:[UserModel]) in
            self?.contributorNumLabel.text = "\(models.count) contributors"
        }
    
        if let startIndex = repo.branches_url.firstIndex(of: "{"){
            RepoService.shared.getModels(by: String(repo.branches_url[..<startIndex]), parameters: nil, completionHandler: { [weak self](models:[BranchModel]) in
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
                
                let size = model.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 15), options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)], context: nil).size
                label.frame.size = CGSize(width: size.width+10, height: size.height+2)
                
                label.frame.origin = CGPoint(x: initialX, y: 0)
                
                initialX = initialX + label.frame.width + 8
                
                self?.topicView.addSubview(label)
            }
        }
    }
}
