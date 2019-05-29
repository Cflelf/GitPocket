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
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
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
    
    lazy var starImage:UIImageView = UIImageView()
    lazy var watchImage:UIImageView = UIImageView()
    lazy var forkImage:UIImageView = UIImageView()
    
    lazy var starLabel:UILabel = UILabel()
    lazy var watchLabel:UILabel = UILabel()
    lazy var forkLabel:UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.width.height.equalTo(32)
            make.top.equalTo(8)
        }
        
        contentView.addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.leading.equalTo(avatarView.snp.trailing).offset(8)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(fullNameLabel)
            make.trailing.equalTo(-12)
        }
        
        starImage.addColorImage(imageName: "star", color: ThemeColor)
        contentView.addSubview(starImage)
        starImage.snp.makeConstraints { (make) in
            make.leading.equalTo(fullNameLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.bottom.equalTo(-8)
            make.width.height.equalTo(16)
        }
        
        starLabel.font = UIFont.systemFont(ofSize: 11)
        contentView.addSubview(starLabel)
        starLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(starImage.snp.trailing).offset(4)
            make.centerY.equalTo(starImage)
        }
        
        watchImage.addColorImage(imageName: "watch", color: ThemeColor)
        contentView.addSubview(watchImage)
        watchImage.snp.makeConstraints { (make) in
            make.leading.equalTo(starLabel.snp.trailing).offset(8)
            make.centerY.equalTo(starImage)
            make.width.height.equalTo(16)
        }
        
        watchLabel.font = UIFont.systemFont(ofSize: 11)
        contentView.addSubview(watchLabel)
        watchLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(watchImage.snp.trailing).offset(8)
            make.centerY.equalTo(starImage)
        }
        
        forkImage.addColorImage(imageName: "fork", color: ThemeColor)
        contentView.addSubview(forkImage)
        forkImage.snp.makeConstraints { (make) in
            make.leading.equalTo(watchLabel.snp.trailing).offset(8)
            make.centerY.equalTo(starImage)
            make.width.height.equalTo(16)
        }
        
        forkLabel.font = UIFont.systemFont(ofSize: 11)
        contentView.addSubview(forkLabel)
        forkLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(forkImage.snp.trailing).offset(4)
            make.centerY.equalTo(starImage)
        }
    }
    
    func setup(repo:RepoModel){
        avatarView.image = nil
        
        if let url = URL(string: repo.owner.avatar_url ){
            avatarView.sd_setImage(with: url, completed: nil)
        }
        
        fullNameLabel.text = repo.full_name
        descriptionLabel.text = repo.desp
        starLabel.text = "\(repo.stargazers_count)"
        watchLabel.text = "\(repo.subscribers_count)"
        forkLabel.text = "\(repo.forks)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
