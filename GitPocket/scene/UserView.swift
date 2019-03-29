//
//  UserView.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/26.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit

class UserView: UIView {

    @IBOutlet weak var reposLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var avatarView: UIImageView!
    
    init() {
        super.init(frame: .zero)
        
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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel(_:)))
        
        followerLabel.addGestureRecognizer(gesture)
        followingLabel.addGestureRecognizer(gesture)
        reposLabel.addGestureRecognizer(gesture)
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
        
        if let startIndex = user.following_url.firstIndex(of: "{"){
            UserService.shared.getModels(by: String(user.following_url[..<startIndex])) { [weak self](models:[UserModel]) in
                self?.followingLabel.text = "\(models.count)\nFollowing"
            }
        }
        
        UserService.shared.getModels(by: user.followers_url) { [weak self](models:[UserModel]) in
            self?.followerLabel.text = "\(models.count)\nFollowers"
        }
    }
    
    @objc func tapLabel(_ sender:UILabel){
        switch sender {
        case followerLabel:
            break
        case followingLabel:
            break
        case reposLabel:
            break
        default:
            break
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

