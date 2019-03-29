//
//  TimeLineViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/16.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import SDWebImage

class TimeLineViewController:UIViewController{
    @IBOutlet weak var tableview: UITableView!
    
    var dataArray:[ReceivedEventModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setup), name: NSNotification.Name.init("LoginSuccess"), object: nil)
        
        tableview.register(TimeLineTableViewCell.self, forCellReuseIdentifier: "timeline")
        tableview.delegate = self
        tableview.dataSource = self
        
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getTimeLine(user:UserModel){
        UserService.shared.getModels(by: user.received_events_url, completionHandler: { (timelines:[ReceivedEventModel]) in
            self.dataArray = timelines
            self.tableview.reloadData()
        })
    }
    
    @objc func setup(){
        if let key = ACCESS_KEY{
            
            if let user = UserDataService.shared.getUser(by: key){
                UserService.shared.currentUser = user
                getTimeLine(user: user)
            }else{
                UserService.shared.getMyInfo{ (model) in
                    self.getTimeLine(user: model)
                }
            }
            
        }else{
            parent?.performSegue(withIdentifier: "addAccount", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser"{
            let vc = segue.destination as? UserViewController
            if let view = vc?.view as? UserView,let str = sender as? String{
                UserService.shared.getModel(by: str) { (user:UserModel) in
                    view.setupOthers(with: user)
                }
            }
        }else if segue.identifier == "showRepo"{
            let vc = segue.destination as? RepoViewController
            if let str = sender as? String{
                RepoService.shared.getModel(by: str) { (repo:RepoModel) in
                    vc?.repoView.setup(repo:repo)
                    vc?.setupTable(repo: repo)
                }
            }
        }
    }
}

extension TimeLineViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        var cell = tableView.dequeueReusableCell(withIdentifier: "timeline", for: indexPath) as? TimeLineTableViewCell
        
        if cell == nil{
            cell = TimeLineTableViewCell(style: .default, reuseIdentifier: "timeline")
        }
        
        cell?.setCell(timeline: dataArray[indexPath.row])
        
        cell?.titleView.delegate = self
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension TimeLineViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let scheme = URL.scheme{
            switch scheme{
            case "user":
                //跳转到user
                performSegue(withIdentifier: "showUser", sender: URL.absoluteString.split(separator: "?").last)
            case "repo":
                //跳转到repo
                performSegue(withIdentifier: "showRepo", sender: URL.absoluteString.split(separator: "?").last)
            default:
                break
            }
        }
        return true
    }
}
