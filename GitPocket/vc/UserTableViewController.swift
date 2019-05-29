//
//  UserTableViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/26.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit

class UserViewController: UIViewController{
    
    lazy var userView:UserView = UserView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 273))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(userView)
        
        userView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    //视图将要消失
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension UserViewController: UserViewDelegate{
    func tapToUserList(url: String, title: String) {
        let vc = UserListViewController()
        vc.title = title
        vc.setupTable(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tapRepo(url: String) {
        let vc = RepoListViewController()
        vc.setupTable(url: url)
        vc.title = "Repos"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserViewController: UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class UserTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("stars")
        case 1:
            print("events")
        default:
            break
        }
    }
}
