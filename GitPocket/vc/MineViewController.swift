//
//  UserViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/22.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class MineViewController: UIViewController{
    
    @IBOutlet weak var userView: UserView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = UserService.shared.currentUser{
            userView.setup(with: user)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
