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
import DJTableViewVM

class MineViewController: UIViewController{
    
    lazy var userView: UserView = UserView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 273))
    var tableviewVM:DJTableViewVM!
    
    var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    lazy var settingIcon:UIImageView = UIImageView(image: UIImage(named: "setting"))
    let section = DJTableViewVMSection(headerHeight: 20)
    lazy var user = UserService.shared.currentUser
    lazy var isOwner:Bool = true
    let basicSection = DJTableViewVMSection(headerHeight: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(notify), name: NSNotification.Name.init("LoginSuccess"), object: nil)
        
        tableView.contentInsetAdjustmentBehavior = .never
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.tableHeaderView = userView
        userView.delegate = self
        
        tableviewVM = DJTableViewVM(tableView: tableView)
    
        section.addRows(from: [("Star","star_theme"),("Event","event"),("Organization","org")].map({ (str,str2) -> DJTableViewVMRow in
            let row = DJTableViewVMRow()
            row.titleFont = UIFont.systemFont(ofSize: 13)
            row.title = str
            row.image = UIImage(named: str2)
            row.accessoryType = .disclosureIndicator
            return row
        }))
        
        view.addSubview(settingIcon)
        settingIcon.snp.makeConstraints { (make) in
            make.top.equalTo(isIphoneX() ? 44:16)
            make.trailing.equalTo(-20)
            make.width.height.equalTo(24)
        }
        settingIcon.viewCallBack = {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addAccount") as! AddAccountViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if let user = user{
            setup(with: user)
        }
        
        tableviewVM.addSection(section)
        tableviewVM.addSection(basicSection)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func notify(){
        if let user = UserService.shared.currentUser{
            setup(with: user)
        }
    }
    
    func setup(with user:UserModel){
        
        if isOwner{
            basicSection.addRows(from: [("Company","company",user.company),("Blog","blog",user.blog),("Location","location",user.location),("E-mail","email",user.email)].map({ (str,str2,value) -> DJTableViewVMRow in
                let row = DJTableViewVMRow()
                row.titleFont = UIFont.systemFont(ofSize: 13)
                row.title = str
                row.style = .value1
                row.detailText = value
                row.image = UIImage(named: str2)
                return row
            }))
            tableviewVM.reloadData()
        }
        
        userView.setup(with: user)
        
        (section.rows?.first as? DJTableViewVMRow)?.selectionHandler = { [weak self]_ in
            let vc = RepoListViewController()
            vc.setupTable(url: user.starred_url)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        (section.rows?[1] as? DJTableViewVMRow)?.selectionHandler = { [weak self]_ in
            let vc = EventListViewController()
            vc.setupTable(url: user.events_url)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableviewVM.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}

extension MineViewController: UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MineViewController: UserViewDelegate{
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
