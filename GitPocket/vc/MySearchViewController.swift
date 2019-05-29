//
//  SearchViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/20.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit

class MySearchViewController: UIViewController {
    
    @IBOutlet weak var trendUserCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var trendRepoCollectionView: UICollectionView!

    var trendRepos:[TrendRepoModel] = []
    var trendUsers:[TrendUserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        trendRepoCollectionView.delegate = self
        trendRepoCollectionView.dataSource = self
        
        trendUserCollectionView.delegate = self
        trendUserCollectionView.dataSource = self
        trendRepoCollectionView.register(TrendingRepoCell.self, forCellWithReuseIdentifier: "repo")
        
        trendUserCollectionView.register(TrendingUserCell.self, forCellWithReuseIdentifier: "user")
        
        RepoService.shared.getModels(by: "https://github-trending-api.now.sh/repositories", parameters: nil) { [weak self](models:[TrendRepoModel]) in
            self?.trendRepos = models
            self?.trendRepoCollectionView.reloadData()
        }
        
        RepoService.shared.getModels(by: "https://github-trending-api.now.sh/developers", parameters: nil) { [weak self](models:[TrendUserModel]) in
            self?.trendUsers = models
            self?.trendUserCollectionView.reloadData()
        }
        
        view.viewCallBack = {
            self.setEditing(false, animated: true)
        }
    }
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser"{
            let vc =  segue.destination as? UserViewController
            if let user = sender as? UserModel{
                vc?.userView.setupOthers(with: user)
            }
        }
        else if segue.identifier == "showRepo"{
            let vc = segue.destination as? RepoViewController
            if let repo = sender as? RepoModel{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                    vc?.repoView.setup(repo: repo)
                    vc?.setupTable(repo: repo)
                }
            }
        }
    }
}

extension MySearchViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == trendUserCollectionView{
            return trendUsers.count
        }else{
            return trendRepos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == trendUserCollectionView{
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "user", for: indexPath) as? TrendingUserCell
            
            if cell == nil{
                cell = TrendingUserCell(frame: .zero)
            }
            
            cell?.userView.setup(model: trendUsers[indexPath.row])
            
            return cell!
        }else{
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "repo", for: indexPath) as? TrendingRepoCell
            
            if cell == nil{
                cell = TrendingRepoCell(frame: .zero)
            }
            
            cell?.repoView.setup(model: trendRepos[indexPath.row])
            
            return cell!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == trendRepoCollectionView{
            let repo = trendRepos[indexPath.row]
            let url = "https://api.github.com/repos/\(repo.author ?? "")/\(repo.name ?? "")"
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "repo") as! RepoViewController
            RepoService.shared.getModel(by:url) { (model:RepoModel) in
                vc.repoView.setup(repo: model)
                vc.setupTable(repo: model)
            }
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let url = "https://api.github.com/users/\(trendUsers[indexPath.row].username ?? "")"
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "User") as! UserViewController
            UserService.shared.getModel(by: url) { (model:UserModel) in
                vc.userView.setupOthers(with: model)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MySearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.lowercased(), !text.isEmpty else{
            view.makeToast("Search keyword cannot be empty", duration: 1.0, position: .center)
            searchBar.resignFirstResponder()
            return
        }
        
        switch segmented.selectedSegmentIndex {
        case 0:
            
            SearchService.shared.search(query: text, type: SearchType.repositories) { [weak self](result:SearchRepoModel,url,paras) in
                let vc = RepoListViewController()
                vc.setupTable(url: url, repos: result)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            SearchService.shared.search(query: text, type: SearchType.users) { [weak self](result:SearchUserModel,url,paras) in
                let vc = UserListViewController()
                vc.setupTable(url: url, model: result)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
        
        searchBar.resignFirstResponder()
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(hexString:String){
        //处理数值
        var cString = hexString.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //返回whiteColor
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //存储转换后的数值
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //根据颜色值创建UIColor
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
}

extension CALayer{
    func setCGColorWithColor(color:UIColor){
        self.borderColor = color.cgColor
    }
}
