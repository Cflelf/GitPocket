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
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var titleView:UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 13)
        view.isEditable = false
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var typeIcon:UIImageView = UIImageView()
    
    lazy var dateLabel:UILabel = UILabel()
    
    lazy var subtitleLabel:UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.top.equalTo(12)
            make.width.height.equalTo(24)
        }
        
        contentView.addSubview(typeIcon)
        typeIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(8)
            make.top.equalTo(4)
            make.width.height.equalTo(12)
        }
        
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = ThemeColor
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(typeIcon.snp.trailing).offset(4)
            make.top.equalTo(4)
        }
        
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(12)
            make.top.equalTo(dateLabel.snp.bottom)
            make.trailing.equalTo(-12)
        }
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 11)
        subtitleLabel.numberOfLines = 0
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(12)
            make.top.equalTo(titleView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.trailing.equalTo(-12)
        }
    }
    
    func setCell(timeline:ReceivedEventModel){
        avatarView.image = nil
        titleView.attributedText = nil
        subtitleLabel.text = ""
        dateLabel.text = timeline.created_at
        typeIcon.addColorImage(imageName: "event", color: ThemeColor)
        titleView.appendLinkString(string: timeline.actor?.login ?? "", withURLString: "user:?\(timeline.actor?.url ?? "")")
        
        var type:String = ""

        switch timeline.type {
        case "WatchEvent":
            typeIcon.addColorImage(imageName: "star", color: ThemeColor)
            type = "starred"
        case "ForkEvent":
            typeIcon.addColorImage(imageName: "fork", color: ThemeColor)
            type = "forked"
        case "CreateEvent":
            type = "created"
        case "PublicEvent":
            type = "opened source"
        case "IssueCommentEvent":
            typeIcon.addColorImage(imageName: "issue", color: ThemeColor)
            type = "commented on issue"
        case "DeleteEvent":
            type = "deleted"
        default:
            break
        }
        titleView.appendLinkString(string: " \(type) ")
        
        switch timeline.type{
        case "IssueCommentEvent":
            titleView.appendLinkString(string: "#\(timeline.issue?.number ?? 0) ", withURLString: "issue:?\(timeline.issue?.number ?? 0)")
            titleView.appendLinkString(string: "in ")
            subtitleLabel.text = timeline.comment?.body
        default:
            break
        }
        
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
        let attrs = [NSAttributedString.Key.font : self.font!]
        let appendString = NSMutableAttributedString(string: string, attributes:attrs)
        //判断是否是链接文字
        if withURLString != "" {
            let range:NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value:withURLString, range:range)
            appendString.endEditing()
        }
        //合并新的文本
        attrString.append(appendString)
        
        //设置合并后的文本
        self.attributedText = attrString
    }
}
