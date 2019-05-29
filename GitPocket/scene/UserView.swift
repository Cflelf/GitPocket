//
//  UserView.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/26.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit

protocol UserViewDelegate: NSObjectProtocol {
    func tapToUserList(url:String,title:String)
    func tapRepo(url:String)
}

class UserView: UIView {

    @IBOutlet weak var reposLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var avatarView: UIImageView!
    weak var delegate:UserViewDelegate?
    
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
        
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 40
    }
    
    
    func setup(with user:UserModel){
        if let url = URL(string: user.avatar_url ){
            bgView.sd_setImage(with: url)
            avatarView.sd_setImage(with: url)
        }
        nameLabel.text = user.login
        followingLabel.text = "\(user.following)\nFollowing"
        followerLabel.text  = "\(user.followers)\nFollowers"
        reposLabel.text = "\(user.public_repos)\nRepos"
        setupTapCallBack(user: user)
    }
    
    func setupOthers(with user:UserModel){
        if let url = URL(string: user.avatar_url ){
            bgView.sd_setImage(with: url)
            avatarView.sd_setImage(with: url)
        }
        nameLabel.text = user.login
        followingLabel.text = "-\nFollowing"
        followerLabel.text  = "-\nFollowers"
        reposLabel.text = "-\nRepos"
        
        UserService.shared.getModel(by: user.url) { [weak self](model:UserModel) in
            self?.followingLabel.text = "\(model.following)\nFollowing"
            self?.followerLabel.text  = "\(model.followers)\nFollowers"
            self?.reposLabel.text = "\(model.public_repos)\nRepos"
        }
        
        setupTapCallBack(user: user)
    }
    
    func setupTapCallBack(user:UserModel){
        followerLabel.viewCallBack = {
            self.delegate?.tapToUserList(url: user.followers_url, title: "Followers")
        }
        
        followingLabel.viewCallBack = {
            self.delegate?.tapToUserList(url: user.following_url, title: "Following")
        }
        
        reposLabel.viewCallBack = {
            self.delegate?.tapRepo(url: user.repos_url)
        }
    }
}

extension UIView{
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

