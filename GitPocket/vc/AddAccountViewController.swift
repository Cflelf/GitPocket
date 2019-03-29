//
//  ViewController.swift
//  GitPocket
//
//  Created by 潘潇睿 on 2019/2/26.
//  Copyright © 2019 潘潇睿. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        navigationController?.navigationItem.hidesBackButton = true
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.backItem?.setHidesBackButton(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

