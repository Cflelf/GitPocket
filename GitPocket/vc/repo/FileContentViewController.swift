//
//  FileContentViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/30.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import Highlightr
import MarkdownView

class FileContentViewController: UIViewController{
    
    lazy var textView:UITextView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textView)
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupContent(str:String,fileName:String){
        
        guard let fileType = fileName.split(separator: ".").last else{
            textView.text = str
            return
        }
        
        if let str = str.base64Decoded(){
            if fileType == "md" || fileType.lowercased() == "markdown"{
                let mdView = MarkdownView()
                view.addSubview(mdView)
                mdView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                mdView.load(markdown: str)
            }else{
                let highlightr = Highlightr()
                highlightr?.setTheme(to: "paraiso-dark")
                let code = str
                // You can omit the second parameter to use automatic language detection.
                let highlightedCode = highlightr?.highlight(code, as: String(fileType))
                
                if highlightedCode?.string == "undefined"{
                    textView.text = str
                }else{
                    textView.attributedText = highlightedCode
                }
                
            }
        }else if let img = str.base64DecodedImage(){
            let imageView = UIImageView(image: img)
            
            view.addSubview(imageView)
            
            imageView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.width.height.lessThanOrEqualToSuperview()
            }
        }
    }
}
