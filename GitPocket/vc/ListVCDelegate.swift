//
//  ListViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/4/2.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit

protocol ListVCDelegate: NSObjectProtocol{
    var tableView:MyTableView {get set}
}
