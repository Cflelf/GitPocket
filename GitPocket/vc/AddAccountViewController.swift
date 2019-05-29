//
//  ViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/2/26.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import DJTableViewVM
import SDWebImage
import NVActivityIndicatorView

class AddAccountViewController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!

    var users:[UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        navigationController?.navigationItem.hidesBackButton = true
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.backItem?.setHidesBackButton(true, animated: true)
        
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAccount))
        item.tintColor = .white
        navigationItem.rightBarButtonItem = item
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchUserResTableViewCell.self, forCellReuseIdentifier: "user")
        
        users = UserDataService.shared.getAllUsers()
        
        if users.isEmpty{
            emptyView.isHidden = false
        }else{
            
            emptyView.isHidden = true
            tableView.reloadData()
        }
    }
    
    @objc func addAccount(){
        performSegue(withIdentifier: "login", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddAccountViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as? SearchUserResTableViewCell
        if cell == nil {
            cell = SearchUserResTableViewCell(style: .default, reuseIdentifier: "user")
        }
        cell?.setup(user: users[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        startAnimating(CGSize(width: 32, height: 32), message: "Login in as \(user.login)", messageFont: UIFont.systemFont(ofSize: 12), type: .lineScale)
        UserDefaults.standard.set(user.access_token, forKey: GITHUB_ACCESS_KEY)
        UserService.shared.getMyInfo { [weak self](model) in
            self?.navigationController?.popViewController(animated: true)
            self?.stopAnimating()
        }
    }
}



