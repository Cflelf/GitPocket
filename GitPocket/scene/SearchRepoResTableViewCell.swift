//
//  SearchRepoResTableViewCell.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/21.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class SearchRepoResTableViewCell: UITableViewCell {
    lazy var avatarView:UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var fullNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.leading.equalTo(avatarView.snp.trailing).offset(8)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(fullNameLabel)
            make.trailing.equalTo(-12)
            make.bottom.equalTo(-8)
        }
    }
    
    func setup(repo:RepoModel){
        avatarView.image = nil
        
        if let url = URL(string: repo.owner.avatar_url ){
            avatarView.sd_setImage(with: url, completed: nil)
        }
        
        fullNameLabel.text = repo.full_name
        descriptionLabel.text = repo.desp
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
