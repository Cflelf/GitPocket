//
//  SearchViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/3/20.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit

class MySearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var resultTable: UITableView!
    
    var repoResults:[RepoModel] = []
    var userResults:[UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTable.delegate = self
        resultTable.dataSource = self
        resultTable.register(SearchRepoResTableViewCell.self, forCellReuseIdentifier: "repo")
        resultTable.register(SearchUserResTableViewCell.self, forCellReuseIdentifier: "user")
        
        searchBar.delegate = self
    }
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser"{
            let vc =  segue.destination as? UserViewController
            if let view = vc?.view as? UserView, let user = sender as? UserModel{
                view.setupOthers(with: user)
            }
        }
//        else if segue.identifier == "showRepo"{
//            let vc = segue.destination as? RepoViewController
//            if let repo = sender as? RepoModel{
//                vc?.repoView.setup(repo: repo)
//            }
//        }
    }
}

extension MySearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.lowercased() else{
            return
        }
        
        switch segmented.selectedSegmentIndex {
        case 0:
            SearchService.shared.search(query: text, type: SearchType.repositories) { (result:SearchRepoModel) in
                self.repoResults = result.items ?? []
                self.resultTable.reloadData()
            }
        case 1:
            SearchService.shared.search(query: text, type: SearchType.users) { (result:SearchUserModel) in
                self.userResults = result.items ?? []
                self.resultTable.reloadData()
            }
        default:
            break
        }
        
        searchBar.resignFirstResponder()
    }
}

extension MySearchViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case resultTable:
            switch segmented.selectedSegmentIndex{
            case 0:
                return repoResults.count
            case 1:
                return userResults.count
            default:
                return 0
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case resultTable:
            switch segmented.selectedSegmentIndex{
            case 0:
                var cell = tableView.dequeueReusableCell(withIdentifier: "repo", for: indexPath) as? SearchRepoResTableViewCell
                if cell == nil {
                    cell = SearchRepoResTableViewCell(style: .default, reuseIdentifier: "repo")
                }
                cell?.setup(repo: repoResults[indexPath.row])
                return cell!
            default:
                var cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as? SearchUserResTableViewCell
                if cell == nil {
                    cell = SearchUserResTableViewCell(style: .default, reuseIdentifier: "user")
                }
                cell?.setup(user: userResults[indexPath.row])
                return cell!
            }
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "type")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case resultTable:
            switch segmented.selectedSegmentIndex{
            case 0:
//                performSegue(withIdentifier: "showRepo", sender: repoResults[indexPath.row])
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "repo") as? RepoViewController
                vc?.repoView.setup(repo: repoResults[indexPath.row])
                vc?.setupTable(repo: repoResults[indexPath.row])
                navigationController?.pushViewController(vc!, animated: true)
            case 1:
                performSegue(withIdentifier: "showUser", sender: userResults[indexPath.row])
            default:
                return
            }
            return
        default:
            return
        }
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
}

extension CALayer{
    func setCGColorWithColor(color:UIColor){
        self.borderColor = color.cgColor
    }
}
