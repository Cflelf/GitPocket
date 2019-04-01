//
//  Constant.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/28.
//  Copyright © 2019 潘潇睿. All rights reserved.
//
import UIKit

let ThemeColor = UIColor(netHex: 0x595959)

let LightGreyColor = UIColor(netHex: 0xf0f3f6).withAlphaComponent(0.8)

extension String{
    func format()->String{
        if let startIndex = self.firstIndex(of: "{"){
            return String(self[..<startIndex])
        }
        
        return self
    }
    
    func base64Decoded() -> String? {
        let decodedData = Data(base64Encoded: self.replacingOccurrences(of: "\n", with: ""))!
        if let decodedString = String(data: decodedData, encoding: .utf8){
            return decodedString
        }
        
        return nil
    }
    
    func base64DecodedImage() -> UIImage?{
        if let data = Data(base64Encoded: self.replacingOccurrences(of: "\n", with: "")){
            return UIImage(data:data)
        }
        return nil
    }
}

typealias buttonClickBlock = (() -> ())

extension UIButton {
    private struct RuntimeKey {
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
    }
    var callBack: buttonClickBlock? {
        get {
            return objc_getAssociatedObject(self, UIButton.RuntimeKey.actionBlock!) as? buttonClickBlock
        }
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.actionBlock!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    convenience init(type:UIButtonType) {
        self.init()
        self.addTarget(self, action: #selector(tapped(button:)), for: .touchUpInside)
    }
    
    @objc func tapped(button:UIButton){
        if self.callBack != nil {
            self.callBack!()
        }
    }
}

typealias viewClick = (() -> ())

extension UIView {
    private struct RuntimeKey {
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
        static let actionBlock2 = UnsafeRawPointer.init(bitPattern: "actionBlock2".hashValue)
    }
    var viewCallBack : viewClick? {
        get {
            return objc_getAssociatedObject(self, UIButton.RuntimeKey.actionBlock!) as? buttonClickBlock
        }
        set {
            self.isUserInteractionEnabled = true
            objc_setAssociatedObject(self, UIButton.RuntimeKey.actionBlock!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setUpViewClick()
        }
        
    }
    
    @objc func tapView() {
        if self.viewCallBack != nil {
            self.viewCallBack!()
        }
    }
    
    func setUpViewClick() {
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapView))
        
        self.addGestureRecognizer(gesture)
    }
}
