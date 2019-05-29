//
//  TrendingRepoView.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/4/6.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit

class TrendingRepoCell: UICollectionViewCell{
    lazy var repoView:TrendingRepoView = TrendingRepoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(repoView)
        repoView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TrendingRepoView: UIView{
    
    @IBOutlet weak var increaseLabel: UILabel!
    @IBOutlet weak var forkIcon: UIImageView!
    @IBOutlet weak var starIcon: UIImageView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var despLabel: UILabel!
    @IBOutlet weak var repoLabel: UILabel!
    
    @IBOutlet weak var lanIcon: UIImageView!
    @IBOutlet weak var lanLabel: UILabel!
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
        
        starIcon.addColorImage(imageName: "star", color: ThemeColor)
        forkIcon.addColorImage(imageName: "fork", color: ThemeColor)
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }
    
    func setup(model:TrendRepoModel){
        forkLabel.text = model.forks?.format()
        starLabel.text = model.stars?.format()
        lanLabel.text = model.language ?? "-"
        lanIcon.addColorImage(imageName: "language", color: UIColor(hexString: model.languageColor ?? ""))
        repoLabel.text = "\(model.author ?? "")/\(model.name ?? "")"
        despLabel.text = model.desp
        increaseLabel.text = model.currentPeriodStars?.format()
    }
}
