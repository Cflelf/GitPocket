//
//  Constant.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/28.
//  Copyright © 2019 潘潇睿. All rights reserved.
//
import UIKit

let ThemeColor = UIColor(netHex: 0x595959)

func base64Decoding(encodedString:String)->String{
    let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
    let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
    return decodedString
}
