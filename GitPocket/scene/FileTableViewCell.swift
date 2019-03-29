//
//  FileTableViewCell.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/29.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import SnapKit
import DJTableViewVM

class FileTableViewRow: DJTableViewVMRow{
    var file:RepoContentModel?
    
    override init() {
        super.init()
        cellHeight = 44
    }
}

class FileTableViewCell: DJTableViewVMCell {
    
    lazy var typeView:UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titleView:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = ThemeColor
        return view
    }()
    
    lazy var sizeLabel:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 10)
        view.textColor = ThemeColor
        return view
    }()
    
    override func cellDidLoad() {
        super.cellDidLoad()
        
        contentView.addSubview(typeView)
        typeView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.leading.equalTo(typeView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(sizeLabel)
        sizeLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.centerY.equalToSuperview()
        }
    }
    
    override func cellWillAppear() {
        super.cellWillAppear()
        
        guard let row = rowVM as? FileTableViewRow else{
            return
        }
        
        typeView.image = UIImage(named: row.file?.type ?? "file")
        titleView.text = row.file?.name
        sizeLabel.text = "\(row.file?.size ?? 0) KB"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

