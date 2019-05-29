//
//  SearchUserResTableViewCell.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/21.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class SearchUserResTableViewCell: UITableViewCell {
    lazy var avatarView:UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var fullNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var isLoginedIcon = UIImageView(image: UIImage(named: "yes"))
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(avatarView.snp.trailing).offset(8)
        }
        
        contentView.addSubview(isLoginedIcon)
        isLoginedIcon.isHidden = true
        isLoginedIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
            make.trailing.equalTo(-16)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(user:UserModel){
        avatarView.image = nil

        if let url = URL(string: user.avatar_url ){
            avatarView.sd_setImage(with: url, placeholderImage: UIImage(named: "user"), options: .retryFailed, completed: nil)
        }
        isLoginedIcon.isHidden = ACCESS_KEY != user.access_token
        fullNameLabel.text = user.login
    }
}
