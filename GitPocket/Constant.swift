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

func isIphoneX()->Bool{
    let window = UIApplication.shared.delegate?.window
    // 获取底部安全区域高度，iPhone X 竖屏下为 34.0，横屏下为 21.0，其他类型设备都为 0
    let bottomSafeInset = window??.safeAreaInsets.bottom
    if (bottomSafeInset == 34.0 || bottomSafeInset == 21.0) {
        return true
    }
    return false
}

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
    
//    func dateFormat()->String{
//        let currentDate = Date()
//        let dateFormat = DateFormatter()
//        dateFormat.dateFormat = "YYYY-MM-DDTHH:mm:ssZ"
//        
//        guard let date = dateFormat.date(from: self) else{
//            return String(self.split(separator: "T").first ?? "")
//        }
//        
//        let calendar = NSCalendar.current
//        let unitFlags:NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month , NSCalendar.Unit.day , NSCalendar.Unit.hour , NSCalendar.Unit.minute , NSCalendar.Unit.second]
//        let components = calendar.dateComponents(unitFlags, from: date, to: currentDate)
//        
//        let timeDifference = "\(components.year)" + "年" + "\(components.month)" + "个月"
//        let timeDifferences = "两个日期的时间差是:" + timeDifference + "\(components.day)" + "天"
//        return ""
//    }
    
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
    convenience init(type:UIButton.ButtonType) {
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

extension UIImageView{
    func addColorImage(imageName:String,color:UIColor){
        self.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
