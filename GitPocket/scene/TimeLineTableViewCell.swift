//
//  TimeLineTableViewCell.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/17.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import SnapKit

class TimeLineTableViewCell: UITableViewCell {
    
    lazy var avatarView:UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var titleView:UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 12)
        view.isEditable = false
        view.isScrollEnabled = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-12)
            make.height.lessThanOrEqualTo(50)
        }
    }
    
    func setCell(timeline:ReceivedEventModel){
        avatarView.image = nil
        titleView.attributedText = nil
        
        var type:String = ""
        switch timeline.type {
        case "WatchEvent":
            type = "starred"
        case "ForkEvent":
            type = "forked"
        case "CreateEvent":
            type = "created"
        case "PublicEvent":
            type = "opened source"
        default:
            break
        }
        
        titleView.appendLinkString(string: timeline.actor?.login ?? "", withURLString: "user:?\(timeline.actor?.url ?? "")")
        
        titleView.appendLinkString(string: " \(type) ")
        titleView.appendLinkString(string: timeline.repo?.name ?? "", withURLString: "repo:?\(timeline.repo?.url ?? "")")
        
        if let url = URL(string: timeline.actor?.avatar_url ?? ""){
            avatarView.sd_setImage(with: url, completed: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UITextView {
    //添加链接文本（链接为空时则表示普通文本）
    func appendLinkString(string:String, withURLString:String = "") {
        //原来的文本内容
        let attrString:NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(self.attributedText)
        
        //新增的文本内容（使用默认设置的字体样式）
        let attrs = [NSAttributedStringKey.font : self.font!]
        let appendString = NSMutableAttributedString(string: string, attributes:attrs)
        //判断是否是链接文字
        if withURLString != "" {
            let range:NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedStringKey.link, value:withURLString, range:range)
            appendString.endEditing()
        }
        //合并新的文本
        attrString.append(appendString)
        
        //设置合并后的文本
        self.attributedText = attrString
    }
}
