//
//  TimeLineViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/16.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
import NVActivityIndicatorView

class TimeLineViewController:UIViewController, NVActivityIndicatorViewable{
    var tableview: MyTableView = MyTableView(frame: .zero)
    
    var dataArray:[ReceivedEventModel] = []
    
    let header = MJRefreshNormalHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: NSNotification.Name.init("LoginSuccess"), object: nil)
        
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableview.register(TimeLineTableViewCell.self, forCellReuseIdentifier: "timeline")
        tableview.delegate = self
        tableview.dataSource = self
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd hh:mm:ss"
        header.lastUpdatedTimeText = { (date)->String in
            if let date = date{
                return "Last updated at \(dateFormat.string(from: date))"
            }
            return ""
        }
        header.setTitle("Pull", for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Refreshing", for: .refreshing)
        tableview.mj_header = header
        header.setRefreshingTarget(self, refreshingAction: #selector(setup))
        tableview.foot.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        
        setup()
    }
    
    @objc func notify(){
        if let user = UserService.shared.currentUser{
            getTimeLine(user: user)
        }
    }
    
    @objc func footerRefresh(){
        UserService.shared.getModels(by: tableview.url, parameters: ["page":tableview.index+1], completionHandler: { [weak self](timelines:[ReceivedEventModel]) in
            if timelines.isEmpty{
                self?.tableview.mj_footer.resetNoMoreData()
                self?.tableview.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self?.dataArray.append(contentsOf: timelines)
                self?.tableview.mj_footer.endRefreshing()
                self?.tableview.reloadData()
                self?.tableview.index = (self?.tableview.index ?? 0) + 1
            }
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getTimeLine(user:UserModel){
        tableview.url = user.received_events_url
        UserService.shared.getModels(by: user.received_events_url, parameters: nil, completionHandler: { [weak self](timelines:[ReceivedEventModel]) in
            self?.dataArray = timelines
            self?.tableview.reloadData()
            self?.tableview.mj_header.endRefreshing()
            self?.stopAnimating()
        })
    }
    
    @objc func setup(){
        startAnimating(CGSize(width: 32, height: 32),type: .lineScale)
        if ACCESS_KEY != nil{
            UserService.shared.getMyInfo { [weak self](model) in
                UserDataService.shared.modifyUser(user: model)
                self?.getTimeLine(user: model)
            }
        }else{
            parent?.performSegue(withIdentifier: "addAccount", sender: nil)
            stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser"{
            let vc = segue.destination as? UserViewController
            if let str = sender as? String{
                UserService.shared.getModel(by: str) { (user:UserModel) in
                    vc?.userView.setupOthers(with: user)
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
}

extension TimeLineViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let scheme = URL.scheme{
            switch scheme{
            case "user":
                //跳转到user
                startAnimating(CGSize(width: 32, height: 32),type: .lineScale)
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mine") as? MineViewController
                vc?.isOwner = false
                UserService.shared.getModel(by: String(URL.absoluteString.split(separator: "?").last ?? "")) { [weak self](user:UserModel) in
                    vc?.user = user
                    vc?.userView.setupOthers(with: user)
                    self?.stopAnimating()
                    self?.navigationController?.pushViewController(vc!, animated: true)
                }
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
